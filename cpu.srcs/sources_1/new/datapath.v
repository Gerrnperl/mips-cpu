`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: HFUT
// Engineer: Lu Jipeng, 2022217492 
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


// | �ź� | ���ܶ��� | ��ֵ0ʱ���� | ��ֵ1ʱ���� |
// | --- | --- | --- | --- |
// | Jump | Jָ��Ŀ���ַѡ�� | ��Branch������� | ѡ��JĿ���ַ |
// | Branch | Bָ��Ŀ���ַѡ�� | ѡ��PC+4��ַ | ѡ��ת�Ƶ�ַ PC = (PC+4) + Imm \* 4 |
// | aluSrcA | ALU�˿�A����ѡ�� | ѡ��Ĵ���rs���� | ѡ�� shamt |
// | aluSrcB | ALU�˿�B����ѡ�� | ѡ��Ĵ���rt���� | ѡ��32λ������<font class="font6">(������չ��)</font> |
// | MemRead | �洢�������� | ��ֹ�洢���� | ʹ�ܴ洢���� |
// | MemWrite | �洢��д���� | ��ֹ�洢��д | ʹ�ܴ洢��д |
// | MemtoReg | �Ĵ���д������ѡ�� | ѡ��ALU��� | ѡ��洢������ |
// | RegWrite | �Ĵ���д���� | ��ֹ�Ĵ���д | ʹ�ܼĴ���д |
// | RegDst | �Ĵ���д��ַѡ�� | ѡ��ָ��rt�� | ѡ��ָ��rd�� |
// | ALU\_Control | 4λALU�������� |  |  |

//module: Datapath ����ͨ·
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
    input wire aluSrcA,
    input wire aluSrcB,
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

  wire [31:0] aluSrcASelect;
  wire [31:0] aluSrcBSelect;
  wire [31:0] regWriteData;
  wire [4:0] regWriteDst;

  wire [31:0] bTarget;

  // ���ӼĴ���LR, R31
  wire [4:0] regLR = 5'b11111;
  wire lrWrite;
  wire regWriteAndLR;
  assign regWriteAndLR = regWrite | lrWrite;

  // lui and shamt* instructions
  wire shamtImm16;
  wire [4:0] shamt;

  // ALU Flags
  wire zero;
  wire negative;
  wire carry;
  wire overflow;

  assign memWriteData = regData2;

  // pcJump = (PC+4)[31..28], addr, 0,0
  assign pcJump = {pcPlus4[31:28], ir[25:0], 2'b00};

  // PC = {
  //  PC + 4,
  //  PC + 4 + branchAddrImm * 4, // b* ָ��
  //  (PC + 4)[31..28], addr, 0,0,  // j ָ��
  // }
  PCSelect pc_select (
      .pcPlus4(pcPlus4),
      .pcBranch(pcBranch),
      .pcJump(pcJump),
      .opcode(ir[31:26]),
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

  // bTarget = immExt << 2
  ShiftLeft32_2 b_target_shift (
      .inp(immExt),
      .out(bTarget)
  );

  Adder32 pc_branch_adder (
      .a  (pcPlus4),
      .b  (bTarget),
      .sum(pcBranch)
  );

  // ��չ I-type ָ���������
  SignExtend16_32 sign_extend_imm (
      .inp(ir[15:0]),  // imm
      .out(immExt)
  );

  LRController lr_controller (
      .opcode (ir[5:0]),
      .lrWrite(lrWrite)
  );

  // ѡ��Ĵ���д������
  // 0. ALU ���
  // 1. �洢����ȡ����
  // 2,3. PC (jalָ��)
  Select4_1 #(32) mem2reg_select (
      .inp0(aluResult),
      .inp1(memReadData),
      .inp2(pc),
      .inp3(pc),
      .sel ({lrWrite, memToReg}),
      .enb (1'b0),
      .out (regWriteData)
  );

  // ѡ��Ĵ���д���ַ
  // 0. rt
  // 1. rd
  // 2,3. lr <- PC
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
      .waddr(regWriteDst),  // �洢�� rt (regDst == 0) �� rd (regDst == 1)
      .wdata(regWriteData),
      .rdata1(regData1),
      .rdata2(regData2)
  );

  // lui ָ�����
  LUIController lui_controller (
      .opcode(ir[5:0]),
      .shamtImm16(shamtImm16)
  );

  Select2_1 #(32) shamt_select (
      .inp0(ir[10:6]),
      .inp1(5'b10000),    // ����16λ
      .sel (shamtImm16),
      .enb (1'b0),
      .out (shamt)
  );

  // ѡ�� ALU A����
  // 0. rs
  // 1. shamt or ������16(lui)
  Select2_1 #(32) alu_srcA_select (
      .inp0(regData1),
      .inp1(shamt),
      .sel (aluSrcA),
      .enb (1'b0),
      .out (aluSrcASelect)
  );

  // ѡ�� ALU B����
  // 0. rt
  // 1. ������ (������չ��, I-type)
  Select2_1 #(32) alu_srcB_select (
      .inp0(regData2),
      .inp1(immExt),
      .sel (aluSrcB),
      .enb (1'b0),
      .out (aluSrcBSelect)
  );

  ALU alu0 (
      .a(aluSrcASelect),
      .b(aluSrcBSelect),
      .func(aluControl),
      .negative(negative),
      .zero(zero),
      .carry(carry),
      .overflow(overflow),
      .result(aluResult)
  );


endmodule
