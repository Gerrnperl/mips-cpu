`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: HFUT
// Engineer: Lu Jipeng, 2022217492
// 
// Create Date: 2024/10/25 21:10:19
// Design Name: 
// Module Name: control
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

// | id | ָ�� | op | func | jump | branch | aluSrcA | aluSrcB | memRead | memWrite | memToReg | regWrite | regDst | aluOp | aluCtrl | ���� |
// | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
// | 1 | add | 000000 | 100000 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 1 | 0010 | 0000 | �� |
// | 2 | sub | 000000 | 100001 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 1 | 0010 | 0001 | �� |
// | 3 | and | 000000 | 100010 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 1 | 0010 | 0010 | �� |
// | 4 | or | 000000 | 100011 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 1 | 0010 | 0011 | �� |
// | 5 | xor | 000000 | 100100 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 1 | 0010 | 0100 | ��� |
// | 6 | sll | 000000 | 000101 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 1 | 1 | 0010 | 0101 | rt����shamt |
// | 7 | srl | 000000 | 000110 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 1 | 1 | 0010 | 0110 | rt�߼�����shamt |
// | 8 | sra | 000000 | 000111 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 1 | 1 | 0010 | 0111 | rt��������shamt |
// | 9 | mul | 000000 | 101000 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 1 | 0010 | 1000 | �� |
// | 10 | mulh | 000000 | 101001 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 1 | 0010 | 1001 | ��32λ(a \* b), a��b�����з�����չ |
// | 11 | div | 000000 | 101010 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 1 | 0010 | 1010 | �� |
// | 12 | rem | 000000 | 101011 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 1 | 0010 | 1011 | �� |
// | 13 | slt | 000000 | 101100 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 1 | 0010 | 1100 | rd = rs &lt; rt ? 1 : 0 |
// | 14 | sltu | 000000 | 101101 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 1 | 0010 | 1101 | �޷���rd = rs &lt; rt ? 1 : 0 |
// | 15 | nor | 000000 | 101110 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 1 | 0010 | 1110 | ��� |
// | 16 | jr | 000000 | 001111 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0010 | 1111 | PC = rs |
// | 17 | addi | 001000 | 000000 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 1 | 0 | 0000 | 0000 | �� |
// | 18 | subi | 001001 | 000000 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 1 | 0 | 0001 | 0001 | �� |
// | 19 | andi | 001100 | 000000 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 1 | 0 | 1000 | 0010 | �� |
// | 20 | ori | 001101 | 000000 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 1 | 0 | 1001 | 0011 | �� |
// | 21 | xori | 001110 | 000000 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 1 | 0 | 1010 | 0100 | ��� |
// | 22 | lui | 001111 | 000000 | 0 | 0 | 1 | 1 | 0 | 0 | 0 | 1 | 0 | 1011 | 0101 | rt = s\_imm &lt;&lt; 16 |
// | 23 | lw | 100011 | 000000 | 0 | 0 | 0 | 1 | 1 | 0 | 1 | 1 | 0 | 0000 | 0000 | load rt = [rs + s\_imm] |
// | 24 | sw | 101011 | 000000 | 0 | 0 | 0 | 1 | 0 | 1 | X | 0 | X | 0000 | 0000 | store [rs + s\_imm] = rt |
// | 25 | beq | 000100 | 000000 | 0 | 1 | 0 | 0 | 0 | 0 | X | 0 | X | 0001 | 0001 | rs = rt ʱ PC += 4+s\_imm &lt;&lt; 2 |
// | 26 | bne | 000101 | 000000 | 0 | 1 | 0 | 0 | 0 | 0 | X | 0 | X | 0001 | 0001 | rs != rt ʱ PC += 4+s\_imm &lt;&lt; 2 |
// | 27 | slti | 001010 | 000000 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 1 | 0 | 1100 | 1100 | rt = rs &lt; s\_imm ? 1 : 0 |
// | 28 | sltiu | 001011 | 000000 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 1 | 0 | 1101 | 1101 | rt = rs &lt; z\_imm ? 1 : 0 |
// | 29 | jr | 000010 | 000000 | 1 | X | X | X | X | X | X | X | X | 1111 | 1111 | PC = (PC+4)[31..28), addr, 0,0 |
// | 30 | jal | 000011 | 000000 | 1 | X | X | X | X | X | X | X | X | 1111 | 1111 | R31=PC; PC = (PC+4)[31..28), addr, 0,0 |
// | �ź� | ���ܶ��� | ��ֵ0ʱ���� | ��ֵ1ʱ���� |
// | --- | --- | --- | --- |
// | Jump | Jָ��Ŀ���ַѡ�� | ��Branch������� | ѡ��JĿ���ַ |
// | Branch | Bָ��Ŀ���ַѡ�� | ѡ��PC+4��ַ | ѡ��ת�Ƶ�ַ PC = (PC+4) + Imm \* 4 |
// | aluSrcA | ALU�˿�A����ѡ�� | ѡ��Ĵ���rs���� | ѡ�� shamt |
// | aluSrcB | ALU�˿�B����ѡ�� | ѡ��Ĵ���rt���� | ѡ��32λ������<font class="font6">(������չ��)</font> |
// | MemRead | �洢�������� | ��ֹ�洢���� | ʹ�ܴ洢���� |
// | MemWrite | �洢��д���� | ��ֹ�洢��д | ʹ�ܴ洢��д |
// | MemtoReg | �Ĵ���д������ѡ�� | ѡ��ALU��� | ѡ��洢������ |
// | RegWrite | �Ĵ���д���� | ��ֹ�Ĵ���д | ʹ�ܼĴ���д |
// | RegDst | �Ĵ���д��ַѡ�� | ѡ��ָ��rt�� | ѡ��ָ��rd�� |
// | ALU\_Control | 4λALU�������� |  |  |

//module: LRController ���ӼĴ���д�����
// Ϊ jal ָ��ʱ���� lrWrite ��Ϊ 1
module LRController (
    input wire [5:0] opcode,
    output wire lrWrite
);

  assign lrWrite = (opcode == 6'b000011) ? 1 : 0;

endmodule

//module: LUIController LUIָ���
// Ϊ lui ָ��ʱ���� shamtImm16 ��Ϊ 1
module LUIController (
    input wire [5:0] opcode,
    output wire shamtImm16
);
    
    assign shamtImm16 = (opcode == 6'b001111) ? 1 : 0;
    
endmodule

module PCSelect (
    input wire [31:0] pcPlus4,
    input wire [31:0] pcBranch,
    input wire [31:0] pcJump,
    // condition
    input wire [5:0] opcode,
    input wire jump,
    input wire branch,
    // ALU Flags
    input wire zero,
    input wire negative,
    input wire carry,
    input wire overflow,
    output reg [31:0] pcNext
);


  always @(*) begin
    if (jump) begin  // J-type instructions
      pcNext = pcJump;
    end else if (branch) begin  // Jump Ϊ 0 ʱ��PC �� Branch ����
      case (opcode)
        6'b000100: begin  // beq
          if (zero) begin
            pcNext = pcBranch;
          end else begin
            pcNext = pcPlus4;
          end
        end
        6'b000101: begin  // bne
          if (~zero) begin
            pcNext = pcBranch;
          end else begin
            pcNext = pcPlus4;
          end
        end
        default: begin
          pcNext = pcPlus4;
        end
      endcase
    end else begin
      pcNext = pcPlus4;
    end
  end

endmodule

module MainInstDecode (
    input wire [31:0] instruction,
    output reg jump,
    output reg branch,
    output reg aluSrcA,
    output reg aluSrcB,
    output reg memRead,
    output reg memWrite,
    output reg memToReg,
    output reg regWrite,
    output reg regDst,
    output reg [3:0] aluOp
);

  wire [5:0] opcode;
  wire [5:0] func;

  assign opcode = instruction[31:26];
  assign func   = instruction[5:0];

  always @(*) begin
    case (opcode)
      6'b000000: begin  // R-type instructions
        if (func == 6'b001111) begin  // jr
          jump = 1;
          branch = 0;
          aluSrcB = 0;
          memRead = 0;
          memWrite = 0;
          memToReg = 0;
          regWrite = 0;
          regDst = 0;
          aluOp = 4'b0010;
        end else begin
          jump = 0;
          branch = 0;
          aluSrcB = 0;
          memRead = 0;
          memWrite = 0;
          memToReg = 0;
          regWrite = 1;
          regDst = 1;
          aluOp = 4'b0010;
        end

        case (func)
            6'b000101: aluSrcA = 1;  // sll
            6'b000110: aluSrcA = 1;  // srl
            6'b000111: aluSrcA = 1;  // sra
            default:  aluSrcA = 0;
        endcase
      end
      6'b001000: begin  // addi
        jump = 0;
        branch = 0;
        aluSrcA = 0;
        aluSrcB = 1;
        memRead = 0;
        memWrite = 0;
        memToReg = 0;
        regWrite = 1;
        regDst = 0;
        aluOp = 4'b0000;
      end
      6'b001001: begin  // subi
        jump = 0;
        branch = 0;
        aluSrcA = 0;
        aluSrcB = 1;
        memRead = 0;
        memWrite = 0;
        memToReg = 0;
        regWrite = 1;
        regDst = 0;
        aluOp = 4'b0001;
      end
      6'b001100: begin  // andi
        jump = 0;
        branch = 0;
        aluSrcA = 0;
        aluSrcB = 1;
        memRead = 0;
        memWrite = 0;
        memToReg = 0;
        regWrite = 1;
        regDst = 0;
        aluOp = 4'b1000;
      end
      6'b001101: begin  // ori
        jump = 0;
        branch = 0;
        aluSrcA = 0;
        aluSrcB = 1;
        memRead = 0;
        memWrite = 0;
        memToReg = 0;
        regWrite = 1;
        regDst = 0;
        aluOp = 4'b1001;
      end
      6'b001110: begin  // xori
        jump = 0;
        branch = 0;
        aluSrcA = 0;
        aluSrcB = 1;
        memRead = 0;
        memWrite = 0;
        memToReg = 0;
        regWrite = 1;
        regDst = 0;
        aluOp = 4'b1010;
      end
      6'b001111: begin  // lui
        jump = 0;
        branch = 0;
        aluSrcA = 1;
        aluSrcB = 1;
        memRead = 0;
        memWrite = 0;
        memToReg = 0;
        regWrite = 1;
        regDst = 0;
        aluOp = 4'b1011;
      end
      6'b100011: begin  // lw
        jump = 0;
        branch = 0;
        aluSrcA = 0;
        aluSrcB = 1;
        memRead = 1;
        memWrite = 0;
        memToReg = 1;
        regWrite = 1;
        regDst = 0;
        aluOp = 4'b0000;
      end
      6'b101011: begin  // sw
        jump = 0;
        branch = 0;
        aluSrcA = 0;
        aluSrcB = 1;
        memRead = 0;
        memWrite = 1;
        memToReg = 0;
        regWrite = 0;
        regDst = 0;
        aluOp = 4'b0000;
      end
      6'b000100: begin  // beq
        jump = 0;
        branch = 1;
        aluSrcA = 0;
        aluSrcB = 0;
        memRead = 0;
        memWrite = 0;
        memToReg = 0;
        regWrite = 0;
        regDst = 0;
        aluOp = 4'b0001;
      end
      6'b000101: begin  // bne
        jump = 0;
        branch = 1;
        aluSrcA = 0;
        aluSrcB = 0;
        memRead = 0;
        memWrite = 0;
        memToReg = 0;
        regWrite = 0;
        regDst = 0;
        aluOp = 4'b0001;
      end
      6'b000010: begin  // jr
        jump = 1;
        branch = 0;
        aluSrcA = 0;
        aluSrcB = 0;
        memRead = 0;
        memWrite = 0;
        memToReg = 0;
        regWrite = 0;
        regDst = 0;
        aluOp = 4'b1111;
      end
      6'b000011: begin  // jal
        jump = 1;
        branch = 0;
        aluSrcA = 0;
        aluSrcB = 0;
        memRead = 0;
        memWrite = 0;
        memToReg = 0;
        regWrite = 0;
        regDst = 0;
        aluOp = 4'b1111;
      end
      default: begin
        jump = 0;
        branch = 0;
        aluSrcA = 0;
        aluSrcB = 0;
        memRead = 0;
        memWrite = 0;
        memToReg = 0;
        regWrite = 0;
        regDst = 0;
        aluOp = 4'b0000;
      end
    endcase
  end

endmodule

module ALUDecode (
    input  wire [5:0] func,
    input  wire [3:0] aluOp,
    output reg  [3:0] aluControl
);

  always @(*) begin
    case (aluOp)
      4'b0010: begin  // R-type instructions
        case (func)
          6'b100000: aluControl = 4'b0000;  // add
          6'b100001: aluControl = 4'b0001;  // sub
          6'b100010: aluControl = 4'b0010;  // and
          6'b100011: aluControl = 4'b0011;  // or
          6'b100100: aluControl = 4'b0100;  // xor
          6'b000101: aluControl = 4'b0101;  // sll
          6'b000110: aluControl = 4'b0110;  // srl
          6'b000111: aluControl = 4'b0111;  // sra
          6'b101000: aluControl = 4'b1000;  // mul
          6'b101001: aluControl = 4'b1001;  // mulh
          6'b101010: aluControl = 4'b1010;  // div
          6'b101011: aluControl = 4'b1011;  // rem
          6'b101100: aluControl = 4'b1100;  // slt
          6'b101101: aluControl = 4'b1101;  // sltu
          6'b101110: aluControl = 4'b1110;  // nor
          6'b001111: aluControl = 4'b1111;  // jr
          default:   aluControl = 4'bxxxx;  // undefined
        endcase
      end
      4'b0000: aluControl = 4'b0000;  // addi, lw, sw
      4'b0001: aluControl = 4'b0001;  // subi, beq, bne
      4'b1000: aluControl = 4'b0010;  // andi
      4'b1001: aluControl = 4'b0011;  // ori
      4'b1010: aluControl = 4'b0100;  // xori
      4'b1011: aluControl = 4'b0101;  // lui
      4'b1100: aluControl = 4'b1100;  // slti
      4'b1101: aluControl = 4'b1101;  // sltiu
      4'b1111: aluControl = 4'b1111;  // j-type instructions. ALU is not used
      default: aluControl = 4'bxxxx;  // undefined
    endcase
  end

endmodule

module Controller (
    input wire [31:0] instruction,
    output wire jump,
    output wire branch,
    output wire aluSrcA,
    output wire aluSrcB,
    output wire memRead,
    output wire memWrite,
    output wire memToReg,
    output wire regWrite,
    output wire regDst,
    output wire [3:0] aluControl
);

  wire [3:0] aluOp;

  MainInstDecode mainInstDecode (
      .instruction(instruction),
      .jump(jump),
      .branch(branch),
      .aluSrcA(aluSrcA),
      .aluSrcB(aluSrcB),
      .memRead(memRead),
      .memWrite(memWrite),
      .memToReg(memToReg),
      .regWrite(regWrite),
      .regDst(regDst),
      .aluOp(aluOp)
  );

  ALUDecode aluDecode (
      .func(instruction[5:0]),
      .aluOp(aluOp),
      .aluControl(aluControl)
  );

endmodule
