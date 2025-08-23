#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail
PROD_DIR="products"
SITE="https://crispy4222.github.io/CRISPY-GARAGE-SHOP"
CASH_TAG="${CASH_TAG:-Lcrispy}"   # change with: export CASH_TAG=YourTag
TIP="https://cash.app/$CASH_TAG"

echo "[" > catalog.json
first=1
shopt -s nullglob
for z in "$PROD_DIR"/*.zip; do
  file="$(basename "$z")"
  title="$file"
  desc="Download pack"
  note=""
  code=""
  tip_label='$5'   # keep as literal string

  case "$file" in
    Scripts_Duo.zip)
      title="CRISPY Scripts — Phone Cleanup Duo"
      desc="Termux one-liners for quick relief."
      code="curl -fsSL $SITE/scripts/termux-clean.sh | bash\ncurl -fsSL $SITE/scripts/storage-pass.sh | bash"
      tip_label='$5'
      ;;
    HUD_Lite.zip)
      title="Felix HUD Lite — Overlay Pack"
      desc="Wallpapers + icons to set the vibe."
      note="No paywall. Tip if you vibe."
      tip_label='$10'
      ;;
    Supporter_Bundle.zip)
      title="CRISPY Supporter Bundle"
      desc="HUD Lite + Scripts Duo together in one pack."
      note="Best way to back the Garage. One click = all the goods."
      tip_label='$15'
      ;;
  esac

  [ $first -eq 1 ] && first=0 || echo "," >> catalog.json

  jq -n \
    --arg title "$title" \
    --arg desc "$desc" \
    --arg zip "$file" \
    --arg tip "$TIP" \
    --arg tip_label "$tip_label" \
    --arg code "$code" \
    --arg note "$note" \
    '{
       title:$title,
       desc:$desc,
       zip:$zip,
       tip:$tip,
       tip_label:$tip_label,
       code: ($code | select(length>0)),
       note: ($note | select(length>0))
     }' >> catalog.json
done
echo "]" >> catalog.json
echo "[✓] catalog.json updated."
