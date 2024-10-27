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


// 显示一个七段数码管
module OneSeg7 (
    input clk,
    input [3:0] seg0,
    output reg an,
    output reg [7:0] seg
);
  reg state;
  reg [3:0] bcd;
  Seg7Decoder decoder (
      .bcd(bcd),
      .seg(seg)
  );

  always @(posedge clk) begin
    state <= state + 1;
  end

  always @(*) begin
    case (state)
      1'b0: begin
        an  = 1'b1;
        bcd = seg0;
      end
    endcase
  end

  initial begin
    state = 0;
  end
endmodule

// 显示两个七段数码管
module TwoSeg7 (
    input clk,
    input [3:0] seg0,
    input [3:0] seg1,
    output reg [1:0] an,
    output reg [7:0] seg
);
  reg state;
  reg [3:0] bcd;
  Seg7Decoder decoder (
      .bcd(bcd),
      .seg(seg)
  );

  always @(posedge clk) begin
    state <= state + 1;
  end

  always @(*) begin
    case (state)
      1'b0: begin
        an  = 2'b01;
        bcd = seg0;
      end
      1'b1: begin
        an  = 2'b10;
        bcd = seg1;
      end
    endcase
  end

  initial begin
    state = 0;
  end
endmodule

// 显示四个七段数码管
module FourSeg7 (
    input clk,
    input [3:0] seg0,
    input [3:0] seg1,
    input [3:0] seg2,
    input [3:0] seg3,
    output reg [3:0] an,
    output reg [7:0] seg
);
  reg [1:0] state;
  reg [3:0] bcd;
  Seg7Decoder decoder (
      .bcd(bcd),
      .seg(seg)
  );

  always @(posedge clk) begin
    state <= state + 1;
  end

  always @(*) begin
    case (state)
      2'b00: begin
        an  = 4'b0001;
        bcd = seg0;
      end
      2'b01: begin
        an  = 4'b0010;
        bcd = seg1;
      end
      2'b10: begin
        an  = 4'b0100;
        bcd = seg2;
      end
      2'b11: begin
        an  = 4'b1000;
        bcd = seg3;
      end
    endcase
  end

  initial begin
    state = 0;
  end

endmodule

// 显示八个七段数码管
module EightSeg7 (
    input clk,
    input [3:0] seg0,
    input [3:0] seg1,
    input [3:0] seg2,
    input [3:0] seg3,
    input [3:0] seg4,
    input [3:0] seg5,
    input [3:0] seg6,
    input [3:0] seg7,
    output reg [7:0] an,
    output reg [7:0] seg
);
  reg [2:0] state;
  reg [3:0] bcd;
  Seg7Decoder decoder (
      .bcd(bcd),
      .seg(seg)
  );

  always @(posedge clk) begin
    state <= state + 1;
  end

  always @(*) begin
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
