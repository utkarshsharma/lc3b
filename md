#! /c/iverilog/bin/vvp
:ivl_version "0.9.7 " "(v0_9_7)";
:vpi_time_precision + 0;
:vpi_module "system";
:vpi_module "v2005_math";
:vpi_module "va_math";
S_00593018 .scope module, "alu_tb" "alu_tb" 2 1;
 .timescale 0 0;
v005DA940_0 .net "DR", 15 0, v003997F0_0; 1 drivers
v005DAAA0_0 .var "SR1", 15 0;
v005DA6D8_0 .var "SR2", 15 0;
v005DADB8_0 .var "am", 3 0;
v005DA730_0 .var "clk", 0 0;
RS_005A9034 .resolv tri, C4<0>, L_005DB020, C4<z>, C4<z>;
v005DAE10_0 .net8 "n", 0 0, RS_005A9034; 2 drivers
v005DAAF8_0 .var "opval", 1 0;
RS_005A904C .resolv tri, C4<0>, L_005DB390, C4<z>, C4<z>;
v005DA788_0 .net8 "p", 0 0, RS_005A904C; 2 drivers
v005DAB50_0 .var "shift", 1 0;
RS_005A9064 .resolv tri, C4<0>, L_005DA890, C4<z>, C4<z>;
v005DA7E0_0 .net8 "z", 0 0, RS_005A9064; 2 drivers
S_005930A0 .scope module, "a" "ALU" 2 12, 2 76, S_00593018;
 .timescale 0 0;
L_005DBB78 .functor AND 1, L_005DB078, L_005DB1D8, C4<1>, C4<1>;
v003996E8_0 .net/s "A1", 15 0, v005DAAA0_0; 1 drivers
v00399798_0 .net/s "A2", 15 0, v005DA6D8_0; 1 drivers
v003997F0_0 .var/s "D", 15 0;
v00399C10_0 .alias "N", 0 0, v005DAE10_0;
v00399848_0 .alias "P", 0 0, v005DA788_0;
v00399A58_0 .alias "Z", 0 0, v005DA7E0_0;
v003998F8_0 .net *"_s0", 15 0, C4<0000000000000000>; 1 drivers
v00399950_0 .net *"_s11", 0 0, L_005DB2E0; 1 drivers
v00399AB0_0 .net *"_s12", 2 0, L_005DB230; 1 drivers
v003999A8_0 .net *"_s15", 1 0, C4<00>; 1 drivers
v00399B08_0 .net *"_s16", 2 0, C4<001>; 1 drivers
v00399B60_0 .net *"_s18", 0 0, L_005DB288; 1 drivers
v00399C68_0 .net *"_s2", 0 0, L_005DA838; 1 drivers
v00399CC0_0 .net *"_s20", 0 0, C4<1>; 1 drivers
v005DAEC0_0 .net *"_s22", 0 0, C4<0>; 1 drivers
v005DA8E8_0 .net *"_s27", 0 0, L_005DB180; 1 drivers
v005DAA48_0 .net *"_s28", 1 0, L_005DAF70; 1 drivers
v005DA470_0 .net *"_s31", 0 0, C4<0>; 1 drivers
v005DA9F0_0 .net *"_s32", 1 0, C4<00>; 1 drivers
v005DAE68_0 .net *"_s34", 0 0, L_005DB078; 1 drivers
v005DA4C8_0 .net *"_s37", 0 0, L_005DB338; 1 drivers
v005DA998_0 .net *"_s38", 1 0, L_005DAFC8; 1 drivers
v005DAF18_0 .net *"_s4", 0 0, C4<1>; 1 drivers
v005DA520_0 .net *"_s41", 0 0, C4<0>; 1 drivers
v005DA578_0 .net *"_s42", 1 0, C4<00>; 1 drivers
v005DAC00_0 .net *"_s44", 0 0, L_005DB1D8; 1 drivers
v005DABA8_0 .net *"_s46", 0 0, L_005DBB78; 1 drivers
v005DAC58_0 .net *"_s48", 0 0, C4<1>; 1 drivers
v005DA5D0_0 .net *"_s50", 0 0, C4<0>; 1 drivers
v005DACB0_0 .net *"_s6", 0 0, C4<0>; 1 drivers
v005DA628_0 .net "amount4", 3 0, v005DADB8_0; 1 drivers
v005DA680_0 .net "clk", 0 0, v005DA730_0; 1 drivers
v005DAD08_0 .net "opval", 1 0, v005DAAF8_0; 1 drivers
v005DAD60_0 .net "shiftop", 1 0, v005DAB50_0; 1 drivers
E_00592768 .event edge, v005DA680_0;
L_005DA838 .cmp/eq 16, v003997F0_0, C4<0000000000000000>;
L_005DA890 .functor MUXZ 1, C4<0>, C4<1>, L_005DA838, C4<>;
L_005DB2E0 .part v003997F0_0, 15, 1;
L_005DB230 .concat [ 1 2 0 0], L_005DB2E0, C4<00>;
L_005DB288 .cmp/eq 3, L_005DB230, C4<001>;
L_005DB020 .functor MUXZ 1, C4<0>, C4<1>, L_005DB288, C4<>;
L_005DB180 .reduce/or v003997F0_0;
L_005DAF70 .concat [ 1 1 0 0], L_005DB180, C4<0>;
L_005DB078 .cmp/ne 2, L_005DAF70, C4<00>;
L_005DB338 .part v003997F0_0, 15, 1;
L_005DAFC8 .concat [ 1 1 0 0], L_005DB338, C4<0>;
L_005DB1D8 .cmp/eq 2, L_005DAFC8, C4<00>;
L_005DB390 .functor MUXZ 1, C4<0>, C4<1>, L_005DBB78, C4<>;
    .scope S_005930A0;
T_0 ;
    %wait E_00592768;
    %load/v 8, v005DAD08_0, 2;
    %mov 10, 0, 1;
    %cmpi/u 8, 0, 3;
    %jmp/0xz  T_0.0, 4;
    %load/v 8, v003996E8_0, 16;
    %load/v 24, v00399798_0, 16;
    %add 8, 24, 16;
    %set/v v003997F0_0, 8, 16;
    %jmp T_0.1;
T_0.0 ;
    %load/v 8, v005DAD08_0, 2;
    %mov 10, 0, 1;
    %cmpi/u 8, 1, 3;
    %jmp/0xz  T_0.2, 4;
    %load/v 8, v003996E8_0, 16;
    %load/v 24, v00399798_0, 16;
    %and 8, 24, 16;
    %set/v v003997F0_0, 8, 16;
    %jmp T_0.3;
T_0.2 ;
    %load/v 8, v005DAD08_0, 2;
    %mov 10, 0, 4;
    %cmpi/u 8, 10, 6;
    %jmp/0xz  T_0.4, 4;
    %load/v 8, v003996E8_0, 16;
    %load/v 24, v00399798_0, 16;
    %xor 8, 24, 16;
    %set/v v003997F0_0, 8, 16;
    %jmp T_0.5;
T_0.4 ;
    %load/v 8, v005DAD08_0, 2;
    %mov 10, 0, 4;
    %cmpi/u 8, 11, 6;
    %jmp/0xz  T_0.6, 4;
    %load/v 8, v005DAD60_0, 2;
    %cmpi/u 8, 0, 2;
    %jmp/1 T_0.8, 6;
    %cmpi/u 8, 1, 2;
    %jmp/1 T_0.9, 6;
    %cmpi/u 8, 3, 2;
    %jmp/1 T_0.10, 6;
    %jmp T_0.11;
T_0.8 ;
    %load/v 8, v003996E8_0, 16;
    %load/v 24, v005DA628_0, 4;
    %ix/get 0, 24, 4;
    %shiftl/i0  8, 16;
    %set/v v003997F0_0, 8, 16;
    %jmp T_0.11;
T_0.9 ;
    %load/v 8, v003996E8_0, 16;
    %load/v 24, v005DA628_0, 4;
    %ix/get 0, 24, 4;
    %shiftr/i0  8, 16;
    %set/v v003997F0_0, 8, 16;
    %jmp T_0.11;
T_0.10 ;
    %ix/load 0, 1, 0;
    %load/vp0 8, v005DA628_0, 32;
T_0.12 %cmp/u 0, 8, 32;
    %jmp/0xz T_0.13, 5;
    %add 8, 1, 32;
    %load/v 40, v003996E8_0, 16;
    %ix/load 0, 1, 0;
    %mov 4, 0, 1;
    %shiftr/i0  40, 16;
    %set/v v003997F0_0, 40, 16;
    %ix/load 1, 15, 0;
    %mov 4, 0, 1;
    %jmp/1 T_0.14, 4;
    %load/x1p 40, v003996E8_0, 1;
    %jmp T_0.15;
T_0.14 ;
    %mov 40, 2, 1;
T_0.15 ;
; Save base=40 wid=1 in lookaside.
    %ix/load 0, 15, 0;
    %set/x0 v003997F0_0, 40, 1;
    %jmp T_0.12;
T_0.13 ;
    %jmp T_0.11;
T_0.11 ;
T_0.6 ;
T_0.5 ;
T_0.3 ;
T_0.1 ;
    %jmp T_0;
    .thread T_0, $push;
    .scope S_00593018;
T_1 ;
    %set/v v005DAAF8_0, 0, 2;
    %end;
    .thread T_1;
    .scope S_00593018;
T_2 ;
    %set/v v005DAAA0_0, 0, 16;
    %end;
    .thread T_2;
    .scope S_00593018;
T_3 ;
    %set/v v005DA6D8_0, 0, 16;
    %end;
    .thread T_3;
    .scope S_00593018;
T_4 ;
    %set/v v005DADB8_0, 0, 4;
    %end;
    .thread T_4;
    .scope S_00593018;
T_5 ;
    %set/v v005DAB50_0, 0, 2;
    %end;
    .thread T_5;
    .scope S_00593018;
T_6 ;
    %set/v v005DA730_0, 0, 1;
    %end;
    .thread T_6;
    .scope S_00593018;
T_7 ;
    %vpi_call 2 16 "$dumpfile", "alu.vcd";
    %vpi_call 2 17 "$dumpvars", 1'sb0, S_005930A0;
    %set/v v005DAAF8_0, 0, 2;
    %delay 5, 0;
    %movi 8, 1, 16;
    %set/v v005DAAA0_0, 8, 16;
    %movi 8, 2, 16;
    %set/v v005DA6D8_0, 8, 16;
    %delay 5, 0;
    %vpi_call 2 23 "$display", "%g ADD output:%d,opval=%d,SR1=%d,SR2=%d,N=%d,P=%d,Z=%d, clk=%d", $time, v005DA940_0, v005DAAF8_0, v005DAAA0_0, v005DA6D8_0, v005DAE10_0, v005DA788_0, v005DA7E0_0, v005DA730_0;
    %delay 5, 0;
    %movi 8, 255, 16;
    %set/v v005DAAA0_0, 8, 16;
    %movi 8, 33024, 16;
    %set/v v005DA6D8_0, 8, 16;
    %delay 5, 0;
    %vpi_call 2 27 "$display", "%g ADD output:%d,opval=%d,SR1=%d,SR2=%d,N=%d,P=%d,Z=%d, clk=%d", $time, v005DA940_0, v005DAAF8_0, v005DAAA0_0, v005DA6D8_0, v005DAE10_0, v005DA788_0, v005DA7E0_0, v005DA730_0;
    %delay 5, 0;
    %movi 8, 32768, 16;
    %set/v v005DAAA0_0, 8, 16;
    %movi 8, 32768, 16;
    %set/v v005DA6D8_0, 8, 16;
    %delay 5, 0;
    %vpi_call 2 31 "$display", "%g ADD output:%d,opval=%d,SR1=%d,SR2=%d,N=%d,P=%d,Z=%d, clk=%d", $time, v005DA940_0, v005DAAF8_0, v005DAAA0_0, v005DA6D8_0, v005DAE10_0, v005DA788_0, v005DA7E0_0, v005DA730_0;
    %movi 8, 1, 2;
    %set/v v005DAAF8_0, 8, 2;
    %delay 5, 0;
    %movi 8, 1, 16;
    %set/v v005DAAA0_0, 8, 16;
    %movi 8, 2, 16;
    %set/v v005DA6D8_0, 8, 16;
    %delay 5, 0;
    %vpi_call 2 37 "$display", "%g AND output:%d,opval=%d,SR1=%d,SR2=%d,N=%d,P=%d,Z=%d, clk=%d", $time, v005DA940_0, v005DAAF8_0, v005DAAA0_0, v005DA6D8_0, v005DAE10_0, v005DA788_0, v005DA7E0_0, v005DA730_0;
    %delay 5, 0;
    %movi 8, 10, 16;
    %set/v v005DAAA0_0, 8, 16;
    %movi 8, 7, 16;
    %set/v v005DA6D8_0, 8, 16;
    %delay 5, 0;
    %vpi_call 2 41 "$display", "%g AND output:%d,opval=%d,SR1=%d,SR2=%d,N=%d,P=%d,Z=%d, clk=%d", $time, v005DA940_0, v005DAAF8_0, v005DAAA0_0, v005DA6D8_0, v005DAE10_0, v005DA788_0, v005DA7E0_0, v005DA730_0;
    %movi 8, 2, 2;
    %set/v v005DAAF8_0, 8, 2;
    %delay 5, 0;
    %movi 8, 1, 16;
    %set/v v005DAAA0_0, 8, 16;
    %movi 8, 2, 16;
    %set/v v005DA6D8_0, 8, 16;
    %delay 5, 0;
    %vpi_call 2 47 "$display", "%g XOR output:%d,opval=%d,SR1=%d,SR2=%d,N=%d,P=%d,Z=%d, clk=%d", $time, v005DA940_0, v005DAAF8_0, v005DAAA0_0, v005DA6D8_0, v005DAE10_0, v005DA788_0, v005DA7E0_0, v005DA730_0;
    %delay 5, 0;
    %movi 8, 10, 16;
    %set/v v005DAAA0_0, 8, 16;
    %movi 8, 7, 16;
    %set/v v005DA6D8_0, 8, 16;
    %delay 5, 0;
    %vpi_call 2 51 "$display", "%g XOR output:%d,opval=%d,SR1=%d,SR2=%d,N=%d,P=%d,Z=%d, clk=%d", $time, v005DA940_0, v005DAAF8_0, v005DAAA0_0, v005DA6D8_0, v005DAE10_0, v005DA788_0, v005DA7E0_0, v005DA730_0;
    %set/v v005DAAF8_0, 1, 2;
    %delay 5, 0;
    %movi 8, 1, 16;
    %set/v v005DAAA0_0, 8, 16;
    %movi 8, 2, 16;
    %set/v v005DA6D8_0, 8, 16;
    %delay 5, 0;
    %set/v v005DAB50_0, 0, 2;
    %delay 5, 0;
    %movi 8, 5, 4;
    %set/v v005DADB8_0, 8, 4;
    %delay 5, 0;
    %vpi_call 2 57 "$display", "%g LSHIFT output:%d,opval=%d,SR1=%d,shiftop=%d,amount4=%d,N=%d,P=%d,Z=%d, clk=%d", $time, v005DA940_0, v005DAAF8_0, v005DAB50_0, v005DADB8_0, v005DAE10_0, v005DA788_0, v005DA7E0_0, v005DA730_0;
    %delay 5, 0;
    %movi 8, 10, 16;
    %set/v v005DAAA0_0, 8, 16;
    %movi 8, 7, 16;
    %set/v v005DA6D8_0, 8, 16;
    %delay 5, 0;
    %movi 8, 2, 2;
    %set/v v005DAB50_0, 8, 2;
    %delay 5, 0;
    %movi 8, 6, 4;
    %set/v v005DADB8_0, 8, 4;
    %delay 5, 0;
    %vpi_call 2 61 "$display", "%g RSHIFTL output:%d,opval=%d,SR1=%d,shiftop=%d,amount4=%d,N=%d,P=%d,Z=%d, clk=%d", $time, v005DA940_0, v005DAAF8_0, v005DAAA0_0, v005DAB50_0, v005DADB8_0, v005DAE10_0, v005DA788_0, v005DA7E0_0, v005DA730_0;
    %delay 5, 0;
    %movi 8, 57005, 16;
    %set/v v005DAAA0_0, 8, 16;
    %set/v v005DA6D8_0, 0, 16;
    %delay 5, 0;
    %set/v v005DAB50_0, 1, 2;
    %delay 5, 0;
    %movi 8, 13, 4;
    %set/v v005DADB8_0, 8, 4;
    %delay 5, 0;
    %vpi_call 2 65 "$display", "%g RSHIFTA output:%d,opval=%d,SR1=%d,shiftop=%d,amount4=%d,N=%d,P=%d,Z=%d, clk=%d", $time, v005DA940_0, v005DAAF8_0, v005DAAA0_0, v005DAB50_0, v005DADB8_0, v005DAE10_0, v005DA788_0, v005DA7E0_0, v005DA730_0;
    %delay 5, 0;
    %delay 5, 0;
    %vpi_call 2 68 "$display", "done";
    %vpi_call 2 68 "$finish";
    %end;
    .thread T_7;
    .scope S_00593018;
T_8 ;
    %delay 5, 0;
    %load/v 8, v005DA730_0, 1;
    %inv 8, 1;
    %set/v v005DA730_0, 8, 1;
    %jmp T_8;
    .thread T_8;
# The file index is used to find the file name in the following table.
:file_names 3;
    "N/A";
    "<interactive>";
    "alu_tb.v";
