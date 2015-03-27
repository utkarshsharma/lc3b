module sext( // sign extension
    input  [15:0] ir,
    output [15:0] imm5,
    output [15:0] offset6,
    output [15:0] offset9,
    output [15:0] offset11
);
    assign offset11  = { {  5{ir[10] } }, ir[10:0] };
    assign offset9   = { {  7{ir[ 8] } }, ir[ 8:0] };
    assign offset6   = { { 10{ir[ 5] } }, ir[ 5:0] };
    assign imm5      = { { 11{ir[ 4] } }, ir[ 4:0] };
endmodule
