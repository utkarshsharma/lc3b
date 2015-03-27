module ALU(clk, opval, D, A1, shiftop, amount4, A2, N, Z, P);

input clk;
input  wire [1:0] opval;  // operation
input  wire [1:0] shiftop;
input  wire [3:0] amount4;
input  wire [15:0] A1;   // first input
input  wire [15:0] A2;   // second input
output reg [15:0] D;  // output
output reg N, P, Z;

always @(posedge clk) begin
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
	Z	= (D == 16'b0)		? 1 : 0;
	P	= (D[15] > 16'b0)	? 1 : 0;
	N	= (D[15] < 16'b0) ? 1 : 0;
end
endmodule