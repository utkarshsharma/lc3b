// sr2mux - multiplexer for the 2nd source register of the ALU
module sr2mux( imm, sreg, sel, out);

    input wire [15:0] imm; // immediate value
    input wire [15:0] sreg; // source register
    input wire sel; // select
    output wire [15:0] out; // output

    // TODO: `define the values of select
    assign out = sel ? imm : sreg;

endmodule
