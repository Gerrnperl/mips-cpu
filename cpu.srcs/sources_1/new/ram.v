`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: HFUT
// Engineer: Lu Jipeng, 2022217492 
// 
// Create Date: 2024/10/24 02:51:05
// Design Name: 
// Module Name: ram
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

// (* x_core_info = "blk_mem_gen_v8_4_3,Vivado 2019.1" *)
// module blk_mem_gen_0(clka, ena, wea, addra, dina, douta)
// /* synthesis syn_black_box black_box_pad_pin="clka,ena,wea[3:0],addra[11:0],dina[31:0],douta[31:0]" */;
//   input clka; // ʱ��
//   input ena; // ʹ��
//   input [3:0]wea; // дʹ��
//   input [11:0]addra; // ��ַ
//   input [31:0]dina;  // ��������
//   output [31:0]douta;    // �������
// endmodule

// module: InstRAM
// ����洢��
// 32λ��4096����ַ
// ����ʹ�ܺ�����һ����������ɶ�д
module InstRAM (
    input wire clk,
    input wire reset,
    input wire re,
    input wire [3:0] we,
    input wire [11:0] addr,
    input wire [31:0] din,
    output wire [31:0] dout
);

  reg en;

  // �趨
  always @(negedge clk or negedge reset) begin
    if (!reset) begin
      en <= 0;
    end else begin
      // ��дʹ��
      if (we || re) begin
        en <= 1;
      end else begin
        en <= 0;
      end
    end
  end

  blk_mem_gen_0 uut (
      .clka (clk),
      .ena  (en),
      .wea  (we),
      .addra(addr),
      .dina (din),
      .douta(dout)
  );

endmodule


// module: DataRAM
// ���ݴ洢��
// 32λ��4096����ַ
// ����ʹ�ܺ�����һ����������ɶ�д
module DataRAM (
    input wire clk,
    input wire reset,
    input wire re,
    input wire [3:0] we,
    input wire [11:0] addr,
    input wire [31:0] din,
    output wire [31:0] dout
);

  reg en;

  // �趨
  always @(negedge clk or negedge reset) begin
    if (!reset) begin
      en <= 0;
    end else begin
      // ��дʹ��
      if (we || re) begin
        en <= 1;
      end else begin
        en <= 0;
      end
    end
  end

  blk_mem_gen_1 uut (
      .clka (clk),
      .ena  (en),
      .wea  (we),
      .addra(addr),
      .dina (din),
      .douta(dout)
  );

endmodule