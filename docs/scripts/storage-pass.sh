#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail
SDCARD_PATH="/sdcard"
echo "[Storage Pass] Largest items in Downloads:"
du -ah "$SDCARD_PATH/Download" 2>/dev/null | sort -hr | head -n 25
echo
if [ -d "$SDCARD_PATH/DCIM/.thumbnails" ]; then
  thumbnailsDirSize=$(du -sh "$SDCARD_PATH/DCIM/.thumbnails" | awk '{print $1}')
  echo "[Thumbnails] $thumbnailsDirSize → clearing files (safe)…"
  rm -f "$SDCARD_PATH/DCIM/.thumbnails/"* 2>/dev/null || true
else
  echo "[Thumbnails] none found."
fi
echo "[Storage Pass] done."
