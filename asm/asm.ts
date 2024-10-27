interface Line {
	text: string;
	srcLine: number;
}

interface Instruction {
	op: string;
	args: string[];
	codeLine: number;
	srcLine: number;
}

export interface AssembleResult {
	binary: number[];
	symbolTable: Map<string, number>;
	codeLines: string[];
}

/**
 * Assembler for this mips cpu
 */
export class Assembler {
	private symbolTable: Map<string, number> = new Map();

	/**
	 * Assemble the given code
	 * @param code The code to assemble
	 */
	public assemble(code: string): AssembleResult | null {
		const lines = code.split('\n');
		const preprocessed = this.preprocess(lines);
		let failed = false;
		const binary = preprocessed.map((line, codeLineNum) => {
			try {
				return this.assembleLine(line, codeLineNum);
			} catch (e: any) {
				console.error(`\x1b[31mError at line ${line!.srcLine + 1}: ${e.message}\x1b[0m`);
				console.error(`${line!.srcLine + 1}: ${lines[line!.srcLine]}`);
				failed = true;
			}
		});
		if (failed) {
			console.error('\x1b[31mAssembly failed\x1b[0m');
			return null;
		}
		return {
			binary: binary as number[],
			symbolTable: this.symbolTable,
			codeLines: preprocessed.map(line => line.text)
		}
	}

	/**
	 * Preprocess the code
	 * remove comments, record labels, etc
	 * @param code 
	 */
	private preprocess(lines: string[]): Line[] {
		let lineNum = 0;
		return lines.map((line, srcLineNum) => {
			// remove comments
			line = line.split('#')[0];

			// remove whitespace
			line = line.trim();

			if (line.length === 0) {
				return null;
			}

			// /^[a-zA-Z_][a-zA-Z0-9_]*:/
			// get label, record, remove label
			let labelMatch = line.match(/^[a-zA-Z_][a-zA-Z0-9_]*:/);
			if (labelMatch) {
				let label = labelMatch[0].slice(0, -1);
				this.symbolTable.set(label, lineNum);
				line = line.slice(label.length + 1).trim();
			}

			if (line.length === 0) { // the line was just a label
				return null;
			}

			lineNum++;
			return { text: line, srcLine: srcLineNum };
		}).filter(line => line !== null);
	}

	private assembleLine(line: Line, codeLineNum: number) {
		const parts = line.text.split(' ');
		const op = parts[0];
		const args = parts.slice(1).join(' ').split(',').map(arg => arg.trim());
		if (!this.parsers[op]) {
			throw new Error(`Unknown operation: ${op}`);
		}
		return this.parsers[op].parse({
			op,
			args,
			codeLine: codeLineNum,
			srcLine: line.srcLine
		}, this.symbolTable);
	}

	parsers: {
		[key: string]: InstParser
	} = {
		'add'	: new RTypeInstParser(0b100000),
		'sub'	: new RTypeInstParser(0b100001),
		'and'	: new RTypeInstParser(0b100010),
		'or' 	: new RTypeInstParser(0b100011),
		'xor'	: new RTypeInstParser(0b100100),
		'sll'	: new ShamtInstParser(0b000101),
		'srl'	: new ShamtInstParser(0b000110),
		'sra'	: new ShamtInstParser(0b000111),
		'mul'	: new RTypeInstParser(0b101000),
		'mulh'	: new RTypeInstParser(0b101001),
		'div'	: new RTypeInstParser(0b101010),
		'rem'	: new RTypeInstParser(0b101011),
		'slt'	: new RTypeInstParser(0b101100),
		'sltu'	: new RTypeInstParser(0b101101),
		'nor'	: new RTypeInstParser(0b101110),
		'jr'	: new RTypeInstParser(0b001111),
		'addi'	: new ITypeInstParser(0b001000),
		'subi'	: new ITypeInstParser(0b001001),
		'andi'	: new ITypeInstParser(0b001100),
		'ori'	: new ITypeInstParser(0b001101),
		'xori'	: new ITypeInstParser(0b001110),
		'lui'	: new LUIInstParser(0b001111),
		'lw'	: new MemAccessInstParser(0b100011),
		'sw'	: new MemAccessInstParser(0b101011),
		'beq'	: new BTypeInstParser(0b000100),
		'bne'	: new BTypeInstParser(0b000101),
		'slti'	: new ITypeInstParser(0b001010),
		'sltiu'	: new ITypeInstParser(0b001011),
		'j'		: new JTypeInstParser(0b000010),
		'jal'	: new JTypeInstParser(0b000011),
	}

}

interface InstParser {
	parse(inst: Instruction, symbolTable: Map<string, number>): number;
}

function registerToNum(reg: string): number {
	if (!reg.startsWith('$')) {
		throw new Error('Invalid register name');
	}
	return parseInt(reg.slice(1));
}

function parseImm(imm: string, symbolTable: Map<string, number>): number {
	if (imm.startsWith('$')) {
		return registerToNum(imm);
	}
	if (imm.startsWith('0x')) {
		return parseInt(imm.slice(2), 16);
	}
	if (imm.startsWith('0b')) {
		return parseInt(imm.slice(2), 2);
	}
	if (imm.startsWith('0')) {
		return parseInt(imm, 8);
	}
	if (imm.match(/^-?\d+$/)) {
		return parseInt(imm);
	}
	if (symbolTable.has(imm)) {
		return symbolTable.get(imm)!;
	}
	throw new Error('Invalid immediate value');
}

class RTypeInstParser implements InstParser {
	protected opcode: number = 0b000000;
	protected funct: number;
	
	constructor(funct: number) {
		this.funct = funct;
	}
	parse({ op, args, srcLine }: Instruction, symbolTable: Map<string, number>): number {
		// op rd, rs, rt
		// =>
		// op[31:26] rs[25:21] rt[20:16] rd[15:11] shamt[10:6] funct[5:0]
		if (args.length !== 3) {
			throw new Error(`Invalid number of arguments for ${op} at line ${srcLine}`);
		}
		let result = this.opcode << 26;
		result |= registerToNum(args[1]) << 21;
		result |= registerToNum(args[2]) << 16;
		result |= registerToNum(args[0]) << 11;
		result |= this.funct;
		return result;
	}
}

class ShamtInstParser extends RTypeInstParser {
	constructor(funct: number) {
		super(funct);
	}
	parse({ op, args, srcLine }: Instruction,symbolTable: Map<string, number>): number {
		// op rd, rt, shamt
		// =>
		// op[31:26] 0[25:21] rt[20:16] rd[15:11] shamt[10:6] funct[5:0]
		if (args.length !== 3) {
			throw new Error(`Invalid number of arguments for ${op} at line ${srcLine}`);
		}
		let result = this.opcode << 26;
		result |= registerToNum(args[1]) << 16;
		result |= registerToNum(args[0]) << 11;
		result |= (parseImm(args[2], symbolTable) & 0x1f) << 6;
		result |= this.funct;
		return result;
	}
}


class ITypeInstParser implements InstParser {
	private opcode: number;
	constructor(opcode: number) {
		this.opcode = opcode;
	}
	parse({ op, args, srcLine }: Instruction,symbolTable: Map<string, number>): number {
		// op rt, rs, imm
		// =>
		// op[31:26] rs[25:21] rt[20:16] imm[15:0]
		if (args.length !== 3) {
			throw new Error(`Invalid number of arguments for ${op} at line ${srcLine}`);
		}
		let result = this.opcode << 26;
		result |= registerToNum(args[1]) << 21;
		result |= registerToNum(args[0]) << 16;
		result |= parseImm(args[2], symbolTable) & 0xffff;
		return result;
	}
}

class BTypeInstParser implements InstParser {
	private opcode: number;
	constructor(opcode: number) {
		this.opcode = opcode;
	}
	parse({ op, args, srcLine, codeLine }: Instruction,symbolTable: Map<string, number>): number {
		// b** rs, rt, imm
		// =>
		// b**[31:26] rs[25:21] rt[20:16] imm[15:0]
		if (args.length !== 3) {
			throw new Error(`Invalid number of arguments for ${op} at line ${srcLine}`);
		}
		let result = this.opcode << 26;
		result |= registerToNum(args[0]) << 21;
		result |= registerToNum(args[1]) << 16;
		result |= (parseImm(args[2], symbolTable) - codeLine - 1) & 0xffff;
		return result;
	}
}

class LUIInstParser implements InstParser {
	private opcode: number;
	constructor(opcode: number) {
		this.opcode = opcode;
	}

	parse({ op, args, srcLine }: Instruction,symbolTable: Map<string, number>): number {
		// lui rt, imm
		// =>
		// op[31:26] 0[25:21] rt[20:16] imm[15:0]
		if (args.length !== 2) {
			throw new Error(`Invalid number of arguments for ${op} at line ${srcLine}`);
		}
		let result = this.opcode << 26;
		result |= registerToNum(args[0]) << 16;
		result |= parseImm(args[1], symbolTable) & 0xffff;
		return result;
	}
}

class MemAccessInstParser implements InstParser {
	private opcode: number;
	constructor(opcode: number) {
		this.opcode = opcode;
	}

	parse({ op, args, srcLine }: Instruction,symbolTable: Map<string, number>): number {
		// lw/sw rt, imm(rs)
		// =>
		// op[31:26] rs[25:21] rt[20:16] imm[15:0]
		if (args.length !== 2) {
			throw new Error(`Invalid number of arguments for ${op} at line ${srcLine}`);
		}
		let result = this.opcode << 26;
		let rt = args[0];
		let imm = args[1].split('(')[0];
		let rs = args[1].split('(')[1].slice(0, -1);
		result |= registerToNum(rs) << 21;
		result |= registerToNum(rt) << 16;
		result |= parseImm(imm, symbolTable) & 0xffff;
		return result;
	}
}

class JTypeInstParser implements InstParser {
	private opcode: number;
	constructor(opcode: number) {
		this.opcode = opcode;
	}

	parse({ op, args, srcLine }: Instruction,symbolTable: Map<string, number>): number {
		// j/jal target
		// =>
		// op[31:26] target[25:0]
		if (args.length !== 1) {
			throw new Error(`Invalid number of arguments for ${op} at line ${srcLine}`);
		}
		let result = this.opcode << 26;
		result |= parseImm(args[0], symbolTable) & 0x3ffffff;
		return result;
	}
}