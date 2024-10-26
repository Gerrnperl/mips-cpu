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

// module: Regfiles 32个32位寄存器堆
module Regfiles (
    input clk,  //寄存器组时钟信号，下降沿写入数据
    input reset,
    input we,  //寄存器读写有效信号,低电平时允许寄存器写入数据，高电平时允许寄存器读出数据
    input [4:0] raddr1,  //所需读取的寄存器的地址
    input [4:0] raddr2,  //所需读取的寄存器的地址
    input [4:0] waddr,  //写寄存器的地址
    input [31:0] wdata,  //写寄存器数据,数据在clk下降沿时被写入
    output [31:0] rdata1,  //raddr1所对应寄存器的输出数据
    output [31:0] rdata2  //raddr2所对应寄存器的输出数据
);

  // 32个寄存器的使能信号
  wire [31:0] reg_enb;
  // 32个寄存器的输出数据
  wire [31:0] rdata[31:0];

  // 译码器，将写地址转换为32个寄存器的使能信号
  Decode5_32 u_decode (
      .inp(waddr),
      .enb(we),
      .out(reg_enb)
  );

  // 实例化32个寄存器
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

  // 16选1选择器，选择读取的寄存器的数据
  // 选择器在we为高电平时激活
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

//module: Regfile 单个32位寄存器
module Regfile (
    input clk,  //寄存器时钟信号，下降沿写入数据
    input reset,  //异步复位信号,高电平时寄存器置零
    input we,  //寄存器读写有效信号,低电平时允许寄存器写入数据，高电平时允许寄存器读出数据
    input [31:0] wdata,  //写寄存器数据,数据在clk上升沿时被写入
    output [31:0] rdata  //raddr所对应寄存器的输出数据
);

  reg [31:0] register;

  assign rdata = register;

  initial begin
    register = 32'b0;
  end

  // 写入数据 及 复位
  always @(posedge clk or negedge reset) begin
    if (!reset) begin
      register <= 32'b0;
    end else if (!we) begin
      register <= wdata;
    end
  end

endmodule

