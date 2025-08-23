#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail
echo "[Termux Clean] starting"
pkg clean || true
apt-get autoremove -y || true
[ -d "$HOME/.cache" ] && find "$HOME/.cache" -type f -mtime +7 -print -delete
command -v pip >/dev/null && pip cache purge || true
command -v npm >/dev/null && npm cache clean --force || true
find "$HOME" -type f -name "*.log" -mtime +14 -print -delete 2>/dev/null || true
echo "[Termux Clean] done"
