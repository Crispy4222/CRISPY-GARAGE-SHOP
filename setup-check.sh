#!/usr/bin/env bash
# setup-check.sh — CRISPY Garage Shop self-test & diagnostic
# Run:  bash setup-check.sh
# Purpose: detect auth blocks, missing deps, broken paths, config gaps
#          and print plain-English fixes for every problem found.
set -euo pipefail

REPO_URL="https://github.com/Crispy4222/CRISPY-GARAGE-SHOP.git"
SITE_URL="https://crispy4222.github.io/CRISPY-GARAGE-SHOP"
SCRIPT_BASE="$SITE_URL/scripts"
DOCS_DIR="docs"

RED='\033[0;31m'; YEL='\033[1;33m'; GRN='\033[0;32m'; CYN='\033[0;36m'; RST='\033[0m'
PASS=0; WARN=0; FAIL=0

pass() { echo -e "${GRN}[✓]${RST} $1"; PASS=$((PASS+1)); }
warn() { echo -e "${YEL}[!]${RST} $1"; WARN=$((WARN+1)); }
fail() { echo -e "${RED}[✗]${RST} $1"; FAIL=$((FAIL+1)); }
info() { echo -e "${CYN}[i]${RST} $1"; }
fix()  { echo -e "    ${YEL}FIX →${RST} $1"; }

echo
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo " CRISPY Garage Shop — setup-check $(date '+%Y-%m-%d %H:%M')"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# ── 1. Core tool dependencies ────────────────────────
echo
info "Checking core dependencies…"
for cmd in git curl bash; do
  if command -v "$cmd" >/dev/null 2>&1; then
    pass "$cmd found: $(command -v "$cmd")"
  else
    fail "$cmd is missing."
    fix "Install $cmd — e.g. 'pkg install $cmd' (Termux) or 'apt install $cmd' (Debian/Ubuntu)."
  fi
done

for cmd in jq; do
  if command -v "$cmd" >/dev/null 2>&1; then
    pass "$cmd found"
  else
    warn "$cmd not found (needed only for build-catalog.sh)."
    fix "Install with: pkg install jq   OR   apt install jq"
  fi
done

# ── 2. Git identity ──────────────────────────────────
echo
info "Checking git identity…"
GIT_USER=$(git config --global user.name 2>/dev/null || echo "")
GIT_EMAIL=$(git config --global user.email 2>/dev/null || echo "")
if [ -n "$GIT_USER" ] && [ -n "$GIT_EMAIL" ]; then
  pass "git identity: $GIT_USER <$GIT_EMAIL>"
else
  fail "git user.name / user.email not set — commits will be anonymous and some hosts reject them."
  fix "Run: git config --global user.name 'Your Name'"
  fix "     git config --global user.email 'you@example.com'"
fi

# ── 3. Git remote / auth ─────────────────────────────
echo
info "Checking git remote & auth…"
if git -C . rev-parse --git-dir >/dev/null 2>&1; then
  REMOTE=$(git -C . remote get-url origin 2>/dev/null || echo "")
  if [ -n "$REMOTE" ]; then
    pass "origin remote: $REMOTE"
    # Detect HTTPS vs SSH
    if echo "$REMOTE" | grep -q "^https://"; then
      info "Remote uses HTTPS.  Auth options:"
      info "  • GitHub token (PAT): git credential store, then 'git push'"
      info "  • gh CLI:  gh auth login"
      # Check if GH_TOKEN or GITHUB_TOKEN is set
      if [ -n "${GH_TOKEN:-}" ] || [ -n "${GITHUB_TOKEN:-}" ]; then
        pass "GitHub token env var detected (GH_TOKEN / GITHUB_TOKEN)."
      else
        warn "No GitHub token env var found (GH_TOKEN / GITHUB_TOKEN)."
        fix "For CI/automation: export GH_TOKEN=<your-personal-access-token>"
        fix "For interactive: run 'gh auth login' (GitHub CLI) to authenticate."
        fix "For SSH fallback: change remote with:"
        fix "  git remote set-url origin git@github.com:Crispy4222/CRISPY-GARAGE-SHOP.git"
      fi
    elif echo "$REMOTE" | grep -q "^git@"; then
      pass "Remote uses SSH."
      # Check SSH key
      if ssh -T git@github.com -o StrictHostKeyChecking=accept-new -o BatchMode=yes 2>&1 | grep -q "successfully"; then
        pass "SSH auth to github.com: OK"
      else
        warn "SSH auth to github.com could not be verified (key may not be added, or no internet)."
        fix "Check: ssh -T git@github.com"
        fix "If denied: add your key at https://github.com/settings/keys"
        fix "Generate a key if needed: ssh-keygen -t ed25519 -C 'you@example.com'"
      fi
    fi
  else
    warn "No git origin remote set."
    fix "Add it with: git remote add origin $REPO_URL"
  fi
else
  warn "Not inside a git repository — some checks skipped."
  fix "Run: git init && git remote add origin $REPO_URL"
fi

# ── 4. GitHub Pages / docs folder ───────────────────
echo
info "Checking docs/ folder (GitHub Pages source)…"
if [ -d "$DOCS_DIR" ]; then
  pass "docs/ folder exists."
else
  fail "docs/ folder is missing — GitHub Pages (docs source) will fail."
  fix "Create it: mkdir -p docs"
fi

REQUIRED_FILES=(
  "$DOCS_DIR/index.html"
  "$DOCS_DIR/style.css"
  "$DOCS_DIR/app.js"
  "$DOCS_DIR/sw.js"
  "$DOCS_DIR/manifest.webmanifest"
  "$DOCS_DIR/catalog.json"
  "$DOCS_DIR/.nojekyll"
)
for f in "${REQUIRED_FILES[@]}"; do
  if [ -f "$f" ]; then
    pass "$f present."
  else
    fail "$f is missing."
    fix "Restore from git: git checkout HEAD -- $f"
    fix "Or re-run fix_shop.sh to regenerate missing files."
  fi
done

# ── 5. index.html sanity check ───────────────────────
echo
info "Checking index.html for broken references…"
INDEX="$DOCS_DIR/index.html"
if [ -f "$INDEX" ]; then
  if grep -q '/frontend/' "$INDEX"; then
    fail "index.html still references /frontend/ paths which don't exist in this repo."
    fix "Replace '/frontend/styles.css' with 'style.css' and '/frontend/script.js' with 'app.js'."
    fix "Or restore with: git checkout HEAD -- $INDEX"
  else
    pass "index.html has no broken /frontend/ references."
  fi
  if grep -qi 'PHOENIX OS' "$INDEX"; then
    warn "index.html title says 'PHOENIX OS' — this may not be the correct shop page."
    fix "Ensure index.html is the CRISPY Garage Shop front-end, not a different app."
  fi
  if ! grep -q 'manifest.webmanifest' "$INDEX"; then
    warn "index.html does not link to manifest.webmanifest — PWA install prompt may not appear."
    fix "Add inside <head>: <link rel=\"manifest\" href=\"manifest.webmanifest\">"
  fi
  if ! grep -q 'serviceWorker' "$INDEX" && ! grep -q 'sw.js' "$INDEX"; then
    warn "index.html does not register sw.js — offline PWA caching will not work."
    fix "Add before </body>: <script>if('serviceWorker' in navigator)navigator.serviceWorker.register('sw.js');</script>"
  fi
fi

# ── 6. catalog.json validity ─────────────────────────
echo
info "Checking catalog.json…"
CATALOG="$DOCS_DIR/catalog.json"
if [ -f "$CATALOG" ]; then
  if python3 -c "import json,sys; json.load(open('$CATALOG'))" 2>/dev/null \
     || node -e "JSON.parse(require('fs').readFileSync('$CATALOG','utf8'))" 2>/dev/null \
     || jq . "$CATALOG" >/dev/null 2>/dev/null; then
    pass "catalog.json is valid JSON."
    ITEM_COUNT=$(python3 -c "import json; print(len(json.load(open('$CATALOG'))))" 2>/dev/null \
      || node -e "console.log(JSON.parse(require('fs').readFileSync('$CATALOG','utf8')).length)" 2>/dev/null \
      || echo "?")
    if [ "$ITEM_COUNT" = "0" ]; then
      warn "catalog.json is an empty array — no products will show."
      fix "Run: bash $DOCS_DIR/build-catalog.sh   (put .zip files in $DOCS_DIR/products/ first)"
    else
      pass "catalog.json has $ITEM_COUNT item(s)."
    fi
  else
    fail "catalog.json is not valid JSON."
    fix "Quickest fix: echo '[]' > $CATALOG"
    fix "Or rebuild: bash $DOCS_DIR/build-catalog.sh"
  fi
fi

# ── 7. Shell script syntax check ────────────────────
echo
info "Checking shell scripts for syntax errors…"
SHELL_SCRIPTS=(
  "fix_shop.sh"
  "$DOCS_DIR/build-catalog.sh"
  "$DOCS_DIR/patch-ui.sh"
  "$DOCS_DIR/scripts/crispy-onboard.sh"
  "$DOCS_DIR/scripts/termux-clean.sh"
  "$DOCS_DIR/scripts/storage-pass.sh"
)
for s in "${SHELL_SCRIPTS[@]}"; do
  if [ -f "$s" ]; then
    if bash -n "$s" 2>/dev/null; then
      pass "$s syntax OK."
    else
      fail "$s has a bash syntax error:"
      bash -n "$s" 2>&1 | sed 's/^/    /' || true
      fix "Open $s and fix the reported line."
    fi
  else
    warn "$s not found (skipping)."
  fi
done

# ── 8. Network / live endpoint checks (optional) ────
echo
info "Checking live endpoints (requires internet)…"
ENDPOINTS=(
  "$SITE_URL"
  "$SCRIPT_BASE/termux-clean.sh"
  "$SCRIPT_BASE/storage-pass.sh"
  "$SCRIPT_BASE/crispy-onboard.sh"
)
for url in "${ENDPOINTS[@]}"; do
  HTTP=$(curl -o /dev/null -s -w '%{http_code}' --max-time 8 "$url" 2>/dev/null) || true
  HTTP="${HTTP:-000}"
  if [ "$HTTP" = "200" ]; then
    pass "$url → $HTTP"
  elif [ "$HTTP" = "000" ]; then
    warn "$url — no response (offline, DNS blocked, or sandbox restriction)."
    fix "If you have internet access, run: curl -I $url"
  else
    fail "$url → HTTP $HTTP"
    fix "If this is a fresh push, wait 1–2 min for GitHub Pages to deploy, then rerun."
    fix "If 404 persists, confirm Pages is enabled: Settings → Pages → Source: main, /docs."
    fix "Ensure $DOCS_DIR/.nojekyll exists: touch $DOCS_DIR/.nojekyll && git add $DOCS_DIR/.nojekyll && git commit -m 'add .nojekyll' && git push"
  fi
done

# ── 9. Summary ───────────────────────────────────────
echo
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e " ${GRN}PASS: $PASS${RST}   ${YEL}WARN: $WARN${RST}   ${RED}FAIL: $FAIL${RST}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ "$FAIL" -gt 0 ]; then
  echo -e "${RED}Action required — fix all [✗] items above, then rerun this script.${RST}"
  exit 1
elif [ "$WARN" -gt 0 ]; then
  echo -e "${YEL}Some warnings found — review [!] items above.${RST}"
  exit 0
else
  echo -e "${GRN}All checks passed. Shop looks ready!${RST}"
  echo "  Live site: $SITE_URL"
  exit 0
fi
