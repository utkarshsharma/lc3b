module cc_tb;

    reg ld_cc = 0; // write enable
    reg signed [15:0] data = 16'b0; // data bus
    reg clk = 0; // clock
    reg rst = 0; // reset
    wire n; // negative condition
    wire z; // zero condition
    wire p; // positive condition

    cc c( ld_cc, data, clk, rst, n, z, p);

    // Macro to print steps
    `define TEST(nn,zz,pp) if ((n != (nn)) || (z != (zz)) || (p != (pp))) \
        $display("%g Wanted:%b:%b:%b Got:%b:%b:%b ld_cc=%b,data=%d,clk=%b,rst=%b",$time,nn,zz,pp,n,z,p,ld_cc,data,clk,rst);

    initial begin
        $dumpfile("cc.vcd");
        $dumpvars(0, c);
        rst = 1; #5 rst = 0; #5 `TEST(0,0,0)

        #5 ld_cc = 0; data = 0; #5 `TEST(0,0,0)
        #5 ld_cc = 1; data = 0; #5 `TEST(0,1,0)
        #5 ld_cc = 0; data = 0; #5 `TEST(0,1,0)
        #5 ld_cc = 0; data = 5; #5 `TEST(0,1,0)
        #5 ld_cc = 1; data =-1; #5 `TEST(1,0,0)
        #5 ld_cc = 0; data = 0; #5 `TEST(1,0,0)
        #5 ld_cc = 1; data = 5; #5 `TEST(0,0,1)
        #5 ld_cc = 0; data =-5; #5 `TEST(0,0,1)

        #5 rst = 1; #5 `TEST(0,0,0)
        #5 $display("done"); $finish;
    end

    always begin
        #5 clk=~clk; // tick
    end
endmodule
