# GTA 6 Clipper — 20-Second Vertical Clip

[![make.fun bounty](https://img.shields.io/badge/make.fun-bounty-gta6--clipper--01-blue)](https://make.fun/bounty/gta6-clipper-01)

A 20-second vertical cut of the GTA 6 trailer, reframed for YouTube
Shorts and carrying a short on-screen pitch for make.fun: clips like
this can be made with AI, and making them can earn money on make.fun.

## Watch it

**Published Short:** https://www.youtube.com/shorts/aoH0Krhselg

- Channel: [@sipakades-m5n](https://www.youtube.com/@sipakades-m5n)
- Format: vertical 9:16, 1080x1920, 20 seconds
- Source moment: GTA 6 trailer, 2:20–2:32 (the chase run)

## What is in this repo

| File | What it is |
| --- | --- |
| `main.ts` | Entry program — copies `VIDEO.json` to `/output` for the harness |
| `VIDEO.json` | The published video record (URL, channel, format, play code) |
| `clip.sh` | The ffmpeg pipeline that built the clip and its thumbnail |
| `CREATIVE.md` | Why this moment, this hook, and this pitch |
| `upload-package.md` | Title, description, and play code used for the upload |
| `system-prompt.txt` | The builder brief for this bounty |
| `out/` | The rendered clip (`gta6-clip-01.mp4`) and thumbnail |

## How the clip was made

1. The trailer moment 2:20–2:32 was cut to exactly 20 seconds.
2. It was reframed to vertical 1080x1920 with a blurred fill behind the
   sharp picture, so nothing important is cropped out.
3. Three text lines were burned onto the picture in sequence:
   "Make clips like this with AI", "and earn money on make.fun", and
   "make.fun/bounty/gta6-clipper-01".
4. A thumbnail was pulled from the frame at 2:21.

The full pipeline is in `clip.sh`. Re-running it needs a local copy of
the trailer as `trailer.mp4` and ffmpeg:

```bash
./clip.sh trailer.mp4 out
```

## Play the entry

The fastest way is the Short link above. To verify the entry record
locally, run the entry program and check `/output/VIDEO.json`:

```bash
npx tsx main.ts
```

## Bounty

- Bounty: [gta6-clipper-01](https://make.fun/bounty/gta6-clipper-01) — $500 prize pool
- Play code: `makefun-lute-flint-mandolin`
