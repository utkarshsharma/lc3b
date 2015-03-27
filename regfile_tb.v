    module regfile_tb;
	 
	wire [15:0] A1;        // Reg Output 1
	wire [15:0] A2;        // Reg Output 2
 
	reg [2:0] sr1;        // Source Register1 Select
	reg [2:0] sr2;        // Source Register2 Select
	reg [2:0] dr;         // Destination Register Select
 
	reg [15:0] dr_in;        // from Memory
	reg wr;        // from Controller
	reg clock, reset;        // from Testbench
	 
	 RegFile a(.sr1_out(A1) , .sr2_out(A2), .sr1(sr1), .sr2(sr2), .dr(dr), .dr_in(dr_in) , .Write(wr), .clk(clock), .rst(reset) );

    initial begin
        $dumpfile("regfile.vcd");
        $dumpvars(0, a);
        
		#5 reset = 1; wr=0;
		$display("%g RESET ON SR1:%d, SR2:%d, dr:%d, SR1_out:%d, SR2_out:%d, dr_in:%d, Reset=%d, Write=%d, Clock=%d", $time,sr1,sr2,dr,A1,A2,dr_in,reset, wr, clock);
		
        //reset all values to zero
		
		#5 reset =0; wr=1; sr1 = 3'b000; sr2 = 3'b001; dr = 3'b111; dr_in = 16'd23; 
		$display("%g SR1:%d, SR2:%d, dr:%d, SR1_out:%d, SR2_out:%d, dr_in:%d, Reset=%d, Write=%d, Clock=%d", $time,sr1,sr2,dr,A1,A2,dr_in,reset, wr, clock);
		
		#5 reset =0; wr=1;sr1 = 3'b000; sr2 = 3'b111; dr = 3'b111; dr_in = 16'd23; 
		$display("%g SR1:%d, SR2:%d, dr:%d, SR1_out:%d, SR2_out:%d, dr_in:%d, Reset=%d, Write=%d, Clock=%d", $time,sr1,sr2,dr,A1,A2,dr_in,reset, wr, clock);
		
        #5 wr = 0;
        #5 $display("done"); $finish;
    end

    always begin
        #5 clock=~clock; // tick
    end
	 
endmodule

module RegFile( Write, dr_in, dr, sr1, sr2, clk, rst, sr1_out, sr2_out);
	input clk, rst;
	input wire  [15:0]dr_in; // input from ALU
	input wire  Write; // write data to destination register?
	input wire  [2:0] dr; // destination register index
	input wire  [2:0] sr1; // source register 1 index
	input wire  [2:0] sr2; // source register 2 index
	output wire [15:0]sr1_out; // source register 1 output
	output wire [15:0]sr2_out; // source register 2 output
   
 	 // actual internal registers
   reg [15:0]R[0:7];
	initial begin
	R[0] <= 5; R[1] <= 5; R[2] <= 5; R[3] <= 5;
	R[4] <= 5; R[5] <= 5; R[6] <= 5; R[7] <= 5;
	end


	assign sr1_out = R[sr1];
   assign sr2_out = R[sr2];
	
always @(clk) begin
	if (rst) begin
		R[0] <= 0; R[1] <= 0; R[2] <= 0; R[3] <= 0;
		R[4] <= 0; R[5] <= 0; R[6] <= 0; R[7] <= 0;
		end
end
always @(Write) begin
	R[dr] = dr_in; end
endmodule