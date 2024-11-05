`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: HFUT
// Engineer: Lu Jipeng, 2022217492 
// 
// Create Date: 2024/10/23 21:59:02
// Design Name: 
// Module Name: top
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

//module: top
module top (
    input wire clk,
    input wire reset,
    // 指示是否挂起
    output wire halt,
    // 拨码开关，用于指示显示内存的地址
    input wire [15:0] sw,
    output wire [7:0] seg1,
    output wire [7:0] seg2,
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
  wire [11:0] dataRamAddr;

  wire cpu_clk;

  clk_div #(2'd1, 1'd1) clk_div (
    .clk0(clk),
    .clk(cpu_clk)
  );

  CPU cpu (
      .clk(cpu_clk),
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
      .clk(clk),
      .reset(reset),
      .re(instRamReadEna),
      .we(4'b0000),  // use as rom
      .addr(pc[13:2]),
      .din(32'b0),
      .dout(ir)
  );

  Select2_1 #(12) data_ram_addr_select (
      .inp0(aluResult[13:2]), // exec
      .inp1(sw[11:0]), // sw
      .sel (halt),
      .enb (1'b0),
      .out (dataRamAddr)
  );

  DataRAM data_ram (
      .clk(clk),
      .reset(reset),
      .re(dataRamReadEna | halt),
      .we({4{dataRamWriteEna}}),
      // .addr(aluResult[13:2]),
      .addr(dataRamAddr),
      .din(dataRamWriteData),
      .dout(dataRamReadData)
  );

  HaltDisplay halt_display (
    .ir(ir),
    .halt(halt)
  );

  Display display (
      .clk(clk),
      .data(dataRamReadData),
      // .data(32'h12345678),
      // .ena(halt),
      // .data(pc),
      .ena(1'b1),
      .an(an),
      .seg1(seg1),
      .seg2(seg2)
  );
endmodule

module HaltDisplay (
  input wire [31:0] ir,
  output wire halt
);

  assign halt = ir[31:26] == 6'b111111 ? 1'b1 : 1'b0;
  
endmodule