module regs_tb;
    reg [15:0] data; // data bus
    reg ld_reg; // write data to destination register?
    reg [2:0] dr; // destination register index
    reg [2:0] sr1; // source register 1 index
    reg [2:0] sr2; // source register 2 index
    reg clk; // clock
    reg rst; // reset
    output wire sr1_out; // source register 1 output
    output wire sr2_out; // source register 2 output

    regs r(data, ld_reg, dr, sr1, sr2, clk, rst, sr1_out, sr2_out);

    // Macro to print steps
    `define TEST(ans) if (out != (ans)) \
        $display("%g Wanted:%d Got:%d ,aluk=%d,A=%d,B=%d,gate_alu=%b,clk=%b",$time,ans,out,aluk,A,B,gate_alu,clk);

    initial begin
        $dumpfile("regs.vcd");
        $dumpvars(0, r);
        #5 rst = 1;
        #5 rst = 0;
        #5 $display("done"); $finish;
    end

    always begin
        #5 clk=~clk; // tick
    end
endmodule
