module alu_tb;

    reg [1:0] opval = 2'b0; // operation
    reg [15:0] SR1 = 16'b0; // first input
    reg [15:0] SR2 = 16'b0; // second input
    wire  n= 0;wire p=0;wire z=0;
	 reg [3:0] am = 0;
	 reg [1:0] shift = 0;
    reg clk = 0; // clock
    wire [15:0] DR; // output

    ALU a(.clk(clk), .opval(opval), .D(DR), .A1(SR1), .shiftop(shift), .amount4(am), .A2(SR2), .N(n), .Z(z), .P(p));


    initial begin
        $dumpfile("alu.vcd");
        $dumpvars(0, a);

        // ADD tests
        opval = 00;
        #5 SR1 =  16'd1; SR2 =  16'd2;
		  #5
		  $display("%g ADD output:%d,opval=%d,SR1=%d,SR2=%d,N=%d,P=%d,Z=%d, clk=%d",$time, DR,opval,SR1,SR2,n,p,z,clk);
		  
		  #5 SR1 =  16'h00FF; SR2 =  16'h8100;
        #5
		  $display("%g ADD output:%d,opval=%d,SR1=%d,SR2=%d,N=%d,P=%d,Z=%d, clk=%d",$time, DR,opval,SR1,SR2,n,p,z,clk);
		  
        #5 SR1 =  16'h8000; SR2 =  16'h8000; // overflow
        #5
		  $display("%g ADD output:%d,opval=%d,SR1=%d,SR2=%d,N=%d,P=%d,Z=%d, clk=%d",$time, DR,opval,SR1,SR2,n,p,z,clk);
		  
		  // AND tests
        opval = 01;
        #5 SR1 =  16'h1; SR2 =  16'h2;
		  #5
		  $display("%g AND output:%d,opval=%d,SR1=%d,SR2=%d,N=%d,P=%d,Z=%d, clk=%d",$time, DR,opval,SR1,SR2,n,p,z,clk);
		  
        #5 SR1 =  16'hA; SR2 =  16'h7;
        #5
		  $display("%g AND output:%d,opval=%d,SR1=%d,SR2=%d,N=%d,P=%d,Z=%d, clk=%d",$time, DR,opval,SR1,SR2,n,p,z,clk);
		  
		  // XOR tests
        opval = 10;
        #5 SR1 =  16'h1; SR2 =  16'h2;
        #5
		  $display("%g XOR output:%d,opval=%d,SR1=%d,SR2=%d,N=%d,P=%d,Z=%d, clk=%d",$time, DR,opval,SR1,SR2,n,p,z,clk);
		  
		  #5 SR1 =  16'hA; SR2 =  16'h7;
		  #5
		  $display("%g XOR output:%d,opval=%d,SR1=%d,SR2=%d,N=%d,P=%d,Z=%d, clk=%d",$time, DR,opval,SR1,SR2,n,p,z,clk);
		  
        // SHIFT tests
        opval = 11;
        #5 SR1 =  16'h1; SR2 =  16'h2; #5 shift = 2'b00; #5 am = 4'b0101;
		  #5
		  $display("%g LSHIFT output:%d,opval=%d,SR1=%d,shiftop=%d,amount4=%d,N=%d,P=%d,Z=%d, clk=%d",$time, DR,opval,shift,am,n,p,z,clk);
		  
        #5 SR1 =  16'hA; SR2 =  16'h7; #5 shift = 2'b10; #5 am = 4'b0110;
        #5
		  $display("%g RSHIFTL output:%d,opval=%d,SR1=%d,shiftop=%d,amount4=%d,N=%d,P=%d,Z=%d, clk=%d",$time, DR,opval,SR1,shift,am,n,p,z,clk);
		  
		  #5 SR1 =  16'hdead; SR2 =  16'h0; #5 shift = 2'b11; #5 am = 4'b1101;
		  #5
		  $display("%g RSHIFTA output:%d,opval=%d,SR1=%d,shiftop=%d,amount4=%d,N=%d,P=%d,Z=%d, clk=%d",$time, DR,opval,SR1,shift,am,n,p,z,clk);
			
		  #5
        #5 $display("done"); $finish;
    end

    always begin
        #5 clk=~clk; // tick
    end
endmodule

module ALU(clk, opval, D, A1, shiftop, amount4, A2, N, Z, P);

input clk;
input  wire [1:0] opval;  // operation
input  wire [1:0] shiftop;
input  wire [3:0] amount4;
input  wire signed[15:0] A1;   // first input
input  wire signed[15:0] A2;   // second input
output reg signed [15:0] D;  // output
output wire N, P, Z;

always @(clk) begin
	if (opval == 00)D =   A1 + A2;
	else if (opval == 01)D = A1 & A2;
	else if (opval ==  10) D = A1 ^ A2;
	else if (opval == 11) begin
		case (shiftop[1:0])
			2'b00 : D = A1[15:0] << amount4[3:0];
			2'b01 : D = A1[15:0] >> amount4[3:0];
			2'b11 :
			repeat(amount4+1) begin
				D = A1[15:0] >> 1;
				D[15]=A1[15];
				end
		endcase
	end
end
	assign Z	= (D == 16'b0)	? 1'b1 : 0;
	assign N	= (D[15] == 1)  ? 1'b1 : 0;
	assign P = (|D !=0 & D[15]==0) ? 1'b1 : 0;
endmodule