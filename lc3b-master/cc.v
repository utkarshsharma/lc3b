// CC - condition code unit
module cc( ld_cc, data, clk, rst, n, z, p);

    input wire ld_cc; // load cc register (write enable)
    input wire signed [15:0] data; // data bus
    input wire clk; // clock
    input wire rst; // reset
    output reg n; // negative
    output reg z; // zero
    output reg p; // positive

    always @(posedge clk or rst) begin
        if (rst) begin
            n <= 0;
            z <= 0;
            p <= 0;
        end else if (ld_cc) begin
            n <= data < 0;
            z <= data == 0;
            p <= data > 0;
        end
    end

endmodule
