`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: HFUT
// Engineer: Lu Jipeng, 2022217492 
// 
// Create Date: 2024/10/23 20:35:44
// Design Name: 
// Module Name: ALU
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
// Reference:
//  1. [ALU Control - CS2100](https://www.comp.nus.edu.sg/~adi-yoga/CS2100/ch08c2/)
// 
//////////////////////////////////////////////////////////////////////////////////

// module: ALU
// ALUcontrol	Function
// 0000     	and
// 0001     	or
// 0010     	add
// 0110     	sub
// 0111     	slt
// 1100     	nor
module ALU (
    input wire [31:0] a,
    input wire [31:0] b,
    input wire [3:0] func,
    output reg zero,
    output reg [31:0] result
);

  always @(*) begin
    case (func)
      4'b0000: begin
        result <= a & b;
      end
      4'b0001: begin
        result <= a | b;
      end
      4'b0010: begin
        result <= a + b;
      end
      4'b0110: begin
        result <= a - b;
      end
      4'b0111: begin
        result <= (a < b) ? 32'b1 : 32'b0;
      end
      4'b1100: begin
        result <= ~(a | b);
      end
      default: begin
        result <= 32'b0;
      end
    endcase
  end
endmodule
