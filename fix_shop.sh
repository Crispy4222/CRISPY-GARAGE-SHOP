#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail

BASE="$HOME/shop/crispy-shop-pwa"
DOCS="$BASE/docs"
SCRIPTS="$DOCS/scripts"
REPO="https://github.com/Crispy4222/CRISPY-GARAGE-SHOP.git"
SITE="https://crispy4222.github.io/CRISPY-GARAGE-SHOP"
CLEAN_URL="$SITE/scripts/termux-clean.sh"
PASS_URL="$SITE/scripts/storage-pass.sh"

echo "[i] Starting CRISPY shop fixer"
[ -d "$DOCS" ] || { echo "[!] $DOCS not found. Did you unzip to ~/shop/crispy-shop-pwa ?"; exit 1; }

mkdir -p "$SCRIPTS"
cd "$BASE"

# --- ensure scripts are executable (canonical source lives in docs/scripts/) ---
for _s in termux-clean.sh storage-pass.sh; do
  [ -f "$SCRIPTS/$_s" ] || { echo "[!] Missing $SCRIPTS/$_s — is the repo fully checked out?"; exit 1; }
  chmod +x "$SCRIPTS/$_s"
done

# --- enable raw serving on Pages ---
touch "$DOCS/.nojekyll"

# --- patch index.html idempotently ---
INDEX="$DOCS/index.html"
[ -f "$INDEX" ] || { echo "[!] $INDEX missing"; exit 1; }

# 1) Ensure proper doctype at top
if ! head -n1 "$INDEX" | grep -qi '^<!doctype html>'; then
  sed -i '1i <!doctype html>' "$INDEX"
  echo "[i] Added <!doctype html>"
fi

# 2) Add highlight.js before </head> if missing
if ! grep -q 'highlight.min.js' "$INDEX"; then
  sed -i '/<\/head>/i \  <link rel="stylesheet" href="https:\/\/cdnjs.cloudflare.com\/ajax\/libs\/highlight.js\/11.9.0\/styles\/atom-one-dark.min.css">\n  <script src="https:\/\/cdnjs.cloudflare.com\/ajax\/libs\/highlight.js\/11.9.0\/highlight.min.js"><\/script>\n  <script>window.addEventListener('\''DOMContentLoaded'\'',()=>{document.querySelectorAll('\''pre code'\'').forEach(el=>hljs.highlightElement(el));});<\/script>' "$INDEX"
  echo "[i] Injected highlight.js"
fi

# 3) Make all noopener → noopener noreferrer
sed -i 's/rel="noopener"/rel="noopener noreferrer"/g' "$INDEX"

# 4) Fix footer line to clean tribute text (replace any © line inside <footer>)
if grep -q '<footer>' "$INDEX"; then
  awk '
    BEGIN{fixed=0}
    /<footer>/{infoot=1}
    infoot==1 && /<p>.*©/ && fixed==0 {
      print "    <p>© <span id=\"yr\"></span> CRISPYcreations — Be good or be good at it. You can’t see it coming, but you can be ready for it. (HJ tribute. Rest easy, soldier 🪖🍺🎖️🇺🇸🪦🚬)</p>";
      fixed=1; next
    }
    /<\/footer>/{infoot=0}
    {print}
  ' "$INDEX" > "$INDEX.tmp" && mv "$INDEX.tmp" "$INDEX"
  echo "[i] Footer standardized"
fi

# 5) Ensure second code block for storage-pass under the termux-clean line
if ! grep -q 'storage-pass.sh' "$INDEX"; then
  # insert right after the first occurrence of the clean one-liner block
  sed -i "/$CLEAN_URL/ a \        <pre><code>curl -fsSL $PASS_URL | bash</code></pre>" "$INDEX" || true
  # fallback insert near the cleanup section if URL not yet present
  grep -q 'termux-clean.sh' "$INDEX" || sed -i "/CRISPY Scripts/s/.*/&\\n      <div class=\"code\">\\n        <pre><code>curl -fsSL $CLEAN_URL | bash<\/code><\/pre>\\n        <pre><code>curl -fsSL $PASS_URL | bash<\/code><\/pre>\\n      <\/div>/" "$INDEX"
  echo "[i] Added storage-pass one-liner"
fi

# --- commit + push ---
cd "$BASE"
git add docs
git commit -m "shop: scripts + .nojekyll + highlight.js + footer + second one-liner" || echo "[i] Nothing to commit"
# ensure remote set
if ! git remote -v | grep -q "$REPO"; then
  git remote add origin "$REPO" || true
fi
git branch -M main || true
git push -u origin main

# --- verify endpoints (may take a minute to publish) ---
echo "[i] HEAD checks:"
for u in "$CLEAN_URL" "$PASS_URL"; do
  echo -n "  - $u : "
  curl -I -s "$u" | head -n1 || echo "no response"
done

echo "[✓] Done. Visit $SITE"
