`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: HFUT
// Engineer: Lu Jipeng, 2022217492 
// 
// Create Date: 2024/10/23 21:22:45
// Design Name: 
// Module Name: utils
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

// module: Bin2BCD 二进制转BCD码
module Bin2BCD (
    input  wire [31:0] bin,
    output reg  [ 3:0] bcd
);

  reg [ 3:0] bcd_next;
  reg [31:0] bin_next;

  always @(*) begin
    bin_next = bin;
  end

  always @(*) begin
    bcd_next = 4'b0;
    for (integer i = 0; i < 32; i = i + 1) begin
      if (bin_next >= 5'd5) begin
        bcd_next = bcd_next + 1;
        bin_next = bin_next - 5'd5;
      end
      bcd_next = bcd_next << 1;
      bin_next = bin_next << 1;
    end
  end

  always @(posedge bin) begin
    bcd <= bcd_next;
  end

endmodule

// module: Decode5_32 5-32译码器
module Decode5_32 (
    input [4:0] inp,  // 输入信号
    input enb,  // 使能信号 
    output reg [31:0] out  // 输出信号
);

  always @(inp or enb) begin
    if (!enb) begin
      for (integer i = 0; i < 32; i = i + 1) begin
        if (i == inp) begin
          out = 32'b1 << i;
        end
      end
    end else begin
      out = 32'b0;
    end
  end

endmodule

// module: Select32_1 32选1选择器
// 每个输入信号为32位
module Select32_1 (
    input [31:0] inp0,
    input [31:0] inp1,
    input [31:0] inp2,
    input [31:0] inp3,
    input [31:0] inp4,
    input [31:0] inp5,
    input [31:0] inp6,
    input [31:0] inp7,
    input [31:0] inp8,
    input [31:0] inp9,
    input [31:0] inp10,
    input [31:0] inp11,
    input [31:0] inp12,
    input [31:0] inp13,
    input [31:0] inp14,
    input [31:0] inp15,
    input [31:0] inp16,
    input [31:0] inp17,
    input [31:0] inp18,
    input [31:0] inp19,
    input [31:0] inp20,
    input [31:0] inp21,
    input [31:0] inp22,
    input [31:0] inp23,
    input [31:0] inp24,
    input [31:0] inp25,
    input [31:0] inp26,
    input [31:0] inp27,
    input [31:0] inp28,
    input [31:0] inp29,
    input [31:0] inp30,
    input [31:0] inp31,

    input [4:0] sel,
    input enb,
    output reg [31:0] out
);

  always @(*) begin
    if (!enb) begin
      case (sel)
        5'b00000: out = inp0;
        5'b00001: out = inp1;
        5'b00010: out = inp2;
        5'b00011: out = inp3;
        5'b00100: out = inp4;
        5'b00101: out = inp5;
        5'b00110: out = inp6;
        5'b00111: out = inp7;
        5'b01000: out = inp8;
        5'b01001: out = inp9;
        5'b01010: out = inp10;
        5'b01011: out = inp11;
        5'b01100: out = inp12;
        5'b01101: out = inp13;
        5'b01110: out = inp14;
        5'b01111: out = inp15;
        5'b10000: out = inp16;
        5'b10001: out = inp17;
        5'b10010: out = inp18;
        5'b10011: out = inp19;
        5'b10100: out = inp20;
        5'b10101: out = inp21;
        5'b10110: out = inp22;
        5'b10111: out = inp23;
        5'b11000: out = inp24;
        5'b11001: out = inp25;
        5'b11010: out = inp26;
        5'b11011: out = inp27;
        5'b11100: out = inp28;
        5'b11101: out = inp29;
        5'b11110: out = inp30;
        default:  out = inp31;
      endcase
    end else begin
      out = 32'b0;
    end
    ;
  end

endmodule
