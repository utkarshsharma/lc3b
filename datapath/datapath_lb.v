module store_mux(dr_out, to_mdr_mux, ctrl);
input wire [15:0]dr_out;
input wire ctrl;
output wire [7:0]to_mdr_mux;

assign to_mdr_mux = (ctrl == 0) ? dr_out[15:8] : dr_out[7:0];
endmodule

module mdr_mux(out8_to_mdr, inout16_mdr, dr_out, from_store_mux, to_dr_in, to_ir, ctrl);
output reg [7:0]out8_to_mdr;
inout reg [15:0]inout16_mdr;

input wire [1:0]ctrl;
input wire [7:0]from_store_mux;
input wire [15:0]dr_out;

output reg [15:0]to_dr_in;
output reg [15:0]to_ir;

always @(*) begin
		case (ctrl[1:0])
		(2'b00) : out8_to_mdr = from_store_mux;
		(2'b01) : inout16_mdr = dr_out;
		(2'b10) : to_dr_in = inout16_mdr;
		(2'b11) : to_ir = inout16_mdr;
		endcase
	end
endmodule

module mdr8_16(mem8, mem16, inout16_mdr, in8_mdr, load_mdr);
output reg[7:0]mem8;
inout reg [15:0]mem16;
inout reg [15:0]inout16_mdr;
input wire [7:0]in8_mdr;
input wire load_mdr;

always @(posedge load_mdr) begin
	mem8 <= in8_mdr;
	mem16 <= inout16_mdr;
	inout16_mdr <= mem16;
	end
endmodule

module sext8(in, out, sext8_ctrl);
input wire [15:0]in;
input wire sext8_ctrl;
output reg [15:0]out;

always @ (*) begin
out[7:0] <= in[7:0];
out[8] <= (sext8_ctrl == 1) ? in[7] : in[8];
out[9] <= (sext8_ctrl == 1) ? in[7] : in[9];
out[10] <= (sext8_ctrl == 1) ? in[7] : in[10];
out[11] <= (sext8_ctrl == 1) ? in[7] : in[11];
out[12] <= (sext8_ctrl == 1) ? in[7] : in[12];
out[13] <= (sext8_ctrl == 1) ? in[7] : in[13];
out[14] <= (sext8_ctrl == 1) ? in[7] : in[14];
out[15] <= (sext8_ctrl == 1) ? in[7] : in[15];
end
endmodule

module sext5(in, out);
input wire [4:0]in;
output wire [15:0]out;

assign out={in[4],in[4],in[4],in[4],in[4],in[4],in[4],in[4],in[4],in[4],in[4],in[4:0]};
endmodule

module sext6(in, out);
input wire [5:0]in;
output wire [15:0]out;

assign out={in[5],in[5],in[5],in[5],in[5],in[5],in[5],in[5],in[5],in[5],in[5:0]};
endmodule

module sext9(in, out);
input wire [8:0]in;
output wire [15:0]out;

assign out={in[8],in[8],in[8],in[8],in[8],in[8],in[8],in[8:0]};
endmodule

module sext11(in, out);
input wire [10:0]in;
output wire [15:0]out;

assign out={in[10],in[10],in[10],in[10],in[10],in[10:0]};
endmodule

module sx_mux(in6, in9, in11, sext_mux, to_lshft);
input wire [15:0]in6;
input wire [15:0]in9;
input wire [15:0]in11;
input wire [1:0]sext_mux;

output wire [15:0]to_lshft;

assign to_lshft = (sext_mux == 2'b00) ? 16'd0 :
						(sext_mux == 2'b01) ? in6 :
						(sext_mux == 2'b10) ? in9 : in11;
endmodule


module lshft(in, out);
input wire [15:0]in;
output wire [15:0]out;

assign out = 2*in;
endmodule

module datapath_lb(memory_data, mem_data, mar, dr_out, mdr_mux_ctrl, sext8_ctrl, load_mdr, sext_mux, to_ctrlpth, to_dr_in_mux, to_sr2_mux, to_pc_addr);

inout wire [15:0]memory_data, mar;
input wire [7:0]mem_data;
input wire [15:0]dr_out;
input wire [1:0]mdr_mux_ctrl;
input wire sext8_ctrl, load_mdr, sext_mux;

output reg [15:0]to_ctrlpth;
output wire [15:0]to_dr_in_mux;
output wire [15:0]to_sr2_mux;
output wire [15:0]to_pc_addr;

wire [15:0]mdr16;
wire [7:0]mdr8;
reg [15:0]ir;
wire[7:0]from_store_mux;
wire [15:0]to_ir, to_sext8, out_sext6, out_sext9, out_sext11, to_lshft, mdr_mux16;

store_mux i1(dr_out, from_store_mux, mar[0]);
mdr_mux i2(mdr8, mdr_mux16, dr_out, from_store_mux, to_sext8, to_ir, mdr_mux_ctrl);
mdr8_16 i3(mem_data, memory_data, mdr16, mdr8, load_mdr);
sext8 i4(to_sext8, to_dr_in_mux, sext8_ctrl);
sext5 i5(ir[4:0], to_sr2_mux);
sext6 i6(ir[5:0], out_sext6);
sext9 i7(ir[8:0], out_sext9);
sext11 i8(ir[10:0], out_sext11);

sx_mux i9(out_sext6, out_sext9, out_sext11, sext_mux, to_lshft);
lshft i10(to_lshft, to_pc_addr);

always @(*) begin
	ir <=to_ir;
	to_ctrlpth <=ir;
	end
endmodule
