#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail
SD="/sdcard"
echo "[Storage Pass] Largest items in Downloads:"
du -ah "$SD/Download" 2>/dev/null | sort -hr | head -n 25
echo
if [ -d "$SD/DCIM/.thumbnails" ]; then
  size=$(du -sh "$SD/DCIM/.thumbnails" | awk '{print $1}')
  echo "[Thumbnails] $size → clearing files (safe)…"
  rm -f "$SD/DCIM/.thumbnails/"* 2>/dev/null || true
else
  echo "[Thumbnails] none found."
fi
echo "[Storage Pass] done."
