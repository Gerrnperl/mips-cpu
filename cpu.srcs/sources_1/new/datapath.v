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


// | �ź� | ���ܶ��� | ��ֵ0ʱ���� | ��ֵ1ʱ���� |
// | --- | --- | --- | --- |
// | Jump | Jָ��Ŀ���ַѡ�� | ��Branch������� | ѡ��JĿ���ַ |
// | Branch | Bָ��Ŀ���ַѡ�� | ѡ��PC+4��ַ | ѡ��ת�Ƶ�ַ PC = (PC+4) + Imm \* 4 |
// | ALUSrc | ALU�˿�B����ѡ�� | ѡ��Ĵ���rt���� | ѡ��32λ������<font class="font6">(������չ��)</font> |
// | MemRead | �洢�������� | ��ֹ�洢���� | ʹ�ܴ洢���� |
// | MemWrite | �洢��д���� | ��ֹ�洢��д | ʹ�ܴ洢��д |
// | MemtoReg | �Ĵ���д������ѡ�� | ѡ��ALU��� | ѡ��洢������ |
// | RegWrite | �Ĵ���д���� | ��ֹ�Ĵ���д | ʹ�ܼĴ���д |
// | RegDst | �Ĵ���д��ַѡ�� | ѡ��ָ��rt�� | ѡ��ָ��rd�� |
// | ALU\_Control | 4λALU�������� |  |  |


module datapath (
    input wire clka,
    input wire reset
);

  wire [31:0] pc;
  wire [31:0] pcPlus4;
  wire [31:0] pcBranch;
  wire [31:0] pcNext;
  wire [31:0] ir;
  wire [31:0] regData1;
  wire [31:0] regData2;
  wire [31:0] immExt;
  wire [31:0] aluResult;
  wire [31:0] memReadData;

  wire [31:0] aluSrcB;
  wire [31:0] regWriteData;
  wire [ 4:0] regWriteDst;

  wire [31:0] bTarget;

  Select2_1 #(32) pc_branch_select (
      .inp0(pcPlus4),
      .inp1(pcBranch),
      .sel(),  // beq, bne result
      .enb(1'b0),
      .out(pcNext)
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
      .in (ir[15:0]),  // imm
      .out(immExt)
  );

  Select2_1 #(32) mem2reg_select (
      .inp0(aluResult),
      .inp1(memReadData),
      .sel(),  // ctrl-memToReg
      .enb(1'b0),
      .out(regWriteData)
  );

  Select2_1 #(5) reg_dst_select (
      .inp0(ir[20:16]),  // rt
      .inp1(ir[15:11]),  // rd
      .sel(),  // ctrl-regDst
      .enb(1'b0),
      .out(regWriteDst)
  );

  Regfiles regfiles0 (
      .clk(clka),
      .reset(reset),
      .we(),
      .raddr1(ir[25:21]),  // rs
      .raddr2(ir[20:16]),  // rt
      .waddr(regWriteDst),  // �洢�� rt (regDst == 0) �� rd (regDst == 1)
      .wdata(regWriteData),
      .rdata1(regData1),
      .rdata2(regData2)
  );

  Select2_1 #(32) alu_srcB_select (
      .inp0(regData2),
      .inp1(immExt),
      .sel(),  // ctrl-aluSrc
      .enb(1'b0),
      .out(aluSrcB)
  );


  ALU alu0 (
      .a(regData1),
      .b(aluSrcB),
      .func(),  // aluControl
      .negative(),
      .zero(),
      .carry(),
      .overflow(),
      .result(aluResult)
  );

  InstRAM inst_ram (
      .clk(clka),
      .reset(reset),
      .re(),
      .we(),
      .addr(pc[11:0]),
      .din(),
      .dout(ir)
  );

  DataRAM data_ram (
      .clk(clka),
      .reset(reset),
      .re(),
      .we(),
      .addr(aluResult[11:0]),
      .din(regData2),
      .dout(memReadData)
  );

endmodule
