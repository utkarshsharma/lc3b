`include "pc.vh"

// PC - program counter
module pc( pc_sel, addr, bus, ld_pc, gate_pc, clk, rst, out);

    input wire [1:0] pc_sel; // source select line
    input wire [15:0] addr; // output of address adder
    input wire [15:0] bus; // data bus
    input wire ld_pc; // write enable
    input wire gate_pc; // output enable gate
    input wire clk; // clock
    input wire rst; // reset
    output wire [15:0] out; // output (to bus)

    wire [15:0] pc_mux; // output of PCMUX
    reg [15:0] pc; // actual internal program counter

    assign pc_mux = pc_sel == `PCMUX_INC ? pc + 2 :
                    pc_sel == `PCMUX_BUS ? bus :
                    addr; // `PCMUX_ADDR

    always @(posedge clk or rst) begin
        if (rst) pc <= `PC_RST ;
        else if (ld_pc) pc <= pc_mux;
    end

    assign out = gate_pc ? pc : 16'bZ;

endmodule
