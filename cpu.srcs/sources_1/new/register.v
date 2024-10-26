`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: HFUT
// Engineer: Lu Jipeng, 2022217492 
// 
// Create Date: 2024/10/25 14:59:40
// Design Name: 
// Module Name: register
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

// module: Regfiles 32��32λ�Ĵ�����
module Regfiles (
    input clk,  //�Ĵ�����ʱ���źţ��½���д������
    input reset,
    input we,  //�Ĵ�����д��Ч�ź�,�͵�ƽʱ����Ĵ���д�����ݣ��ߵ�ƽʱ����Ĵ�����������
    input [4:0] raddr1,  //�����ȡ�ļĴ����ĵ�ַ
    input [4:0] raddr2,  //�����ȡ�ļĴ����ĵ�ַ
    input [4:0] waddr,  //д�Ĵ����ĵ�ַ
    input [31:0] wdata,  //д�Ĵ�������,������clk�½���ʱ��д��
    output [31:0] rdata1,  //raddr1����Ӧ�Ĵ������������
    output [31:0] rdata2  //raddr2����Ӧ�Ĵ������������
);

  // 32���Ĵ�����ʹ���ź�
  wire [31:0] reg_enb;
  // 32���Ĵ������������
  wire [31:0] rdata[31:0];

  // ����������д��ַת��Ϊ32���Ĵ�����ʹ���ź�
  Decode5_32 u_decode (
      .inp(waddr),
      .enb(we),
      .out(reg_enb)
  );

  // ʵ����32���Ĵ���
  genvar i;
  generate
    for (i = 0; i < 32; i = i + 1) begin : regfiles
      Regfile u_regfile (
          .clk(clk),
          .reset(reset),
          .we(~reg_enb[i]),
          .wdata(wdata),
          .rdata(rdata[i])
      );
    end
  endgenerate

  // 16ѡ1ѡ������ѡ���ȡ�ļĴ���������
  // ѡ������weΪ�ߵ�ƽʱ����
  wire not_we;
  assign not_we = ~we;
  Select32_1 u_select_0 (
    .inp0(rdata[0]),
    .inp1(rdata[1]),
    .inp2(rdata[2]),
    .inp3(rdata[3]),
    .inp4(rdata[4]),
    .inp5(rdata[5]),
    .inp6(rdata[6]),
    .inp7(rdata[7]),
    .inp8(rdata[8]),
    .inp9(rdata[9]),
    .inp10(rdata[10]),
    .inp11(rdata[11]),
    .inp12(rdata[12]),
    .inp13(rdata[13]),
    .inp14(rdata[14]),
    .inp15(rdata[15]),
    .inp16(rdata[16]),
    .inp17(rdata[17]),
    .inp18(rdata[18]),
    .inp19(rdata[19]),
    .inp20(rdata[20]),
    .inp21(rdata[21]),
    .inp22(rdata[22]),
    .inp23(rdata[23]),
    .inp24(rdata[24]),
    .inp25(rdata[25]),
    .inp26(rdata[26]),
    .inp27(rdata[27]),
    .inp28(rdata[28]),
    .inp29(rdata[29]),
    .inp30(rdata[30]),
    .inp31(rdata[31]),

    .sel(raddr1),
    .enb(not_we),
    .out(rdata1)
  );

  Select32_1 u_select_1 (
    .inp0(rdata[0]),
    .inp1(rdata[1]),
    .inp2(rdata[2]),
    .inp3(rdata[3]),
    .inp4(rdata[4]),
    .inp5(rdata[5]),
    .inp6(rdata[6]),
    .inp7(rdata[7]),
    .inp8(rdata[8]),
    .inp9(rdata[9]),
    .inp10(rdata[10]),
    .inp11(rdata[11]),
    .inp12(rdata[12]),
    .inp13(rdata[13]),
    .inp14(rdata[14]),
    .inp15(rdata[15]),
    .inp16(rdata[16]),
    .inp17(rdata[17]),
    .inp18(rdata[18]),
    .inp19(rdata[19]),
    .inp20(rdata[20]),
    .inp21(rdata[21]),
    .inp22(rdata[22]),
    .inp23(rdata[23]),
    .inp24(rdata[24]),
    .inp25(rdata[25]),
    .inp26(rdata[26]),
    .inp27(rdata[27]),
    .inp28(rdata[28]),
    .inp29(rdata[29]),
    .inp30(rdata[30]),
    .inp31(rdata[31]),

    .sel(raddr2),
    .enb(not_we),
    .out(rdata2)
  );

endmodule

//module: Regfile ����32λ�Ĵ���
module Regfile (
    input clk,  //�Ĵ���ʱ���źţ��½���д������
    input reset,  //�첽��λ�ź�,�ߵ�ƽʱ�Ĵ�������
    input we,  //�Ĵ�����д��Ч�ź�,�͵�ƽʱ����Ĵ���д�����ݣ��ߵ�ƽʱ����Ĵ�����������
    input [31:0] wdata,  //д�Ĵ�������,������clk������ʱ��д��
    output [31:0] rdata  //raddr����Ӧ�Ĵ������������
);

  reg [31:0] register;

  assign rdata = register;

  initial begin
    register = 32'b0;
  end

  // д������ �� ��λ
  always @(posedge clk or negedge reset) begin
    if (!reset) begin
      register <= 32'b0;
    end else if (!we) begin
      register <= wdata;
    end
  end

endmodule

