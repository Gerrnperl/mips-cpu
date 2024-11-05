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
    output [7:0] seg1,
    output [7:0] seg2
);

  wire clk_seg_div;
  clk_div clkd (
      .clk0(clk),
      .clk (clk_seg_div)
  );

  EightSeg7 eightSeg7 (
      .clk (clk_seg_div),
      .ena (ena),
      .seg0(data[31:28]),
      .seg1(data[27:24]),
      .seg2(data[23:20]),
      .seg3(data[19:16]),
      .seg4(data[15:12]),
      .seg5(data[11:8]),
      .seg6(data[7:4]),
      .seg7(data[3:0]),
      .an  (an),
      .segout1 (seg1),
      .segout2 (seg2)
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
    output reg [7:0] segout1,
    output reg [7:0] segout2
);
  reg [2:0] state;
  reg [3:0] bin;
  
  wire [7:0] seg;

  Seg7Decoder decoder (
      .bin(bin),
      .seg(seg)
  );

  always @(*) begin
    case (an)
      8'b00000001: segout1 = seg;
      8'b00000010: segout1 = seg;
      8'b00000100: segout1 = seg;
      8'b00001000: segout1 = seg;
      8'b00010000: segout2 = seg;
      8'b00100000: segout2 = seg;
      8'b01000000: segout2 = seg;
      8'b10000000: segout2 = seg;
      default: begin segout1 = 8'h00; segout2 = 8'h00; end
    endcase
  end
  

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
          bin = seg0;
        end
        3'b001: begin
          an  = 8'b00000010;
          bin = seg1;
        end
        3'b010: begin
          an  = 8'b00000100;
          bin = seg2;
        end
        3'b011: begin
          an  = 8'b00001000;
          bin = seg3;
        end
        3'b100: begin
          an  = 8'b00010000;
          bin = seg4;
        end
        3'b101: begin
          an  = 8'b00100000;
          bin = seg5;
        end
        3'b110: begin
          an  = 8'b01000000;
          bin = seg6;
        end
        3'b111: begin
          an  = 8'b10000000;
          bin = seg7;
        end
      endcase
    end
    else begin
      an  = 8'b00000000;
      bin = 4'h0;
    end
  end

  initial begin
    state = 0;
  end

endmodule

// 七段数码管解码器
// 4位二进制数 -> 8位七段数码管
module Seg7Decoder (
    input [3:0] bin,
    output reg [7:0] seg
);
  always @(*) begin
    case (bin)
      // dp g f e d c b a
      4'h0:    seg = 8'b00111111;
      4'h1:    seg = 8'b00000110;
      4'h2:    seg = 8'b01011011;
      4'h3:    seg = 8'b01001111;
      4'h4:    seg = 8'b01100110;
      4'h5:    seg = 8'b01101101;
      4'h6:    seg = 8'b01111101;
      4'h7:    seg = 8'b00100111;
      4'h8:    seg = 8'b01111111;
      4'h9:    seg = 8'b01101111;
      4'ha:    seg = 8'b01110111;
      4'hb:    seg = 8'b01111100;
      4'hc:    seg = 8'b00111001;
      4'hd:    seg = 8'b01011110;
      4'he:    seg = 8'b01111001;
      4'hf:    seg = 8'b01110001;
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
