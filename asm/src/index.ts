import * as fs from "fs";
import { Assembler } from "./asm.js";
import { bin, coe, readable } from "./codegen.js";

const thisFile = process.argv[1];
const filename = process.argv[2];
const usage = thisFile.endsWith(".ts") ?
    "Usage: ts-node --esm " + thisFile + " <filename> [<output.bin>] [<output.coe>] [<output.txt>]" :
	"Usage: node " + thisFile + " <filename> [<output.bin>] [<output.coe>] [<output.txt>]";

if (!filename) {
	console.error(usage);
	process.exit(1);
}

const outputs = process.argv.slice(3);

if (outputs.length === 0) {
	console.error(usage);
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
