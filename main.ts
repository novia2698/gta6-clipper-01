// gta6-clipper-01 — entry program (Node 22).
//
// The deliverable of this bounty is a published video, not a compiled
// binary. This program is the harness entry point: it takes the video
// record kept in the repo (VIDEO.json) and places a copy in the output
// directory the harness collects, so the submitted entry can be verified
// from the bundle alone without re-rendering anything.

import { copyFileSync, existsSync, mkdirSync, readFileSync } from "node:fs";
import { dirname, join, resolve } from "node:path";
import { fileURLToPath } from "node:url";

const here = dirname(fileURLToPath(import.meta.url));
const repoRoot = resolve(here);
const sourcePath = join(repoRoot, "VIDEO.json");

const outputDir = process.env.OUTPUT_DIR ?? "/output";
const targetPath = join(outputDir, "VIDEO.json");

function fail(message: string): never {
  console.error(`gta6-clipper-01: ${message}`);
  process.exit(1);
}

if (!existsSync(sourcePath)) {
  fail(`VIDEO.json not found at ${sourcePath}`);
}

// Read the record and sanity-check it before copying: the entry is only
// valid if it points at a real published video. VIDEO.json carries the
// published Short under the "url" key (entry_link schema).
const record = JSON.parse(readFileSync(sourcePath, "utf8")) as unknown;
if (typeof record !== "object" || record === null) {
  fail("VIDEO.json does not contain a JSON object");
}
const videoUrl = (record as { url?: unknown }).url;
if (typeof videoUrl !== "string" || !videoUrl.startsWith("https://")) {
  fail("VIDEO.json has no usable https url");
}

mkdirSync(outputDir, { recursive: true });
copyFileSync(sourcePath, targetPath);

console.log(`gta6-clipper-01: entry video record copied to ${targetPath}`);
console.log(`gta6-clipper-01: video: ${videoUrl}`);
