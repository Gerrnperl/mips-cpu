import * as fs from "fs";
import { Assembler } from "./asm.js";

const filename = process.argv[2];
if (!filename) {
	console.error("Usage: pnpm exec ts-node --esm ./index.js <filename>");
	process.exit(1);
}

(async () => {
	const code = await fs.promises.readFile(filename, "utf-8");
	const asm = new Assembler();
	const binary = asm.assemble(code);
	console.log(binary?.map(int32ToHex8).join("\n"));
}
)();

function int32ToHex8(n: number): string {
	return (n >>> 0).toString(16).padStart(8, "0");
}

function int32ToBin32(n: number): string {
	return (n >>> 0).toString(2).padStart(32, "0").split(/(.{4})/).filter(Boolean).join(" ");
}