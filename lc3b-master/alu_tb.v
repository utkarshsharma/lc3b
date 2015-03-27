`include "alu.vh"


module alu_tb;

    reg [1:0] aluk = 2'b0; // operation
    reg [15:0] A = 16'b0; // first input
    reg [15:0] B = 16'b0; // second input
    reg gate_alu = 0; // enable gate
    reg clk = 0; // clock
    wire [15:0] out; // output

    alu a(aluk, A, B, gate_alu, clk, out);

    // Macro to print steps
    `define TEST(ans) if (out != (ans)) \
        $display("%g Wanted:%d Got:%d ,aluk=%d,A=%d,B=%d,gate_alu=%b,clk=%b",$time,ans,out,aluk,A,B,gate_alu,clk);

    initial begin
        $dumpfile("alu.vcd");
        $dumpvars(0, a);
        #5 gate_alu = 1; #5
        // ADD tests
        aluk = `alu_add;
        #5 A = 16'd1; B = 16'd2; #5 `TEST(1+2)
        #5 A = 16'd5; B = 16'd7; #5 `TEST(5+7)
        #5 A = 16'h8000; B = 16'h8000; #5 `TEST(16'd0) // overflow
        #5 A = 16'h8456; B = 16'h8123; #5 `TEST(16'h579) // overflow
        // AND tests
        aluk = `alu_and;
        #5 A = 16'h1; B = 16'h2; #5 `TEST(16'h0)
        #5 A = 16'hA; B = 16'h7; #5 `TEST(16'h2)
        #5 A = 16'hffff; B = 16'h0; #5 `TEST(16'h0)
        #5 A = 16'hffff; B = 16'hbead; #5 `TEST(16'hbead)
        // XOR tests
        aluk = `alu_xor;
        #5 A = 16'h1; B = 16'h2; #5 `TEST(16'h1^16'h2)
        #5 A = 16'hA; B = 16'h7; #5 `TEST(16'hA^16'h7)
        #5 A = 16'hffff; B = 16'h0; #5 `TEST(16'hffff^16'h0)
        #5 A = 16'hffff; B = 16'hbead; #5 `TEST(16'hffff^16'hbead)
        // PASSA tests
        aluk = `alu_a;
        #5 A = 16'h1; B = 16'h2; #5 `TEST(16'h1)
        #5 A = 16'hA; B = 16'h7; #5 `TEST(16'hA)
        #5 A = 16'hdead; B = 16'h0; #5 `TEST(16'hdead)
        #5 A = 16'hfa27; B = 16'hbead; #5 `TEST(16'hfa27)

        #5 gate_alu = 0;
        #5 $display("done"); $finish;
    end

    always begin
        #5 clk=~clk; // tick
    end
endmodule
