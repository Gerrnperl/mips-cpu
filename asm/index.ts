import * as fs from "fs";
import { Assembler } from "./asm.js";
import { bin, coe, readable } from "./codegen.js";

const filename = process.argv[2];
if (!filename) {
	console.error("Usage: pnpm exec ts-node --esm ./index.js <filename> [<output.bin>] [<output.coe>] [<output.txt>]");
	process.exit(1);
}

const outputs = process.argv.slice(3);

if (outputs.length === 0) {
	console.error("No output specified");
}

(async () => {
	const code = await fs.promises.readFile(filename, "utf-8");
	const asm = new Assembler();
	const result = asm.assemble(code);
	if (!result) {
		process.exit(1);
	}
	const readableOutput = readable(result);
	outputs.forEach(output => {
		if (output.endsWith(".bin")) {
			fs.writeFileSync(output, bin(result));
		} else if (output.endsWith(".coe")) {
			fs.writeFileSync(output, coe(result));
		} else if (output.endsWith(".txt")) {
			fs.writeFileSync(output, readableOutput);
		}
	});
}
)();
