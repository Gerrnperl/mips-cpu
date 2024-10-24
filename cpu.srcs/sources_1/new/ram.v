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

// RAM
// 32位宽，4096个地址
// 设置使能后，需要一个时钟周期后才能完成读写
module ram (
    input wire clk,
    input wire reset,
    input wire re,
    input wire [3:0] we,
    input wire [11:0] addr,
    input wire [31:0] din,
    output reg [31:0] dout
);

  reg en;
  reg [31:0] idata;
  wire [31:0] odata;

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

  // 读写
  always @(negedge clk or negedge reset) begin
    if (!reset) begin
      idata <= 0;
      dout  <= 0;
    end else begin
      // 写
      if (we) begin
        idata <= din;
      end  // 读
      else if (re) begin
        dout <= odata;
      end
    end
  end


  blk_mem_gen_0 uut (
      .clka (clk),
      .ena  (en),
      .wea  (we),
      .addra(addr),
      .dina (idata),
      .douta(dout)
  );

endmodule
