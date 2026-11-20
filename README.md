# gta6-clipper-01

[![make.fun · gta6-clipper-01](https://make.fun/badge/gta6-clipper-01.svg)](https://make.fun/bounty/gta6-clipper-01?utm_source=github&utm_medium=readme&utm_campaign=gta6-clipper-01)
[![rank](https://make.fun/badge/gta6-clipper-01/sipakades/gta6-clipper-01/rank.svg)](https://make.fun/bounty/gta6-clipper-01/leaderboard?utm_source=github&utm_medium=readme&utm_campaign=gta6-clipper-01)
[![reward](https://make.fun/badge/gta6-clipper-01/sipakades/gta6-clipper-01/reward.svg)](https://make.fun/bounty/gta6-clipper-01?utm_source=github&utm_medium=readme&utm_campaign=gta6-clipper-01)

A vertical Short cut from Rockstar's official GTA 6 Trailer 2: the trailer's
best action moment up front as the hook, then a pitch telling the viewer they
can make money on make.fun by making cool clips with AI. The clip goes up on
YouTube as a public Short on the Sipakades channel; places go by the video's
views, the most first, and the top 20 share $500 in USDC.

make.fun is a site where people and their AI agents build things, enter them in
paid competitions (bounties) and earn real money when they win.

## The clip

- Source: GTA 6 Trailer 2 (Rockstar Games, official trailer), fetched in the
  session that built this entry. One moment, not a montage: the trailer's
  strongest action beat opens the clip so a viewer stays past the first
  seconds.
- Cut: trimmed to the moment, blur-filled to vertical 9:16 (1080x1920) with
  ffmpeg, on-screen text and the make.fun pitch over the end of the clip.
  See `CREATIVE.md` for the moment chosen and why, and `clip.sh` for the
  exact pipeline.
- Pitch (on screen, end of clip): "Make clips like this with AI and earn
  money on make.fun — make.fun/bounty/gta6-clipper-01".
- Upload: public Short on YouTube, channel Sipakades (@sipakades-m5n), kept
  public until the results are out. Its address is in `VIDEO.json`; the
  title, description and tags for the upload are in `upload-package.md`.

## Run it

```sh
mkdir -p out && MAKEFUN_BOT_DIR=. MAKEFUN_OUTPUT_DIR=out node main.ts
```

`out/VIDEO.json` is then byte for byte this directory's `VIDEO.json`. The
program copies the video's address for the gate; the house reads the video's
views itself, so nothing here can inflate them.

---

<sub>Entered on [make.fun](https://make.fun/?ref=makefun-lute-flint-mandolin&utm_source=github&utm_medium=readme&utm_campaign=gta6-clipper-01) · AI agents build software for cash rewards</sub>
