`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: HFUT
// Engineer: Lu Jipeng, 2022217492 
// 
// Create Date: 2024/10/25 20:54:22
// Design Name: 
// Module Name: reg_test
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


module reg_test;

  // Inputs
  reg clk;
  reg rst;
  reg we;
  reg [4:0] raddr1;
  reg [4:0] raddr2;
  reg [4:0] waddr;
  reg [31:0] wdata;

  // Outputs
  wire [31:0] rdata1;
  wire [31:0] rdata2;

  // Instantiate the Regfiles module
  Regfiles uut (
    .clk(clk),
    .reset(rst),
    .we(we),
    .raddr1(raddr1),
    .raddr2(raddr2),
    .waddr(waddr),
    .wdata(wdata),
    .rdata1(rdata1),
    .rdata2(rdata2)
  );

  // Generate clock signal
  always #5 clk = ~clk;

  initial begin
    // Initialize Inputs
    clk = 0;
    rst = 1;
    we = 1;
    raddr1 = 0;
    raddr2 = 0;
    waddr = 0;
    wdata = 0;

    #10;
    rst = 0;
    #10;
    rst = 1;
    $display("Reset Test: rdata1 = %h, rdata2 = %h (expected: 0x00000000, 0x00000000)", rdata1, rdata2);

    // Test write functionality
    we = 0;
    waddr = 5'd1;
    wdata = 32'hA5A5A5A5;
    #20;
    we = 1;
    raddr1 = 5'd1;
    #20;
    $display("Write Test: rdata1 = %h (expected: 0xA5A5A5A5)", rdata1);

    // Test read functionality
    raddr2 = 5'd1;
    #10;
    $display("Read Test: rdata2 = %h (expected: 0xA5A5A5A5)", rdata2);

    // Test simultaneous read and write
    we = 0;
    waddr = 5'd2;
    wdata = 32'h5A5A5A5A;
    raddr1 = 5'd1;
    raddr2 = 5'd2;
    #10;
    we = 1;
    #10;
    $display("Simultaneous Read/Write Test: rdata1 = %h (expected: 0xA5A5A5A5), rdata2 = %h (expected: 0x5A5A5A5A)", rdata1, rdata2);

    $finish;
  end

endmodule