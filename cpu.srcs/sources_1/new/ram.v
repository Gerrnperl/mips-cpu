`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: HFUT
// Engineer: Lu Jipeng, 2022217492 
// 
// Create Date: 2024/10/24 02:51:05
// Design Name: 
// Module Name: ram
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

// (* x_core_info = "blk_mem_gen_v8_4_3,Vivado 2019.1" *)
// module blk_mem_gen_0(clka, ena, wea, addra, dina, douta)
// /* synthesis syn_black_box black_box_pad_pin="clka,ena,wea[3:0],addra[11:0],dina[31:0],douta[31:0]" */;
//   input clka; // 时钟
//   input ena; // 使能
//   input [3:0]wea; // 写使能
//   input [11:0]addra; // 地址
//   input [31:0]dina;  // 数据输入
//   output [31:0]douta;    // 数据输出
// endmodule

// module: InstRAM
// 程序存储器
// 32位宽，4096个地址
// 设置使能后，在下一个上升沿完成读写
module InstRAM (
    input wire clk,
    input wire reset,
    input wire re,
    input wire [3:0] we,
    input wire [11:0] addr,
    input wire [31:0] din,
    output wire [31:0] dout
);

  reg en;

  // 设定
  always @(negedge clk or negedge reset) begin
    if (!reset) begin
      en <= 0;
    end else begin
      // 读写使能
      if (we || re) begin
        en <= 1;
      end else begin
        en <= 0;
      end
    end
  end

  blk_mem_gen_0 uut (
      .clka (clk),
      .ena  (en),
      .wea  (we),
      .addra(addr),
      .dina (din),
      .douta(dout)
  );

endmodule


// module: DataRAM
// 数据存储器
// 32位宽，4096个地址
// 设置使能后，在下一个上升沿完成读写
module DataRAM (
    input wire clk,
    input wire reset,
    input wire re,
    input wire [3:0] we,
    input wire [11:0] addr,
    input wire [31:0] din,
    output wire [31:0] dout
);

  reg en;

  // 设定
  always @(negedge clk or negedge reset) begin
    if (!reset) begin
      en <= 0;
    end else begin
      // 读写使能
      if (we || re) begin
        en <= 1;
      end else begin
        en <= 0;
      end
    end
  end

  blk_mem_gen_1 uut (
      .clka (clk),
      .ena  (en),
      .wea  (we),
      .addra(addr),
      .dina (din),
      .douta(dout)
  );

endmodule