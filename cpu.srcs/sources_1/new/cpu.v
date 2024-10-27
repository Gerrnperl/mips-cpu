`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: HFUT
// Engineer: Lu Jipeng, 2022217492 
// 
// Create Date: 2024/10/26 17:04:51
// Design Name: 
// Module Name: cpu
// Project Name: mips-cpu
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

//module: CPU MIPS 处理器，包含控制器和数据通路
module CPU (
    input wire clk,
    input wire reset,
    input wire [31:0] ir,
    input wire [31:0] dataRamReadData,
    output wire [31:0] pc,
    output wire [31:0] aluResult,
    output wire instRamReadEna,
    output wire dataRamReadEna,
    output wire dataRamWriteEna,
    output wire [31:0] dataRamWriteData
);

  assign instRamReadEna = 1'b1;

  wire jump;
  wire branch;
  wire aluSrcA;
  wire aluSrcB;
  wire memToReg;
  wire regWrite;
  wire regDst;
  wire [3:0] aluControl;

  Controller controller (
      .instruction(ir),
      .jump(jump),
      .branch(branch),
      .aluSrcA(aluSrcA),
      .aluSrcB(aluSrcB),
      .memRead(dataRamReadEna),
      .memWrite(dataRamWriteEna),
      .memToReg(memToReg),
      .regWrite(regWrite),
      .regDst(regDst),
      .aluControl(aluControl)
  );

  Datapath datapath (
      .clka(clk),
      .reset(reset),
      .ir(ir),
      .memReadData(dataRamReadData),
      .pc(pc),
      .aluResult(aluResult),
      .memWriteData(dataRamWriteData),

      .jump(jump),
      .branch(branch),
      .aluSrcA(aluSrcA),
      .aluSrcB(aluSrcB),
      .memToReg(memToReg),
      .regWrite(regWrite),
      .regDst(regDst),
      .aluControl(aluControl)
  );


endmodule
