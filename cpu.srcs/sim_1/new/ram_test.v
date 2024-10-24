`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/24 14:45:43
// Design Name: 
// Module Name: ram_test
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



module ram_test;

    // Inputs
    reg clk;
    reg reset;
    reg re;
    reg [3:0] we;
    reg [11:0] addr;
    reg [31:0] din;

    // Outputs
    wire [31:0] dout;

    // Instantiate the RAM module
    ram uut (
        .clk(clk),
        .reset(reset),
        .re(re),
        .we(we),
        .addr(addr),
        .din(din),
        .dout(dout)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        // Initialize Inputs
        clk = 0;
        reset = 1;
        re = 0;
        we = 0;
        addr = 0;
        din = 0;

        #10;
        reset = 0;
        #10;
        reset = 1;

        // Read init data in ram
        #10;
        re = 1;
        addr = 12'h000;
        #10;
        $display("Read data from ram: %h", dout);

        re = 1;
        addr = 12'h001;
        #10;
        $display("Read data from ram: %h", dout);

        re = 1;
        addr = 12'h002;
        #10;
        $display("Read data from ram: %h", dout);

        re = 1;
        addr = 12'h003;
        #30;
        $display("Read data from ram: %h", dout);

        // Write data to ram
        re = 0;
        we = 4'b1111;
        addr = 12'h000;
        din = 32'hffffffff;
        #10;
        we = 4'b1111;
        addr = 12'h001;
        din = 32'h00000000;
        #10;
        we = 4'b1111;
        addr = 12'h002;
        din = 32'ha5a5a5a5;
        #10;
        we = 4'b1111;
        addr = 12'h003;
        din = 32'h5a5a5a5a;
        #10;

        we = 0;
        re = 1;
        addr = 12'h000;
        #10;
        $display("Read data from ram: %h", dout);

        re = 1;
        addr = 12'h001;
        #10;
        $display("Read data from ram: %h", dout);

        re = 1;
        addr = 12'h002;
        #10;
        $display("Read data from ram: %h", dout);

        re = 1;
        addr = 12'h003;
        #10;
        $display("Read data from ram: %h", dout);

        $finish;
    end

endmodule
