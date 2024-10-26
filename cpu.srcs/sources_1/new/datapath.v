`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/26 14:52:24
// Design Name: 
// Module Name: datapath
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


// | 信号 | 功能定义 | 赋值0时动作 | 赋值1时动作 |
// | --- | --- | --- | --- |
// | Jump | J指令目标地址选择 | 由Branch决定输出 | 选择J目标地址 |
// | Branch | B指令目标地址选择 | 选择PC+4地址 | 选择转移地址 PC = (PC+4) + Imm \* 4 |
// | ALUSrc | ALU端口B输入选择 | 选择寄存器rt数据 | 选择32位立即数<font class="font6">(符号扩展后)</font> |
// | MemRead | 存储器读控制 | 禁止存储器读 | 使能存储器读 |
// | MemWrite | 存储器写控制 | 禁止存储器写 | 使能存储器写 |
// | MemtoReg | 寄存器写入数据选择 | 选择ALU输出 | 选择存储器数据 |
// | RegWrite | 寄存器写控制 | 禁止寄存器写 | 使能寄存器写 |
// | RegDst | 寄存器写地址选择 | 选择指令rt域 | 选择指令rd域 |
// | ALU\_Control | 4位ALU操作控制 |  |  |


module Datapath (
    input wire clka,
    input wire reset,
    input wire [31:0] ir,
    input wire [31:0] memReadData,
    output wire [31:0] pc,
    output wire [31:0] aluResult,
    output wire [31:0] memWriteData,

    input wire jump,
    input wire branch,
    input wire aluSrc,
    input wire memToReg,
    input wire regWrite,
    input wire regDst,
    input wire [3:0] aluControl
);

  wire pcSrc;
  wire [31:0] pcPlus4;
  wire [31:0] pcBranch;
  wire [31:0] pcJump;
  wire [31:0] pcNext;
  wire [31:0] regData1;
  wire [31:0] regData2;
  wire [31:0] immExt;

  wire [31:0] aluSrcB;
  wire [31:0] regWriteData;
  wire [4:0] regWriteDst;

  wire [31:0] bTarget;

  // 链接寄存器LR, R31
  wire [4:0] regLR = 5'b11111;
  wire lrWrite;
  wire regWriteAndLR;
  assign regWriteAndLR = regWrite | lrWrite;

  wire zero;
  wire negative;
  wire carry;
  wire overflow;

  assign memWriteData = regData2;

  // pcJump = (PC+4)[31..28], addr, 0,0
  assign pcJump = {pcPlus4[31:28], ir[25:0], 2'b00};

  PCSelect pc_select (
      .pcPlus4(pcPlus4),
      .pcBranch(pcBranch),
      .pcJump(pcJump),
      .opcode(ir[5:0]),
      .jump(jump),
      .branch(branch),
      .zero(zero),
      .negative(negative),
      .carry(carry),
      .overflow(overflow),
      .pcNext(pcNext)
  );

  PC pc0 (
      .clk(clka),
      .reset(reset),
      .pc_in(pcNext),
      .pc_out(pc)
  );

  Adder32 pc_next_adder (
      .a  (pc),
      .b  (32'd4),
      .sum(pcPlus4)
  );

  ShiftLeft32_2 b_target_shift (
      .inp(immExt),
      .out(bTarget)
  );

  Adder32 pc_branch_adder (
      .a  (pcPlus4),
      .b  (bTarget),
      .sum(pcBranch)
  );

  SignExtend16_32 sign_extend_imm (
      .inp(ir[15:0]),  // imm
      .out(immExt)
  );

  LRController lr_controller (
      .opcode (ir[5:0]),
      .lrWrite(lrWrite)
  );

  Select4_1 #(32) mem2reg_select (
      .inp0(aluResult),
      .inp1(memReadData),
      .inp2(pc),
      .inp3(pc),
      .sel ({lrWrite, memToReg}),
      .enb (1'b0),
      .out (regWriteData)
  );

  Select4_1 #(5) reg_dst_select (
      .inp0(ir[20:16]),          // rt
      .inp1(ir[15:11]),          // rd
      .inp2(regLR),              // lr
      .inp3(regLR),              // lr
      .sel ({lrWrite, regDst}),
      .enb (1'b0),
      .out (regWriteDst)
  );

  Regfiles regfiles0 (
      .clk(clka),
      .reset(reset),
      .we(regWriteAndLR),
      .raddr1(ir[25:21]),  // rs
      .raddr2(ir[20:16]),  // rt
      .waddr(regWriteDst),  // 存储到 rt (regDst == 0) 或 rd (regDst == 1)
      .wdata(regWriteData),
      .rdata1(regData1),
      .rdata2(regData2)
  );

  Select2_1 #(32) alu_srcB_select (
      .inp0(regData2),
      .inp1(immExt),
      .sel (aluSrc),
      .enb (1'b0),
      .out (aluSrcB)
  );

  ALU alu0 (
      .a(regData1),
      .b(aluSrcB),
      .func(aluControl),
      .negative(negative),
      .zero(zero),
      .carry(carry),
      .overflow(overflow),
      .result(aluResult)
  );


endmodule
