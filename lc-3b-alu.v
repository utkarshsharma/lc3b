module SimpleLC3 (clock, reset, addr, din, dout, rd, complete);
 input clock;               // Global system clock
 input reset;               // Global system reset
 output [15:0] addr, din;   // Address and data-in lines for memory
 input [15:0] dout;         // Data-out lines from memory
 output rd;                 // Signal to indicate memory read or write
 input complete;            // Signal to indicate completion of read/write

wire F_Control, M_Control;
wire [1:0] W_Control;
wire [3:0] state;
wire [5:0] C_Control, E_Control;
wire [15:0] npc, pcout, aluout, dout, addr, DR_in;
wire [47:0] D_Data;
wire [2:0] sr1, sr2, dr;
wire [15:0] VSR1, VSR2;

RegFile R1 (VSR1, VSR2, sr1, sr2, dr, DR_in, state, clock, reset);
Controller C1 (clock, reset, state, C_Control, complete);
Execute E1 (E_Control, D_Data, aluout, pcout, npc);
Fetch F1 (clock, reset, state, addr, npc, rd, pcout, F_Control);
MemAccess M1 (state, M_Control, VSR2, pcout, addr, din, dout, rd);
Writeback W1 (W_Control, aluout, dout, pcout, npc, DR_in);
Decode D1 (VSR1, VSR2, clock, state, dout, C_Control, E_Control, M_Control, W_Control, F_Control, D_Data, DR_in, sr1, sr2, dr);
endmodule

module Controller(clock, reset, state, C_Control, complete);
 input clock, reset;         // system clock and reset
 output [3:0] state;        // system state
 input [5:0] C_Control;    // control from Decode module
 input complete;        // complete from memory

 reg [3:0] state;

always@ (posedge clock)
 if (reset) state = 4'b0001;
 else if (complete)  // use current state and C_Control to determine next state
 casex ({state, C_Control})
 10'b0001xxxxxx : state = 4'b0010;    // Fetch to Decode
 10'b0110xxxxxx : state = 4'b1001;    // Read Memory to Update Register File
 10'b1001xxxxxx : state = 4'b1010;    // Update Register File to Update PC
 10'b1010xxxxxx : state = 4'b0001; // Update PC to Fetch
 10'b0011xxxxxx : state = 4'b1001;    // Execute to Update Register File
 10'b1000xxxxxx : state = 4'b1010;    // Write Memory to Update PC
 10'b0111xxxxx0 : state = 4'b1000;    // Indirect Read to Write Memory
 10'b0111xxxxx1 : state = 4'b0110;    // Indirect Read to Read Memory
 10'b001000xxxx : state = 4'b0011;    // Decode to Execute
 10'b001001xxxx : state = 4'b0100;    // Decode to Compute Target PC
 10'b00101xxxxx : state = 4'b0101;    // Decode to Compute Memory Address
 10'b0100xx0xxx : state = 4'b1010;    // Compute Target PC to Update PC
 10'b0100xx1xxx : state = 4'b1001;    // Compute Target PC to Update Register File
 10'b0101xxx00x : state = 4'b0111;    // Compute Memory Address to Indirect Read
 10'b0101xxx01x : state = 4'b0110;    // Compute Memory Address to Read Memory
 10'b0101xxx10x : state = 4'b1000;    // Compute Memory Address to Write Memory
 10'b0101xxx11x : state = 4'b1001;    // Compute Memory Address to Update Register File      
 default : state = 4'b1111;    // Invalid state or C_Control
 endcase
endmodule

module Decode(VSR1, VSR2, clock, state, dout, C_Control, E_Control, 

 M_Control, W_Control, F_Control, D_Data, DR_in, sr1, sr2, dr);
 input [15:0] VSR1;       // Loopback from RegFile module
 input [15:0] VSR2;       // Loopback from RegFile module
 input clock;             // Global system clock
 input [3:0] state;       // System state from Controller
 input [15:0] dout;       // Data-out lines from memory
 input [15:0] DR_in;      // Data to be written to registerfile
 output M_Control;        // MemAccess control line
 output [1:0] W_Control;  // Writeback control lines
 output [5:0] C_Control;  // Controller control lines
 output [5:0] E_Control;  // Execute control lines
 output [47:0] D_Data;    // Data for Execute and MemAccess blocks
 output F_Control;        // Fetch control line
 output [2:0] sr1;       // Source Register 1 ID to RegFile
 output [2:0] sr2;       // Source Register 2 ID to RegFile
 output [2:0] dr;       // Destination Register ID to RegFile

reg [2:0] PSR, newpsr;
reg F_Control;
reg M_Control;
reg [1:0] W_Control;
reg [5:0] C_Control, E_Control;
reg [2:0] dr, sr1, sr2;
reg [15:0] IR;

assign D_Data [47:0] = {IR, VSR1, VSR2}; // Create D_Data wire output

always@ (posedge clock)
begin
 if (state == 4'b0010) IR = dout; // Decode
 if ((state == 4'b1001) && (IR[15:12] != 4'b0100) && (IR[15:12] != 4'b0000)) PSR = newpsr;
end // update PSR if state = Update RegFile and not a JSR, JSRR or BR

always@ (DR_in) // combinational logic used to create newpsr from high bit of DR_in
 begin
 if(DR_in[15])
 newpsr = 3'b100; // if negative
 else if(|DR_in)
 newpsr = 3'b001; //if positive
 else
 newpsr = 3'b010; // zero
 end

always@ (dout)    // determine the type of instruction being used
 case (dout[13:12])
 2'b01 : C_Control[5:4] = 2'b00; // Arithmetic Operation
 2'b00 : C_Control[5:4] = 2'b01; // GOTO Operation
 2'b10 : C_Control[5:4] = 2'b10; // Load Operation
 2'b11 : C_Control[5:4] = 2'b10; // Store Operation
 default : C_Control[5:4] = 2'b11; // Bad Opcode
endcase

always@ (IR or PSR)
begin
 case(IR[15:12])
 4'b0001: begin //ADD1 & ADD0 IR[5] = 1 = imm5
 E_Control = (IR[5]) ? 6'b001000 : 6'b000000;
 C_Control[3:0] = 4'b0000;
 W_Control = 2'b00; // Writeback = aluout
 F_Control = 1'b0;
 M_Control = 1'b0;
 dr  = IR[11:9];
 sr1 = IR[8:6];
 sr2 = IR[2:0];        
 end
 4'b0101: begin //AND1 & AND0 IR[5] = 1 = imm5
 E_Control = (IR[5]) ? 6'b011000 : 6'b010000;
 C_Control[3:0] = 4'b0000;
 W_Control = 2'b00; // Writeback = aluout
 F_Control = 1'b0;
 M_Control = 1'b0;
 dr  = IR[11:9];
 sr1 = IR[8:6];
 sr2 = IR[2:0];
 end
 4'b1001: begin //NOT
 C_Control[3:0] = 4'b0000;
 W_Control = 2'b00; // Writeback = aluout
 F_Control = 1'b0;
 E_Control = 6'b100000; // aluout = ~(VSR1)
 M_Control = 1'b0;
 dr  = IR[11:9];
 sr1 = IR[8:6];
 end
 4'b0000: begin //BR
 C_Control[3:0] = 4'b0000;
 W_Control = 2'b00; // Writeback = aluout
 F_Control = |(IR[11:9] & PSR);
 E_Control = 6'b000011; // pcout = npc + offset9
 M_Control = 1'b0;
 end
 4'b1100: begin //JMP & RET
 C_Control[3:0] = 4'b0000;
 W_Control = 2'b00; // Writeback = aluout
 F_Control = 1'b1; // Branch taken
 E_Control = 6'b000100; // pcout = VSR1 + offset6
 M_Control = 1'b0;
 sr1 = IR[8:6];
 end
 4'b0100: begin //JSR and JSRR
 E_Control = (IR[11]) ? 6'b000001 : 6'b000100;
 C_Control[3:0] = 4'b1000;
 W_Control = 2'b11;  // Writeback = npc
 F_Control = 1'b1; // Branch taken
 M_Control = 1'b0;
 dr = 3'b111; // store return address in R7
 sr1 = IR[8:6];
 end     
 4'b0010: begin //LD
 C_Control[3:0] = 4'b0010;
 W_Control = 2'b01; // Writeback = dout
 F_Control = 1'b0;
 E_Control = 6'b000011; // pcout = npc + offset9
 M_Control = 1'b0;
 dr = IR[11:9];
 end         
 4'b0110: begin //LDR
 C_Control[3:0] = 4'b0010;
 W_Control = 2'b01; // Writeback = dout
 F_Control = 1'b0;
 E_Control = 6'b000100; // pcout = VSR1 + offset6
 M_Control = 1'b0;
 dr = IR[11:9];
 sr1 = IR[8:6];
 end
 4'b1010: begin //LDI
 C_Control[3:0] = 4'b0001;
 W_Control = 2'b01; // Writeback = dout
 F_Control = 1'b0;
 E_Control = 6'b000011; // pcout = npc + offset9
 M_Control = 1'b1; // Indirect Mode
 dr = IR[11:9];
 end
 4'b1110: begin //LEA
 C_Control[3:0] = 4'b0110;
 W_Control = 2'b10; // Writeback = pcout
 F_Control = 1'b0;
 E_Control = 6'b000011; // pcout = npc + offset9
 M_Control = 1'b0;
 dr = IR[11:9];
 end
 4'b0011: begin //ST
 C_Control[3:0] = 4'b0100;
 W_Control = 2'b00; // Writeback = aluout
 F_Control = 1'b0;
 E_Control = 6'b000011; // pcout = npc + offset9
 M_Control = 1'b0;
 sr2 = IR[11:9];
 end
 4'b0111: begin //STR
 C_Control[3:0] = 4'b0100;
 W_Control = 2'b00; // Writeback = aluout
 F_Control = 1'b0;
 E_Control = 6'b000100; // pcout = VSR1 + offset6
 M_Control = 1'b0;
 sr1 = IR[8:6];
 sr2 = IR[11:9];
 end
 4'b1011: begin //STI
 C_Control[3:0] = 4'b0000;
 W_Control = 2'b00; // Writeback = aluout
 F_Control = 1'b0;
 E_Control = 6'b000011; // pcout = VSR1 + offset9
 M_Control = 1'b1;
 sr2  = IR[11:9];
 end
 default : begin // Bad Opcode
 E_Control = 6'b111111;
 C_Control[3:0] = 4'b1111;
 W_Control = 2'b11;
 F_Control = 1'b1;
 M_Control = 1'b1;
 sr1 = 3'b111;
 sr2 = 3'b111;
 dr = 3'b111;
 end
 endcase
end
endmodule

module Execute (E_Control, D_Data, aluout, pcout, npc);

 input [5:0] E_Control;         // control signals from Decode
 input [47:0] D_Data;             // data from Decode
 output [15:0] aluout;             // output of ALU
 output [15:0] pcout;                // output of address computation module
 input [15:0] npc;             // next PC from Fetch

 wire [15:0] IR, VSR1, VSR2, offset6, offset9, offset11, imm5;
 reg [15:0] aluout, pcout;

 assign IR = D_Data[47:32];
 assign VSR1 = D_Data[31:16];
 assign VSR2 = D_Data[15:0];
 assign imm5 = ({{11{IR[4]}}, IR[4:0]});     // sign extended 5 bit operand
 assign offset6 = ({{10{IR[5]}}, IR[5:0]});     // sign extended 6 bit offset
 assign offset9 = ({{7{IR[8]}}, IR[8:0]});     // sign extended 9 bit offset
 assign offset11 = ({{5{IR[10]}}, IR[10:0]});    // sign extended 11 bit offset

always@(E_Control or VSR1 or VSR2 or imm5)    // ALU Function
 casex (E_Control [5:3])
 3'b000: aluout = VSR1 + VSR2;    // ADD Mode 0
 3'b001: aluout = VSR1 + imm5;    // ADD Mode 1
 3'b010: aluout = VSR1 & VSR2;    // AND Mode 0
 3'b011: aluout = VSR1 & imm5;    // AND Mode 1
 3'b1xx: aluout = ~(VSR1);        // NOT
 endcase

always@(E_Control or npc or D_Data or VSR1 or offset11 or offset9 or offset6)    // Address Computer
 case (E_Control [2:0])
 3'b000: pcout = VSR1 + offset11;    // Register + offset
 3'b001: pcout = npc + offset11;    // Next PC + offset
 3'b010: pcout = VSR1 + offset9;
 3'b011: pcout = npc + offset9;
 3'b100: pcout = VSR1 + offset6;
 3'b101: pcout = npc + offset6;
 3'b110: pcout = VSR1;
 3'b111: pcout = npc;
 endcase
endmodule

module Fetch (clock, reset, state, addr, npc, rd, pcout, F_Control);

 input clock;            // system clock
 input reset;            // system reset
 input F_Control;        // signal from Decode, 1 means branch taken
 input [15:0] pcout;        // target address of control instructions
 input [3:0] state;        // system state from Controller
 output [15:0] addr, npc;    // current PC and next PC, i.e., pc+1
 output rd;            // memory read control signal

 wire [15:0] addr, node_A, node_B, node_C;
 reg [15:0] pc;

assign npc = pc+1;        // assures that npc is always pc+1
assign node_A = (F_Control) ? pcout : npc;
assign node_B = (state == 4'b1010) ? node_A : pc;
assign node_C = (reset) ? 16'h3000 : node_B;
assign addr = (state !=4'b0110 && state != 4'b1000 && state !=4'b0111) ? pc : 16'hzzzz;
assign rd = (state !=4'b0110 && state != 4'b1000 && state !=4'b0111) ? 1 : 1'bz;

always@(posedge clock)
 pc <= node_C;            // update pc on each rising clock edge
endmodule

module MemAccess (state, M_Control, VSR2, pcout, addr, din, dout, rd);

 input [3:0] state;       // System state from Controller
 input M_Control;         // Control signal indicating the source of memory address
 input [15:0] VSR2;       // Data for store operations
 input [15:0] pcout;      // Address for load/store operations
 output [15:0] addr;      // Address lines to memory
 output [15:0] din;       // Data-in lines to memory
 output rd;               // Signal to indicate memory read or write
 input [15:0] dout;       // Data-Out lines from Memory

 reg [15:0] addr, din;
 reg rd;

always@ (state or M_Control or VSR2 or pcout or dout)
 casex({state, M_Control})
 5'b01100 : begin  // Read Direct Data
 rd = 1'b1;
 addr = pcout; end
 5'b01101 : begin  // Read Indirect
 rd = 1'b1;
 addr = dout; end
 5'b10000 : begin  // Write Direct
 rd = 1'b0;
 din = VSR2;
 addr = pcout; end
 5'b10001 : begin  // Write Indirect
 rd = 1'b0;
 din = VSR2;
 addr = dout; end
 5'b0111x : begin  // Indirect Memory Read
 rd = 1'b1;
 addr = pcout; end
 default : begin  // set all outputs to high z
 rd = 1'bz;
 addr = 16'hzzzz;
 din = 16'hzzzz;
 end
 endcase
endmodule

module RegFile (VSR1, VSR2, sr1, sr2, dr, DR_in, state, clock, reset);

 output [15:0] VSR1;        // to Decode and Execute
 output [15:0] VSR2;        // to Decode and Execute
 input [2:0] sr1;        // from Decode
 input [2:0] sr2;        // from Decode
 input [2:0] dr;        // from Decode
 input [15:0] DR_in;        // from Memory
 input [3:0] state;        // from Controller
 input clock, reset;        // from Testbench

 reg [15:0] VSR1, VSR2;
 wire [15:0] R0, R1, R2, R3, R4, R5, R6, R7;
 reg [15:0] RegFile [0:7];

assign R0 = RegFile[0];        // Create wires that can be seen on SimVision
assign R1 = RegFile[1];
assign R2 = RegFile[2];
assign R3 = RegFile[3];
assign R4 = RegFile[4];
assign R5 = RegFile[5];
assign R6 = RegFile[6];
assign R7 = RegFile[7];

always@ (posedge clock)        // Set all Registers to 0
if (reset) begin
 RegFile[0] = 16'h0000;
 RegFile[1] = 16'h0000;
 RegFile[2] = 16'h0000;
 RegFile[3] = 16'h0000;
 RegFile[4] = 16'h0000;
 RegFile[5] = 16'h0000;
 RegFile[6] = 16'h0000;
 RegFile[7] = 16'h0000;
end
else if (state == 4'b1001) begin    // Update Register based on ID of dr
 case (dr[2:0]) //DR_in
 3'b000 : RegFile[0] = DR_in;
 3'b001 : RegFile[1] = DR_in;
 3'b010 : RegFile[2] = DR_in;
 3'b011 : RegFile[3] = DR_in;
 3'b100 : RegFile[4] = DR_in;
 3'b101 : RegFile[5] = DR_in;
 3'b110 : RegFile[6] = DR_in;
 3'b111 : RegFile[7] = DR_in;
 endcase
end

always@ (sr1 or sr2) begin
 case (sr1[2:0]) //VSR1
 3'b000 : VSR1 = RegFile[0];        // Set Variable Source Register 1
 3'b001 : VSR1 = RegFile[1];        // based on ID of sr1
 3'b010 : VSR1 = RegFile[2];
 3'b011 : VSR1 = RegFile[3];
 3'b100 : VSR1 = RegFile[4];
 3'b101 : VSR1 = RegFile[5];
 3'b110 : VSR1 = RegFile[6];
 3'b111 : VSR1 = RegFile[7];
 default : VSR1 = 16'h0000;
 endcase

 case (sr2[2:0]) //VSR2
 3'b000 : VSR2 = RegFile[0];        // Set Variable Source Register 2
 3'b001 : VSR2 = RegFile[1];        // based on ID of sr2
 3'b010 : VSR2 = RegFile[2];
 3'b011 : VSR2 = RegFile[3];
 3'b100 : VSR2 = RegFile[4];
 3'b101 : VSR2 = RegFile[5];
 3'b110 : VSR2 = RegFile[6];
 3'b111 : VSR2 = RegFile[7];
 default : VSR2 = 16'h0000;
 endcase
end
endmodule

module Writeback (W_Control, aluout, dout, pcout, npc, DR_in);

 input [15:0] aluout, dout, pcout, npc;      // Possible data to store
 input [1:0] W_Control;               // Control signal to choose what will be written
 output [15:0] DR_in;                   // Data that will be stored in the registerfile

 reg [15:0] DR_in;

 always @( W_Control or aluout or dout or pcout or npc )
 case(W_Control)
 2'b00 : DR_in = aluout;
 2'b01 : DR_in = dout;
 2'b10 : DR_in = pcout;
 2'b11 : DR_in = npc;
 default : DR_in = 16'hFFFF;
 endcase
endmodule