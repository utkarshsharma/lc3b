module regs( data, ld_reg, dr, sr1, sr2, clk, rst, sr1_out, sr2_out);
    input wire [15:0] data; // data bus
    input wire ld_reg; // write data to destination register?
    input wire [2:0] dr; // destination register index
    input wire [2:0] sr1; // source register 1 index
    input wire [2:0] sr2; // source register 2 index
    input wire clk; // clock
    input wire rst; // reset
    output wire sr1_out; // source register 1 output
    output wire sr2_out; // source register 2 output

    // actual internal registers
    reg [15:0]regs[0:7];

    // TODO: find out whether this is the desired behavior or not
    // I think its fine, since sr1/2 are output of the control store
    // which is only updated on posedge clock.
    // Otherwise we have to latch updating the output of sr1/2 to
    // posedge clock as well.
    assign sr1_out = regs[sr1];
    assign sr2_out = regs[sr2];

    always @(posedge clk or posedge rst) begin
        if (rst) begin // TODO: is there a cleaner way to do this?
            regs[0] <= 0; regs[1] <= 0; regs[2] <= 0; regs[3] <= 0;
            regs[4] <= 0; regs[5] <= 0; regs[6] <= 0; regs[7] <= 0;
        end
        else if (ld_reg) regs[dr] <= data;
    end

endmodule
