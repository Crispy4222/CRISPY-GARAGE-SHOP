#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
cd "$SCRIPT_DIR"

PROD_DIR="products"
SITE="${SITE:-https://crispy4222.github.io/CRISPY-GARAGE-SHOP}"
CASH_TAG="${CASH_TAG:-Lcrispy}"
TIP="https://cash.app/$CASH_TAG"

command -v jq >/dev/null 2>&1 || {
  printf 'build-catalog: jq is required\n' >&2
  exit 1
}

tmp="$(mktemp "$SCRIPT_DIR/catalog.json.XXXXXX")"
trap 'rm -f "$tmp" "$tmp.next"' EXIT

jq -n   --arg tip "$TIP"   --arg code "curl -fsSLO $SITE/scripts/termux-clean.sh
curl -fsSLO $SITE/scripts/storage-pass.sh
less termux-clean.sh storage-pass.sh"   '[{
    title:"CRISPY Phone Cleanup Duo",
    desc:"Two small Termux helpers for reviewing storage use and clearing selected caches.",
    tip:$tip,
    tip_label:"$5 suggested",
    code:$code,
    note:"Inspect before execution: these helpers remove selected caches, older logs, and Android thumbnail-cache files."
  }]' > "$tmp"

shopt -s nullglob
for archive in "$PROD_DIR"/*.zip; do
  file="$(basename "$archive")"
  title="${file%.zip}"
  desc="Verified CRISPY Garage download."
  note="Download is immediate and provided as-is."
  tip_label='$5 suggested'

  case "$file" in
    sample-pack.zip)
      title="CRISPY Garage Sample Pack"
      desc="The verified starter archive currently stored in this repository."
      ;;
    Scripts_Duo.zip)
      title="CRISPY Scripts — Phone Cleanup Duo"
      desc="Termux helpers for storage review and selected cache cleanup."
      ;;
    HUD_Lite.zip)
      title="FELIX HUD Lite — Overlay Pack"
      desc="Garage wallpapers and interface assets."
      tip_label='$10 suggested'
      ;;
    Quick_Guides.zip)
      title="CRISPY Quick Guides"
      desc="Short how-to guides from the Garage."
      tip_label='$0+'
      ;;
    Supporter_Bundle.zip)
      title="CRISPY Supporter Bundle"
      desc="The currently packaged Garage downloads in one archive."
      tip_label='$15 suggested'
      ;;
  esac

  item="$(jq -n     --arg title "$title"     --arg desc "$desc"     --arg zip "$file"     --arg tip "$TIP"     --arg tip_label "$tip_label"     --arg note "$note"     '{title:$title,desc:$desc,zip:$zip,tip:$tip,tip_label:$tip_label,note:$note}')"

  jq --argjson item "$item" '. + [$item]' "$tmp" > "$tmp.next"
  mv "$tmp.next" "$tmp"
done

jq empty "$tmp"
mv "$tmp" catalog.json
trap - EXIT
printf '[OK] %s/catalog.json updated with %s entries.\n' "$SCRIPT_DIR" "$(jq length catalog.json)"
