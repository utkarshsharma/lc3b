module RegFile( take_data, dr_in, dr, sr1, sr2, clk, rst, sr1_out, sr2_out);
	input clk, rst;
	input wire  [15:0]dr_in; // input from ALU
	input wire  take_data; // write data to destination register?
	input wire  [2:0] dr; // destination register index
	input wire  [2:0] sr1; // source register 1 index
	input wire  [2:0] sr2; // source register 2 index
	output reg [15:0]sr1_out; // source register 1 output
	output reg [15:0]sr2_out; // source register 2 output
   
 	 // actual internal registers
   reg [15:0]R[0:7];



always @(posedge clk) begin
	if (rst) begin
		R[0] <= 0; R[1] <= 0; R[2] <= 0; R[3] <= 0;
		R[4] <= 0; R[5] <= 0; R[6] <= 0; R[7] <= 0;
		end
	else
	sr1_out = R[sr1];
   sr2_out = R[sr2];
	
	if (take_data)
	R[dr] <= dr_in;
end
endmodule