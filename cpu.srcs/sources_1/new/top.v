`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: HFUT
// Engineer: Lu Jipeng, 2022217492 
// 
// Create Date: 2024/10/23 21:59:02
// Design Name: 
// Module Name: top
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


module top (
    input wire clk,
    input wire reset,
    output wire [7:0] seg,
    output wire [7:0] an
);

  wire instRamReadEna;
  wire dataRamReadEna;
  wire dataRamWriteEna;
  wire [31:0] dataRamWriteData;
  wire [31:0] dataRamReadData;
  wire [31:0] pc;
  wire [31:0] ir;
  wire [31:0] aluResult;


  CPU cpu (
      .clk(clk),
      .reset(reset),
      .instRamReadEna(instRamReadEna),
      .dataRamReadEna(dataRamReadEna),
      .dataRamWriteEna(dataRamWriteEna),
      .dataRamWriteData(dataRamWriteData),
      .dataRamReadData(dataRamReadData),
      .pc(pc),
      .ir(ir),
      .aluResult(aluResult)
  );

  InstRAM inst_ram (
      .clk(clka),
      .reset(reset),
      .re(instRamReadEna),
      .we(4'b0000),  // use as rom
      .addr(pc[11:0]),
      .din(32'b0),
      .dout(ir)
  );

  DataRAM data_ram (
      .clk(clka),
      .reset(reset),
      .re(dataRamReadEna),
      .we({4{dataRamWriteEna}}),
      .addr(aluResult[11:0]),
      .din(dataRamWriteData),
      .dout(dataRamReadData)
  );
endmodule
