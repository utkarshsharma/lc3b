`include "alu.vh"
// ALU - arithmetic and logic unit
module alu(
    input  wire [ 1:0] op,  // operation
    input  wire [15:0] a,   // first input
    input  wire [15:0] b,   // second input
    input  wire        en,  // output enable gate
    input  wire        clk, // clock
    output wire [15:0] out  // output
);
    assign out = (en == 0) ? 16'bZ :
                 (op == `alu_add) ? a + b :
                 (op == `alu_and) ? a & b :
                 (op == `alu_xor) ? a ^ b :
                 a; // `alu_a
endmodule
