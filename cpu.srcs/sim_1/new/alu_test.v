`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: HFUT
// Engineer: Lu Jipeng, 2022217492 
// 
// Create Date: 2024/10/23 21:20:26
// Design Name: 
// Module Name: alu_test
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

module ALU_Test;

  // Inputs
  reg [31:0] a;
  reg [31:0] b;
  reg [3:0] func;

  // Outputs
  wire negative;
  wire zero;
  wire carry;
  wire overflow;
  wire [31:0] result;

  // Instantiate the ALU
  ALU uut (
      .a(a),
      .b(b),
      .func(func),
      .negative(negative),
      .zero(zero),
      .carry(carry),
      .overflow(overflow),
      .result(result)
  );

  integer failed = 0;

  initial begin
    // Test Signed Add operation
    $display("Test Signed Add operation");
    // Test case 1 - Add
    a = 32'h00000001;
    b = 32'h00000002;
    func = 4'b0000;
    #10;
    if (result !== 32'h00000003 || carry !== 1'b0 || overflow !== 1'b0) begin
      failed = failed + 1;
      $display("Test case 1 failed");
    end
    // Test case 2 - Add with carry and overflow
    a = 32'h80000000;
    b = 32'h80000000;
    func = 4'b0000;
    #10;
    if (result !== 32'h00000000 || carry !== 1'b1 || overflow !== 1'b1) begin
      failed = failed + 1;
      $display("Test case 2 failed");
    end
    // Test case 3 - Add with overflow
    a = 32'h7FFFFFFF;
    b = 32'h00000001;
    func = 4'b0000;
    #10;
    if (result !== 32'h80000000 || carry !== 1'b0 || overflow !== 1'b1) begin
      failed = failed + 1;
      $display("Test case 3 failed");
    end
    // Test case 4 - Add with carry
    a = 32'hC0000000;
    b = 32'hC0000000;
    func = 4'b0000;
    #10;
    if (result !== 32'h80000000 || carry !== 1'b1 || overflow !== 1'b0) begin
      failed = failed + 1;
      $display("Test case 4 failed");
    end


    // Test Signed Sub operation
    $display("Test Signed Sub operation");
    // Test case 1 - Sub
    a = 32'h00000003;
    b = 32'h00000001;
    func = 4'b0001;
    #10;
    if (result !== 32'h00000002 || carry !== 1'b0 || overflow !== 1'b0) begin
      failed = failed + 1;
      $display("Test case 1 failed");
    end
    // Test case 2 - Sub with carry
    a = 32'h00000001;
    b = 32'h00000002;
    func = 4'b0001;
    #10;
    if (result !== 32'hFFFFFFFF || carry !== 1'b1 || overflow !== 1'b0) begin
      failed = failed + 1;
      $display("Test case 2 failed");
    end
    // Test case 3 - Sub with overflow
    a = 32'h80000000;
    b = 32'h00000001;
    func = 4'b0001;
    #10;
    if (result !== 32'h7FFFFFFF || carry !== 1'b0 || overflow !== 1'b1) begin
      failed = failed + 1;
      $display("Test case 3 failed");
    end
    // Test case 4 - Sub with carry and overflow
    a = 32'h7FFFFFFF;
    b = 32'hFFFFFFFF;
    func = 4'b0001;
    #10;
    if (result !== 32'h80000000 || carry !== 1'b1 || overflow !== 1'b1) begin
      failed = failed + 1;
      $display("Test case 4 failed");
    end

    // Test AND operation
    $display("Test AND operation");
    // Test case 1 - AND
    a = 32'hFFFFFFFF;
    b = 32'h00000000;
    func = 4'b0010;
    #10;
    if (result !== 32'h00000000) begin
      failed = failed + 1;
      $display("Test case 1 failed");
    end
    // Test case 2 - AND
    a = 32'hAAAAAAAA;
    b = 32'h55555555;
    func = 4'b0010;
    #10;
    if (result !== 32'h00000000) begin
      failed = failed + 1;
      $display("Test case 2 failed");
    end

    // Test OR operation
    $display("Test OR operation");
    // Test case 1 - OR
    a = 32'hAAAAAAAA;
    b = 32'h55555555;
    func = 4'b0011;
    #10;
    if (result !== 32'hFFFFFFFF) begin
      failed = failed + 1;
      $display("Test case 1 failed");
    end
    // Test case 2 - OR
    a = 32'h00000000;
    b = 32'h00000000;
    func = 4'b0011;
    #10;
    if (result !== 32'h00000000) begin
      failed = failed + 1;
      $display("Test case 2 failed");
    end

    // Test XOR operation
    $display("Test XOR operation");
    // Test case 1 - XOR
    a = 32'hAAAAAAAA;
    b = 32'h55555555;
    func = 4'b0100;
    #10;
    if (result !== 32'hFFFFFFFF) begin
      failed = failed + 1;
      $display("Test case 1 failed");
    end
    // Test case 2 - XOR
    a = 32'hFFFFFFFF;
    b = 32'hFFFFFFFF;
    func = 4'b0100;
    #10;
    if (result !== 32'h00000000) begin
      failed = failed + 1;
      $display("Test case 2 failed");
    end

    // Test Shift Left operation
    $display("Test Shift Left operation");
    // Test case 1 - Shift Left
    b = 32'h00000001;
    a = 32'h00000001;
    func = 4'b0101;
    #10;
    if (result !== 32'h00000002) begin
      failed = failed + 1;
      $display("Test case 1 failed");
    end
    // Test case 2 - Shift Left with carry
    b = 32'h80000000;
    a = 32'h00000001;
    func = 4'b0101;
    #10;
    if (result !== 32'h00000000 || carry !== 1'b1) begin
      failed = failed + 1;
      $display("Test case 2 failed");
    end

    // Test Shift Right operation
    $display("Test Shift Right operation");
    // Test case 1 - Shift Right
    b = 32'h00000002;
    a = 32'h00000001;
    func = 4'b0110;
    #10;
    if (result !== 32'h00000001) begin
      failed = failed + 1;
      $display("Test case 1 failed");
    end
    // Test case 2 - Shift Right with carry
    b = 32'h00000001;
    a = 32'h00000001;
    func = 4'b0110;
    #10;
    if (result !== 32'h00000000 || carry !== 1'b1) begin
      failed = failed + 1;
      $display("Test case 2 failed");
    end

    // Test Arithmetic Shift Right operation
    $display("Test Arithmetic Shift Right operation");
    // Test case 1 - Arithmetic Shift Right
    b = 32'h80000000;
    a = 32'h00000001;
    func = 4'b0111;
    #10;
    if (result !== 32'hC0000000) begin
      failed = failed + 1;
      $display("Test case 1 failed");
    end
    // Test case 2 - Arithmetic Shift Right
    b = 32'h00000001;
    a = 32'h00000001;
    func = 4'b0111;
    #10;
    if (result !== 32'h00000000) begin
      failed = failed + 1;
      $display("Test case 2 failed");
    end

    // Test Multiplication operation
    $display("Test Multiplication operation");
    // Test case 1 - Multiplication
    a = 32'h00000002;
    b = 32'h00000003;
    func = 4'b1000;
    #10;
    if (result !== 32'h00000006) begin
      failed = failed + 1;
      $display("Test case 1 failed");
    end
    // Test case 2 - Multiplication with overflow
    a = 32'hFFFFFFFF;
    b = 32'hFFFFFFFF;
    func = 4'b1000;
    #10;
    if (result !== 32'h00000001) begin
      failed = failed + 1;
      $display("Test case 2 failed");
    end

    // Test Multiplication High operation
    $display("Test Multiplication High operation");
    // Test case 1 - Multiplication High
    a = 32'h00000002;
    b = 32'h00000003;
    func = 4'b1001;
    #10;
    if (result !== 32'h00000000) begin
      failed = failed + 1;
      $display("Test case 1 failed");
    end
    // Test case 2 - Multiplication High with positive operands
    a = 32'h0FFFFFFF;
    b = 32'h0FFFFFFF;
    func = 4'b1001;
    #10;
    if (result !== 32'h00FFFFFF) begin
      failed = failed + 1;
      $display("Test case 2 failed");
    end

    // Test case 3 - Multiplication High with negative operands
    a = 32'h80000000;
    b = 32'h80000000;
    func = 4'b1001;
    #10;
    if (result !== 32'h40000000) begin
      failed = failed + 1;
      $display("Test case 3 failed");
    end

    // Test Division operation
    $display("Test Division operation");
    // Test case 1 - Division
    a = 32'h00000006;
    b = 32'h00000003;
    func = 4'b1010;
    #10;
    if (result !== 32'h00000002) begin
      failed = failed + 1;
      $display("Test case 1 failed");
    end
    // Test case 2 - Division by zero
    a = 32'h00000006;
    b = 32'h00000000;
    func = 4'b1010;
    #10;
    if (result !== 32'hXXXXXXXX) begin
      failed = failed + 1;
      $display("Test case 2 failed");
    end

    // Test Remainder operation
    $display("Test Remainder operation");
    // Test case 1 - Remainder
    a = 32'h00000007;
    b = 32'h00000003;
    func = 4'b1011;
    #10;
    if (result !== 32'h00000001) begin
      failed = failed + 1;
      $display("Test case 1 failed");
    end
    // Test case 2 - Remainder by zero
    a = 32'h00000007;
    b = 32'h00000000;
    func = 4'b1011;
    #10;
    if (result !== 32'hXXXXXXXX) begin
      failed = failed + 1;
      $display("Test case 2 failed");
    end

    // Test Set Less Than operation
    $display("Test Set Less Than operation");
    // Test case 1 - Set Less Than
    a = 32'h00000001;
    b = 32'h00000002;
    func = 4'b1100;
    #10;
    if (result !== 32'h00000001) begin
      failed = failed + 1;
      $display("Test case 1 failed");
    end
    // Test case 2 - Set Less Than
    a = 32'h00000002;
    b = 32'h00000001;
    func = 4'b1100;
    #10;
    if (result !== 32'h00000000) begin
      failed = failed + 1;
      $display("Test case 2 failed");
    end
    // Test case 3 - Set Less Than with negative operands
    a = 32'h80000000;
    b = 32'h00000000;
    func = 4'b1100;
    #10;
    if (result !== 32'h00000001) begin
      failed = failed + 1;
      $display("Test case 3 failed");
    end    

    // Test Set Less Than Unsigned operation
    $display("Test Set Less Than Unsigned operation");
    // Test case 1 - Set Less Than Unsigned
    a = 32'h00000001;
    b = 32'h00000002;
    func = 4'b1101;
    #10;
    if (result !== 32'h00000001) begin
      failed = failed + 1;
      $display("Test case 1 failed");
    end
    // Test case 2 - Set Less Than Unsigned
    a = 32'h00000002;
    b = 32'h00000001;
    func = 4'b1101;
    #10;
    if (result !== 32'h00000000) begin
      failed = failed + 1;
      $display("Test case 2 failed");
    end
    // Test case 3 - Set Less Than Unsigned with negative operands
    a = 32'h80000000;
    b = 32'h00000000;
    func = 4'b1101;
    #10;
    if (result !== 32'h00000000) begin
      failed = failed + 1;
      $display("Test case 3 failed");
    end

    // Test NOR operation
    $display("Test NOR operation");
    // Test case 1 - NOR
    a = 32'hAAAAAAAA;
    b = 32'h55555555;
    func = 4'b1110;
    #10;
    if (result !== 32'h00000000) begin
      failed = failed + 1;
      $display("Test case 1 failed");
    end
    // Test case 2 - NOR
    a = 32'hFFFFFFFF;
    b = 32'h00000000;
    func = 4'b1110;
    #10;
    if (result !== 32'h00000000) begin
      failed = failed + 1;
      $display("Test case 2 failed");
    end
    // Test case 3 - Use as not
    a = 32'h5A5A5A5A;
    b = 32'h5A5A5A5A;
    func = 4'b1110;
    #10;
    if (result !== 32'hA5A5A5A5) begin
      failed = failed + 1;
      $display("Test case 3 failed");
    end

    if (failed === 0) begin
      $display("All tests passed");
    end else begin
      $display("Failed %d tests", failed);
    end

    $finish;
  end

endmodule
