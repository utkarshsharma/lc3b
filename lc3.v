  module reg_fileandMain();

  parameter B=16, W=3;

  reg Clk;
  wire wr_en;
  wire [W-1:0] w_addr, r_addr1, r_addr2;
  wire [B-1:0] inData;
  wire [B-1:0] r_data1;
  wire [B-1:0] r_data2;
  wire [B-1:0] address;
  wire Dataout;

  reg [15:0] extended, mux1out, mux2out, mux3out, mux4out, mux5out;
  wire ALUout, incrementer;
  wire [15:0] instruction;
  reg [B-1:0] array_reg[2**W-1:0];
  wire mux1,mux3,mux4,mux5;
  wire [1:0] mux2;


  wire MemRead,PCwrite,ALUcontrol,MemWrite,PCread;

  always@(posedge Clk)
  begin
  if(wr_en)begin
    array_reg[w_addr]<=inData;
  end
  end
  assign r_data1=array_reg[r_addr1];
  assign r_data2=array_reg[r_addr2];

  controlUnit controlUnit0(Clk,instruction,mux1,mux2,mux3,mux4,mux5,MemRead,PCwrite,wr_en,ALUcontrol,MemWrite,PCread,r_addr1,r_addr2,w_addr);

  PCunit PCunit0(Clk,PCwrite,PCread,mux5out,address);

  DataMem DataMem0(Clk,mux2out,r_data1,MemRead,MemWrite,Dataout);

  ALU ALU0(mux1out,r_data2,ALUout,ALUcontrol);

  InstructionMemory InstructionMemory0(address,instruction);

  always @(mux1,mux2,mux3,mux4,mux5) begin
  if(mux1)begin
    extended = { {11{instruction[4]}}, instruction[4:0] };
    mux1out=extended;
  end
  else begin
    mux1out=r_data1;
  end

  if(mux2==2'b00)begin
    mux2out=ALUout;
    end
  else if(mux2==2'b01)begin
    extended = instruction[8:0];
    mux2out=extended;
    end
  else if(mux2==2'b11)begin
    extended = instruction[8:0];
    mux2out=extended;
    end

  if(mux3)begin
    mux3out=mux2out;
    end
  else begin
    mux3out=Dataout;
    end

  if(mux4)begin
    mux4out=address;
    end
  else begin
    mux4out=mux3out;
    end

  if(mux5)begin
    mux5out=address;
    end
  else begin
    mux5out=mux3out;
    end 

end

   assign inData=mux4out;
       always begin
   #20 Clk<=0;
   #20 Clk<=1;
 end

endmodule

  module controlUnit(Clk,in,mux1,mux2,mux3,mux4,mux5,MemRead,PCwrite,WE,ALUcontrol,MemWrite,PCread,rd1,rd2,wr);

  input Clk;
  input [15:0] in;
  output reg mux1,mux3,mux4,mux5,MemRead,PCwrite,WE,ALUcontrol,MemWrite,PCread;
  output reg [1:0] mux2;
  reg [3:0] state,stateNext;

  output wire [2:0] rd1,rd2,wr;

  initial begin
    state=4'b0111;
    stateNext=4'b0000;
    MemRead=0;
  end

  assign rd1=in[2:0];
  assign rd2=in[8:6];
  assign wr=in[11:9];

  always @* begin
    if (state==4'b0000)begin
      stateNext=4'b0001;
      PCread=1;
    end
    else if(state==4'b0001 && in[15:12]==0100)begin
      stateNext=4'b0100;
      MemRead=1;
    end
    else if(state==4'b0001 && in[15:12]==1000)begin
      stateNext=4'b0100;
      MemRead=1;
    end
      else if(state==4'b0001 && in[15:12]==0010)begin
      stateNext=4'b0010;
      MemRead=1;
    end
      else if(state==4'b0001 && in[15:12]==1100)begin
      stateNext=4'b1100;
      MemRead=1;
    end
      else if(state==4'b0001 && in[15:12]==1010)begin
      stateNext=4'b1010;
      MemRead=1;
    end
    else if(state==4'b0100)begin
      stateNext=4'b0101;
    end
    else if(state==4'b0101)begin
      stateNext=4'b0000;
      mux3=0;
      mux4=0; 
      WE=1; 
      mux2<=2'b01; 
      MemRead=1;
      PCwrite=1;
    end
    else if(state==4'b1000)begin
      stateNext=4'b0000;
      mux1=in[5];
      ALUcontrol=0; 
      mux3=1;
      mux4=0;
      WE=1;
      PCwrite=1;
    end
    else if(state==4'b0010)begin
      stateNext=4'b0000;
      mux1=in[5];
      ALUcontrol=1;
      mux3=1;
      mux4=0;
      WE=1;
      PCwrite=1;
    end
      else if(state==4'b1100)begin
      stateNext=4'b0000;
      mux2<=2'b01;
      MemWrite=1;
      PCwrite=1;
    end
    else if(state==4'b1010)begin
      stateNext=4'b0000;
      mux2<=2'b11;
      mux3=1;
      mux5=0;
      PCwrite=1;
    end
  end
  always @(posedge Clk) begin
      state = stateNext;
  end

  endmodule


   module ALU(in1,in2,ALUout,ALUcontrol);
  input ALUcontrol;
  input wire [15:0] in1, in2;
  output reg [15:0] ALUout;

    always @(in1, in2) begin
    if(ALUcontrol) 

    ALUout = in1 + in2;

else
    ALUout = in1 & in2; 

end
  endmodule

module InstructionMemory(address,instruction);
  input [15:0] address;
  output [15:0] instruction;

  reg [15:0] InstructionMemory [15:0];

  initial begin
    $readmemh("AssemblerOutput.hex", InstructionMemory);
  end

  assign instruction=InstructionMemory[address];

endmodule

module DataMem(Clk,AddrReg,in,MemRead,MemWrite,out);
  input Clk, MemRead, MemWrite;
  input [15:0] AddrReg, in;
  output reg [15:0] out;

  reg[15:0] Mem[2**9:0];

  always @(posedge Clk) begin
    if(MemWrite)begin
      Mem[AddrReg]=in;
    end
  end

  always @(MemRead) begin
    if(MemRead) begin
      out=Mem[AddrReg];
      end
      end

endmodule


module PCunit(Clk,PCwrite,PCread,in,out);
  input Clk,PCwrite,PCread;
  input wire [15:0] in;
  output reg [15:0] out;

  initial begin
    out=16'h0000;
    end

always @(posedge Clk) begin
    if(PCwrite==1)begin
      out=out+1;
    end
    if(PCread==1)begin
      out=in;
    end
  end


endmodule