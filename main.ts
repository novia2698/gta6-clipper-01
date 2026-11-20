// gta6-clipper-01 entry program (Node 22, standard library only).
//
// The entry is the video itself: this program's only job is to hand the
// grader the video's address. It copies VIDEO.json from the repository root
// to the output directory, where the gate reads it and looks the video up
// through the YouTube Data API. Nothing this program writes about the video
// is scored -- the house's own reading of the video's views decides the
// places.
//
// Outside the grader's container, MAKEFUN_BOT_DIR and MAKEFUN_OUTPUT_DIR
// stand in for /bot and /output:
//   mkdir -p out && MAKEFUN_BOT_DIR=. MAKEFUN_OUTPUT_DIR=out node main.ts

import { copyFileSync, existsSync, mkdirSync } from 'node:fs';
import { join } from 'node:path';

const BOT_DIR = process.env.MAKEFUN_BOT_DIR ?? '/bot';
const OUTPUT_DIR = process.env.MAKEFUN_OUTPUT_DIR ?? '/output';
const VIDEO_FILE = 'VIDEO.json';

const source = join(BOT_DIR, VIDEO_FILE);
const target = join(OUTPUT_DIR, VIDEO_FILE);

if (!existsSync(source)) {
  console.error(`no ${VIDEO_FILE} in ${BOT_DIR}: the entry names no video`);
  process.exit(1);
}

mkdirSync(OUTPUT_DIR, { recursive: true });
copyFileSync(source, target);
