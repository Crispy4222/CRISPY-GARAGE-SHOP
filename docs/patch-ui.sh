#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

# 1. Add copy button JS (once)
grep -q 'copyCode' index.html || sed -i '/<\/body>/i \
<script> \
function copyCode(btn){ \
  const pre = btn.previousElementSibling; \
  if (!pre) return; \
  navigator.clipboard.writeText(pre.innerText).then(()=>{ \
    btn.innerText="✓ Copied"; setTimeout(()=>btn.innerText="Copy",2000); \
  }); \
} \
</script>' index.html

# 2. Replace CTA buttons text
sed -i 's/class="btn buy"[^>]*>Tip \([^<]*\)<\/a>/class="btn buy" href="https:\/\/cash.app\/$CASH_TAG" target="_blank" rel="noopener noreferrer">💵 Support \1<\/a>/g' index.html
sed -i 's/class="btn dl"[^>]*>Download[^<]*/class="btn dl" href="&" download>🟩 Get Pack (Free)/g' index.html

# 3. Wrap code blocks with copy button
sed -i 's#<div class="code">#<div class="code"> <button onclick="copyCode(this)">Copy<\/button>#g' index.html

git add index.html
git commit -m "UX: clearer buttons + copy button"
git push
