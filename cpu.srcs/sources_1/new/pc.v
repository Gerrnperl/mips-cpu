`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/26 14:52:09
// Design Name: 
// Module Name: pc
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


module PC(
        input wire clk,
        input wire reset,
        input wire [31:0] pc_in,
        output reg [31:0] pc_out
    );

    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            pc_out <= 32'b0;
        end else begin
            pc_out <= pc_in;
        end
    end

endmodule
