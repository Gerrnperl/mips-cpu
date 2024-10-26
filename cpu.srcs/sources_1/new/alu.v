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
//
//////////////////////////////////////////////////////////////////////////////////

// module: ALU
// | ������ (func)  | ����             | ��� (result)                   | ��λ��־ (carry)  | �����־ (overflow) |
// |---------------|-----------------|--------------------------------|------------------|---------------------|
// | 0000          | signed add      | a + b                          | ��λΪ1           | ���Ϊ1              |
// | 0001          | signed sub      | a - b                          | ��λΪ1           | ���Ϊ1              |
// | 0010          | and             | a & b                          | 0                | 0                   |
// | 0011          | or              | a \| b                         | 0                | 0                   |
// | 0100          | xor             | a ^ b                          | 0                | 0                   |
// | 0101          | shift left      | a << b[4:0]                    | �Ƴ�ֵ��ĩλ       | 0                   |
// | 0110          | shift right     | a >> b[4:0]                    | a[0]             | 0                   |
// | 0111          | arith shift right | a_signed >>> b[4:0]          | a[0]             | 0                   |
// | 1000          | mul             | a * b                          | 0                | 0                   |
// | 1009          | mulh            | ��32λ(a * b), a��b�����з�����չ  | 0                | 0                   |
// | 1010          | div             | a / b                          | 0                | 0                   |
// | 1011          | rem             | a % b                          | 0                | 0                   |
// | 1100          | slt             | (a_signed < b_signed) ? 1 : 0  | 0                | 0                   |
// | 1101          | sltu            | (a < b) ? 1 : 0                | 0                | 0                   |
// | 1110          | nor             | ~(a \| b)                      | 0                | 0                   |
// | default       | default         | 0                              | 0                | 0                   |
// * �Ӽ����޷������ʱ����λ��־Ϊ1
// * �Ӽ����з������ʱ�������־Ϊ1
// * ����־�жϲ����ǲ���������ʽ���������������result[31]Ϊ1ʱΪ1
// * ���־��resultΪ0ʱΪ1
module ALU (
    input wire [31:0] a,
    input wire [31:0] b,
    input wire [3:0] func,
    output reg negative,
    output reg zero,
    output reg carry,
    output reg overflow,
    output reg [31:0] result
);

  wire signed [31:0] a_signed;
  wire signed [31:0] b_signed;

  assign a_signed = a;
  assign b_signed = b;

  always @(*) begin
    carry <= 1'b0;
    overflow <= 1'b0;
    case (func)
      4'b0000: begin  // add
        {carry, result} <= a + b;
        overflow <= (a[31] & b[31] & ~result[31]) | (~a[31] & ~b[31] & result[31]);
      end
      4'b0001: begin  // sub
        {carry, result} <= a - b;
        overflow <= (a[31] & ~b[31] & ~result[31]) | (~a[31] & b[31] & result[31]);
      end

      4'b0010: begin  // and
        result <= a & b;
      end

      4'b0011: begin  // or
        result <= a | b;
      end

      4'b0100: begin  // xor
        result <= a ^ b;
      end

      4'b0101: begin  // shift left
        {carry, result} <= b << a[4:0];
      end

      4'b0110: begin  // shift right
        carry <= b[0];
        result <= b >> a[4:0];
      end

      4'b0111: begin  // arith shift right
        carry <= b[0];
        result <= b_signed >>> a[4:0];
      end

      4'b1000: begin  // mul
        result <= a * b;
      end
      4'b1001: begin  // mulh
        // ��չ��64λ���ˣ�ȡ��32λ
        result <= {{32{a[31]}}, a} * {{32{b[31]}}, b} >> 32;
      end

      4'b1010: begin  // div
        result <= a / b;
      end

      4'b1011: begin  // rem
        result <= a % b;
      end

      4'b1100: begin  // slt
        result <= (a_signed < b_signed) ? 32'b1 : 32'b0;
      end

      4'b1101: begin  // sltu
        result <= (a < b) ? 32'b1 : 32'b0;
      end

      4'b1110: begin  // nor
        result <= ~(a | b);
      end

      default: begin
        result <= 32'b0;
      end
    endcase
    negative = result[31];
    zero = (result == 32'b0);
  end
endmodule
