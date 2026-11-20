#!/bin/sh
# gta6-clipper-01 clip pipeline.
#
# Input : ../gta6-clipper-01-footage/trailer2.mp4 (GTA 6 Trailer 2, official
#         Rockstar trailer, fetched with yt-dlp in the build session:
#         yt-dlp -f "136+140" https://www.youtube.com/watch?v=VQRLujxTm3c
#         -> 1280x720, 166.8 s, 21 MB).
# Output: out/gta6-clip-01.mp4 — vertical 9:16 Short, 1080x1920, 20 s.
#
# The moment (picked after watching the trailer frame by frame, see
# CREATIVE.md): the trailer's climactic chase run, 2:20-2:32 — Jason on a
# motorcycle with a plane screaming low overhead, then the boat chase with
# a helicopter, ending on the dusk/sunset shots. One continuous stretch of
# the trailer, not a montage.
#
# Shape of the clip (20 s total, original trailer audio throughout):
#   part 1 — hook  : 2:20-2:27 (7 s) pure chase, no text.
#   part 1 — pitch : 2:27-2:32 (5 s) dusk tail, pitch lines 1-2 fade in.
#   part 2 — end card: 8 s slow zoom on the frozen 2:32 sunset frame
#            (Lucia + Jason in the car), all three pitch lines on screen.
#
# Vertical conversion: blur-filled 9:16 — the full 16:9 frame is scaled to
# 1080 wide over a blurred, cropped copy of itself, so nothing important
# falls off the sides. Pitch text is DejaVu Sans Bold, white on a
# semi-transparent black box, inside the vertical safe area.

set -eu
SRC="${SRC:-../gta6-clipper-01-footage/trailer2.mp4}"
OUT="${OUT:-out/gta6-clip-01.mp4}"
WORK="${WORK:-out/work}"
FONT="${FONT:-/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf}"
mkdir -p out "$WORK"

# --- moment selection (trailer timestamps, seconds) -----------------------
HOOK_START=140   # 2:20 — motorcycle + low plane
PITCH_START=147  # 2:27 — dusk tail begins, pitch lines come in
TAIL_END=152     # 2:32 — sunset couple frame (frozen for the end card)
ENDCARD_LEN=8    # seconds the frozen frame holds, slow zoom

# Vertical blur-fill: full frame over a blurred cover copy of itself.
VF_V="split[a][b];[a]scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,gblur=sigma=40[bg];[b]scale=1080:-2[fg];[bg][fg]overlay=(W-w)/2:(H-h)/2,format=yuv420p,fps=30"

# Pitch text (drawtext). In part 1 the clip clock runs 0-12 s; the pitch
# starts at t=7 (trailer 2:27). Line 1 at t=7, line 2 at t=9.5.
TXT1="Make clips like this with AI"
TXT2="and earn money on make.fun"
TXT3="make.fun/bounty/gta6-clipper-01"

# --- part 1: hook + pitch tail (trailer 2:20-2:32, 12 s) ------------------
ffmpeg -y -v error -ss "$HOOK_START" -t 12 -i "$SRC" \
  -vf "${VF_V},drawtext=fontfile=${FONT}:text='${TXT1}':fontsize=56:fontcolor=white:borderw=2:bordercolor=black@0.8:box=1:boxcolor=black@0.55:boxborderw=14:x=(w-text_w)/2:y=h*0.60:enable='between(t,7,12)',drawtext=fontfile=${FONT}:text='${TXT2}':fontsize=56:fontcolor=white:borderw=2:bordercolor=black@0.8:box=1:boxcolor=black@0.55:boxborderw=14:x=(w-text_w)/2:y=h*0.66:enable='between(t,9.5,12)'" \
  -c:v libx264 -crf 20 -preset medium -c:a aac -b:a 128k \
  -movflags +faststart "$WORK/part1.mp4"

# --- part 2: end card (frozen 2:32 frame, slow zoom, 8 s) -----------------
ffmpeg -y -v error -ss "$TAIL_END" -i "$SRC" -frames:v 1 "$WORK/freeze.png"
ffmpeg -y -v error -i "$WORK/freeze.png" \
  -vf "${VF_V}" -frames:v 1 "$WORK/freeze-v.png"
ffmpeg -y -v error -loop 1 -t "$ENDCARD_LEN" -i "$WORK/freeze-v.png" -ss "$TAIL_END" -t "$ENDCARD_LEN" -i "$SRC" \
  -vf "zoompan=z='min(1+0.0006*on,1.15)':d=240:s=1080x1920:fps=30,format=yuv420p,drawtext=fontfile=${FONT}:text='${TXT1}':fontsize=56:fontcolor=white:borderw=2:bordercolor=black@0.8:box=1:boxcolor=black@0.55:boxborderw=14:x=(w-text_w)/2:y=h*0.58,drawtext=fontfile=${FONT}:text='${TXT2}':fontsize=56:fontcolor=white:borderw=2:bordercolor=black@0.8:box=1:boxcolor=black@0.55:boxborderw=14:x=(w-text_w)/2:y=h*0.64,drawtext=fontfile=${FONT}:text='${TXT3}':fontsize=48:fontcolor=white:borderw=2:bordercolor=black@0.8:box=1:boxcolor=black@0.55:boxborderw=14:x=(w-text_w)/2:y=h*0.70" \
  -c:v libx264 -crf 20 -preset medium -c:a aac -b:a 128k -shortest \
  -movflags +faststart "$WORK/part2.mp4"

# --- join: 12 s + 8 s = 20 s ----------------------------------------------
printf "file '%s'\nfile '%s'\n" "$WORK/part1.mp4" "$WORK/part2.mp4" > "$WORK/concat.txt"
ffmpeg -y -v error -f concat -safe 0 -i "$WORK/concat.txt" -c copy -movflags +faststart "$OUT"

# --- thumbnail: the 2:21 motorcycle + plane frame, vertical ----------------
ffmpeg -y -v error -ss 141 -i "$SRC" -vf "${VF_V}" -frames:v 1 out/thumbnail.png

echo "wrote $OUT"
ffprobe -v error -show_entries format=duration,size -show_entries stream=codec_name,width,height -of default=noprint_wrappers=1 "$OUT"
