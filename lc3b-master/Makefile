all: alu cc

alu: alu.v alu_tb.v
	iverilog -o obj/alu.vvp alu.v alu_tb.v && vvp obj/alu.vvp

cc: cc.v cc_tb.v
	iverilog -o obj/cc.vvp cc.v cc_tb.v && vvp obj/cc.vvp

regs: regs.v regs_tb.v
	iverilog -o obj/regs.vvp regs.v regs_tb.v && vvp obj/regs.vvp
