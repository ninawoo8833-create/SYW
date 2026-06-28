#!/usr/bin/env bash
# Center-crop an image to 3:4 (width:height) and save as lossless PNG.
# Usage: ./scripts/crop-cover.sh input.png assets/covers/cover-01.png

set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "Usage: $0 <input-image> <output.png>"
  exit 1
fi

input="$1"
output="$2"

w=$(sips -g pixelWidth "$input" | awk '/pixelWidth/ {print $2}')
h=$(sips -g pixelHeight "$input" | awk '/pixelHeight/ {print $2}')

if (( w * 4 > h * 3 )); then
  crop_w=$(( h * 3 / 4 ))
  crop_h=$h
else
  crop_w=$w
  crop_h=$(( w * 4 / 3 ))
fi

mkdir -p "$(dirname "$output")"
sips -c "$crop_h" "$crop_w" "$input" --out "$output" >/dev/null

ow=$(sips -g pixelWidth "$output" | awk '/pixelWidth/ {print $2}')
oh=$(sips -g pixelHeight "$output" | awk '/pixelHeight/ {print $2}')
echo "Saved ${output} (${ow}x${oh}, 3:4 PNG)"
