#!/usr/bin/env bash
# gta6-clipper-01 — build the 20-second vertical clip from the GTA 6 trailer.
#
# Takes one moment from the official trailer (2:20-2:32, a chase run),
# reframes it for vertical Shorts (1080x1920, 9:16), burns the make.fun
# pitch onto the picture as on-screen text, and grabs a thumbnail frame.
# The clip this script produces was already rendered and published; this
# file documents and reproduces the exact pipeline.
set -euo pipefail

# --- inputs / outputs -------------------------------------------------------
TRAILER="${1:-trailer.mp4}"          # local copy of the GTA 6 trailer
OUT_DIR="${2:-out}"
CLIP="$OUT_DIR/gta6-clip-01.mp4"
THUMB="$OUT_DIR/thumbnail.png"

# Moment picked from the trailer (seconds).
START=140                            # 2:20
DURATION=20                          # 2:20 -> 2:32
THUMB_AT=141                         # 2:21, one second into the chase

# Vertical Shorts frame.
W=1080
H=1920

mkdir -p "$OUT_DIR"
[ -f "$TRAILER" ] || { echo "trailer not found: $TRAILER" >&2; exit 1; }
command -v ffmpeg >/dev/null || { echo "ffmpeg not found" >&2; exit 1; }

# --- render -----------------------------------------------------------------
# Two layers: a blurred, stretched copy fills the whole vertical frame,
# and a sharp copy sits centered on top at full width. Text lines fade in
# over the chase: the hook first, then the pitch, then the bounty link.
ffmpeg -y -ss "$START" -t "$DURATION" -i "$TRAILER" \
  -filter_complex "\
[0:v]scale=${W}:${H}:force_original_aspect_ratio=increase,crop=${W}:${H},gblur=sigma=28[bg]; \
[0:v]scale=${W}:-2[fg]; \
[bg][fg]overlay=(W-w)/2:(H-h)/2, \
drawtext=text='Make clips like this with AI':fontsize=64:fontcolor=white:borderw=3:bordercolor=black:x=(w-text_w)/2:y=h*0.62:enable='between(t,0,7)', \
drawtext=text='and earn money on make.fun':fontsize=56:fontcolor=white:borderw=3:bordercolor=black:x=(w-text_w)/2:y=h*0.68:enable='between(t,7,14)', \
drawtext=text='make.fun/bounty/gta6-clipper-01':fontsize=44:fontcolor=yellow:borderw=2:bordercolor=black:x=(w-text_w)/2:y=h*0.74:enable='between(t,14,20)'[v]" \
  -map "[v]" -map 0:a -c:v libx264 -preset medium -crf 20 -pix_fmt yuv420p \
  -c:a aac -b:a 128k -movflags +faststart -r 30 "$CLIP"

# --- thumbnail --------------------------------------------------------------
# A single frame from 2:21, cropped to the same vertical frame.
ffmpeg -y -ss "$THUMB_AT" -i "$TRAILER" -frames:v 1 \
  -vf "scale=${W}:${H}:force_original_aspect_ratio=increase,crop=${W}:${H}" \
  "$THUMB"

echo "clip:      $CLIP"
echo "thumbnail: $THUMB"
