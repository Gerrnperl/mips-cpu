`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/27 00:00:37
// Design Name: 
// Module Name: top_test
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


module top_test;
  reg clk;
  reg rst;

  top uut (
      .clk  (clk),
      .reset(rst)
  );

  // Generate clock signal
  always #2 clk = ~clk;

  initial begin
    // Initialize Inputs
    clk = 0;
    rst = 1;
    #2;
    rst = 0;
    #2;
    rst = 1;
    #140;
    $finish;
  end


endmodule
