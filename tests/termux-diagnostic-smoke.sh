#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)"
SCRIPT="$ROOT/docs/scripts/termux-diagnostic.sh"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

bash -n "$SCRIPT"
bash "$SCRIPT" --help >"$TMP/help.txt"
grep -q 'Usage:' "$TMP/help.txt"

if bash "$SCRIPT" --not-a-real-option >"$TMP/invalid.txt" 2>&1; then
  printf 'Expected invalid option to fail.\n' >&2
  exit 1
fi

HOME="$TMP/home" bash "$SCRIPT" >"$TMP/report.txt"
grep -q 'Mode: READ-ONLY' "$TMP/report.txt"
grep -q 'No files were modified and no network requests were made' "$TMP/report.txt"

if grep -Eq '(^|[;&|[:space:]])(rm|mv|cp|chmod|curl|wget|apt-get|find|sed|touch|tee)([[:space:]]|$)|pkg[[:space:]]+install' "$SCRIPT"; then
  printf 'Unexpected mutating/network command token found in diagnostic script.\n' >&2
  exit 1
fi

printf '[PASS] syntax, help, invalid-option handling, read-only output, and command-token guard\n'
