#!/bin/sh
# gta6-clipper-01 clip pipeline.
#
# Input : ../gta6-clipper-01-footage/trailer2.mp4 (GTA 6 Trailer 2, official
#         Rockstar trailer, fetched with yt-dlp in the build session).
# Output: out/gta6-clip-01.mp4 — vertical 9:16 Short, 1080x1920, < 60 s.
#
# Shape of the clip:
#   part 1 — the hook: the trailer's best action moment, full-bleed.
#   part 2 — the pitch: the same footage dimmed under on-screen text
#            telling the viewer they can earn money on make.fun by making
#            clips with AI, with the bounty page on screen.
#
# The render commands below are the ones run in the build session (see the
# session transcript); this file records them so the cut is reproducible.
# Times are filled in once the moment is picked from the footage.

set -eu
SRC="${SRC:-../gta6-clipper-01-footage/trailer2.mp4}"
OUT="${OUT:-out/gta6-clip-01.mp4}"
mkdir -p out

# --- moment selection (filled in after watching the trailer) -------------
# HOOK_START / HOOK_END: the action beat that opens the clip.
# PITCH_START / PITCH_END: the tail of the moment the pitch plays over.
HOOK_START="00:00:00"
HOOK_END="00:00:25"
PITCH_START="00:00:25"
PITCH_END="00:00:38"

# --- cut -------------------------------------------------------------------
# 1. Trim the hook, crop to vertical 9:16 with a blurred fill so nothing
#    important falls off the sides, scale to 1080x1920, 30 fps.
# 2. Trim the pitch tail the same way, dim it, and lay the pitch text over
#    it with drawtext (two lines, safe area, clear of YouTube's buttons).
# 3. Concatenate, encode H.264 + AAC, faststart for upload.

echo "clip.sh: times not set yet — edit HOOK_START/HOOK_END/PITCH_START/PITCH_END first"
exit 1
