module controlpath(inst, mar_mux, load_pc, pc_mux, addr_mux, sext_mux, mdr_mux, sext8_ctrl,
						gen_cc, ALU_control, DR_in_Mux_control, W,Reg_C, Shifter_control, SR2mux_control);
						
input wire [15:0] inst;
output reg mar_mux, load_pc, pc_mux, addr_mux, sext8_ctrl,
						gen_cc, W,Reg_C, SR2mux_control;
output reg [1:0] sext_mux, ALU_control, DR_in_Mux_control, mdr_mux;
output reg [5:0] Shifter_control;

/*always @(*) begin
mdr_mux = 2'b11;
 case(inst[15:12])
 (4'd0)
 (4'd1)
 (4'd2)
 (4'd3)
 (4'd4)
 (4'd5)
 (4'd6)
 (4'd7)
 (4'd8)
 (4'd9)
 (4'd10)
 (4'd11)
 (4'd12)
 (4'd13)
 (4'd14)
 (4'd15)
endcase
 end*/
endmodule