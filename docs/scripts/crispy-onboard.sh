#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail

echo "[CRISPY Onboard] updating packages…"
yes | pkg update || true
pkg install -y curl jq termux-tools || true

# get the latest scripts locally too (so he can run offline)
mkdir -p "$HOME/bin"
curl -fsSL https://crispy4222.github.io/CRISPY-GARAGE-SHOP/scripts/termux-clean.sh -o "$HOME/bin/termux-clean.sh"
curl -fsSL https://crispy4222.github.io/CRISPY-GARAGE-SHOP/scripts/storage-pass.sh -o "$HOME/bin/storage-pass.sh"
chmod +x "$HOME/bin/"*.sh

# quality of life aliases (append once)
grep -q 'alias clean' "$HOME/.bashrc" 2>/dev/null || cat >> "$HOME/.bashrc" <<'RC'
alias clean='bash ~/bin/termux-clean.sh'
alias storage='bash ~/bin/storage-pass.sh'
RC

echo
echo "[CRISPY Onboard] Done."
echo "Try these now:"
echo "  clean    # safe cache cleanup"
echo "  storage  # list big files + clear thumbnails"
echo
echo "Tip: Long-press home screen → Widgets → add Termux shortcuts to run clean/storage with a tap (requires Termux:Widget)."
