`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/23 21:20:26
// Design Name: 
// Module Name: alu_test
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

module ALU_Test;

    // Inputs
    reg [31:0] a;
    reg [31:0] b;
    reg [3:0] func;

    // Outputs
    wire zero;
    wire [31:0] result;

    // Instantiate the ALU
    ALU uut (
        .a(a),
        .b(b),
        .func(func),
        .zero(zero),
        .result(result)
    );

    initial begin
        // Test AND operation
        a = 32'hA5A5A5A5; b = 32'h5A5A5A5A; func = 4'b0000;
        #10;
        $display("AND: a = %h, b = %h, result = %h, expected = %h", a, b, result, a & b);

        // Test OR operation
        a = 32'hA5A5A5A5; b = 32'h5A5A5A5A; func = 4'b0001;
        #10;
        $display("OR: a = %h, b = %h, result = %h, expected = %h", a, b, result, a | b);

        // Test ADD operation
        a = 32'h00000001; b = 32'h00000001; func = 4'b0010;
        #10;
        $display("ADD: a = %h, b = %h, result = %h, expected = %h", a, b, result, a + b);

        // Test SUB operation
        a = 32'h00000002; b = 32'h00000001; func = 4'b0110;
        #10;
        $display("SUB: a = %h, b = %h, result = %h, expected = %h", a, b, result, a - b);

        // Test SLT operation
        a = 32'h00000001; b = 32'h00000002; func = 4'b0111;
        #10;
        $display("SLT: a = %h, b = %h, result = %h, expected = %h", a, b, result, (a < b) ? 32'h1 : 32'h0);

        // Test NOR operation
        a = 32'hA5A5A5A5; b = 32'h5A5A5A5A; func = 4'b1100;
        #10;
        $display("NOR: a = %h, b = %h, result = %h, expected = %h", a, b, result, ~(a | b));

        // Test default case
        a = 32'hFFFFFFFF; b = 32'h00000000; func = 4'b1111;
        #10;
        $display("DEFAULT: a = %h, b = %h, result = %h, expected = %h", a, b, result, 32'h0);

        $finish;
    end

endmodule