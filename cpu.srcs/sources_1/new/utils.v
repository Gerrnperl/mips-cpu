`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
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

// Bin to BCD
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
    for (int i = 0; i < 32; i = i + 1) begin
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
