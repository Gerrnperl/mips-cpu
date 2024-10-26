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
      .waddr(regWriteDst),  // 存储到 rt (regDst == 0) 或 rd (regDst == 1)
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
