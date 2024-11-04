`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: HFUT
// Engineer: Lu Jipeng, 2022217492 
// 
// Create Date: 2024/10/23 20:59:47
// Design Name: 
// Module Name: seg7
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

// module: Display 数字显示，以 16 进制显示一个 32 位的数
module Display (
    input clk,
    input [31:0] data,
    input ena,
    // 七段数码管的位选信号
    output [7:0] an,
    // 七段数码管的段选信号
    output [7:0] seg
);

  wire clk_seg_div;
  clk_div clkd (
      .clk0(clk),
      .clk (clk_seg_div)
  );

  EightSeg7 eightSeg7 (
      .clk (clk),
      .ena (ena),
      .seg0(data[3:0]),
      .seg1(data[7:4]),
      .seg2(data[11:8]),
      .seg3(data[15:12]),
      .seg4(data[19:16]),
      .seg5(data[23:20]),
      .seg6(data[27:24]),
      .seg7(data[31:28]),
      .an  (an),
      .seg (seg)
  );

endmodule

// 显示八个七段数码管
module EightSeg7 (
    input clk,
    input ena,
    input [3:0] seg0,
    input [3:0] seg1,
    input [3:0] seg2,
    input [3:0] seg3,
    input [3:0] seg4,
    input [3:0] seg5,
    input [3:0] seg6,
    input [3:0] seg7,
    // 七段数码管的位选信号
    output reg [7:0] an,
    // 七段数码管的段选信号
    output [7:0] seg
);
  reg [2:0] state;
  reg [3:0] bcd;
  Seg7Decoder decoder (
      .bcd(bcd),
      .seg(seg)
  );

  always @(posedge clk) begin
    if (ena) begin
      state <= state + 1;
    end
  end

  always @(*) begin
    if (ena) begin
      case (state)
        3'b000: begin
          an  = 8'b00000001;
          bcd = seg0;
        end
        3'b001: begin
          an  = 8'b00000010;
          bcd = seg1;
        end
        3'b010: begin
          an  = 8'b00000100;
          bcd = seg2;
        end
        3'b011: begin
          an  = 8'b00001000;
          bcd = seg3;
        end
        3'b100: begin
          an  = 8'b00010000;
          bcd = seg4;
        end
        3'b101: begin
          an  = 8'b00100000;
          bcd = seg5;
        end
        3'b110: begin
          an  = 8'b01000000;
          bcd = seg6;
        end
        3'b111: begin
          an  = 8'b10000000;
          bcd = seg7;
        end
      endcase
    end
    else begin
      an  = 8'b00000000;
      bcd = 4'h0;
    end
  end

  initial begin
    state = 0;
  end

endmodule

// 七段数码管解码器
// 4位BCD码 -> 8位七段数码管
module Seg7Decoder (
    input [3:0] bcd,
    output reg [7:0] seg
);
  always @(*) begin
    case (bcd)
      4'h0:    seg = 8'hfc;
      4'h1:    seg = 8'h60;
      4'h2:    seg = 8'hda;
      4'h3:    seg = 8'hf2;
      4'h4:    seg = 8'h66;
      4'h5:    seg = 8'hb6;
      4'h6:    seg = 8'hbe;
      4'h7:    seg = 8'he0;
      4'h8:    seg = 8'hfe;
      4'h9:    seg = 8'hf6;
      4'ha:    seg = 8'hee;
      4'hb:    seg = 8'h3e;
      4'hc:    seg = 8'h9c;
      4'hd:    seg = 8'h7a;
      4'he:    seg = 8'h9e;
      4'hf:    seg = 8'h8e;
      default: seg = 8'h00;
    endcase
  end
endmodule

module clk_div (
    input clk0,
    output reg clk
);
  parameter N = 32'd51200, WIDTH = 32 - 1;
  reg [WIDTH : 0] number = 0;

  initial begin
    clk = 1'b0;
  end

  always @(posedge clk0) begin
    if (number == N - 1) begin
      number <= 0;
      clk <= ~clk;
    end else begin
      number <= number + 1;
    end
  end
endmodule
