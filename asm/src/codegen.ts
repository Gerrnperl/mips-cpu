import { AssembleResult } from "./asm.js";

export function coe({ binary: result }: AssembleResult) {
	return (
		'memory_initialization_radix=16;\n' +
		'memory_initialization_vector=\n' +
		result.map(int32ToHex8).join(",\n")
	);
}

export function bin({ binary: result }: AssembleResult) {
	const buf = Buffer.alloc(result.length * 4);
	for (let i = 0; i < result.length; i++) {
		buf.writeInt32BE(result[i], i * 4);
	}
	return buf;
}

export function readable(result: AssembleResult) {
	// LineNum: HexCode		Assembly
	// NextLineNum: Label:
	const { binary, codeLines, symbolTable } = result;
	const symbolTableReversed = new Map<number, string>();
	symbolTable.forEach((value, key) => {
		symbolTableReversed.set(value, key);
	});
	const lines: string[] = [];
	let lineNum = 0;
	for (let i = 0; i < binary.length; i++) {
		const line = codeLines[i];
		const label = symbolTableReversed.get(i);
		if (label) {
			console.log(`\x1b[36m${int32ToHex8(lineNum << 2)}:\x1b[0m \x1b[32m${label}:\x1b[0m`);
			lines.push(`${int32ToHex8(lineNum << 2)}: ${label}:`);
		}
		const binaryLine = toReadableBinary(binary[i]);
		console.log(`\x1b[36m${int32ToHex8(lineNum << 2)}:\x1b[0m \x1b[33m${int32ToHex8(binary[i])}\x1b[0m  \x1b[34m${binaryLine}\x1b[0m  ${line}`);
		lines.push(
			`${int32ToHex8(lineNum << 2)}: ${int32ToHex8(binary[i])}  ${binaryLine}  ${line}`
		);
		lineNum += line.split("\n").length;
	}
	return lines.join("\n");
}

function toReadableBinary(binary: number): string {
	const opcode = ((binary >>> 26) & 0x3f).toString(2).padStart(6, "0");
	const rs = ((binary >>> 21) & 0x1f).toString(2).padStart(5, "0");
	const rt = ((binary >>> 16) & 0x1f).toString(2).padStart(5, "0");
	const rd = ((binary >>> 11) & 0x1f).toString(2).padStart(5, "0");
	const shamt = ((binary >>> 6) & 0x1f).toString(2).padStart(5, "0");
	const funct =( binary & 0x3f).toString(2).padStart(6, "0");
	return `${opcode} ${rs} ${rt} ${rd} ${shamt} ${funct}`;
}

function int32ToHex8(n: number): string {
	return (n >>> 0).toString(16).padStart(8, "0");
}