module controlpath;
	 
wire [15:0]to_ctrlpth;
wire N, P, Z;
reg	pc_mux, sext_mux, dr_in_mux_control, mdr_mux_ctrl, alu_control,load_pc, mar_mux,  pc_addr_mux_ctrl, 
		genCC, w,Reg_C, reset, load_mdr, sext8_ctrl;

reg L, S, word; //to memory
wire done; //from memory
	 
controlpath a(.sr1_out(A1) , .sr2_out(A2), .sr1(sr1), .sr2(sr2), .dr(dr), .dr_in(dr_in) , .Write(wr), .clk(clock), .rst(reset) );

    initial begin
		$dumpfile("regfile.vcd");
		$dumpvars(0, a);
		$monitor("Clock_Time %g, Current_Instruction:%b, pc_mux:%b, sext_mux:%b, dr_in_mux_control:%b, mdr_mux_ctrl:%b, 
		alu_control:%b, load_pc:%b, mar_mux:%b, pc_addr_mux_ctrl=%b,genCC:%d, w:%d, Reg_C:%d, reset:%d, 
		load_mdr:%d, sext8_ctrl:%d", 
		$time,to_ctrlpth, pc_mux, sext_mux, dr_in_mux_control, mdr_mux_ctrl, alu_control,load_pc, mar_mux,  pc_addr_mux_ctrl, 
		genCC, w,Reg_C, reset, load_mdr, sext8_ctrl);
			
		
			$finish;
    end

    always begin
        #2 clock=~clock; // tick
    end
	 
endmodule