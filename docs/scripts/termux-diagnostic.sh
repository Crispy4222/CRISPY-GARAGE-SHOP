#!/data/data/com.termux/files/usr/bin/bash
# CRISPY Garage read-only Termux diagnostic
set -uo pipefail

VERSION="0.1.0"

usage() {
  cat <<'EOF'
CRISPY Garage Termux Diagnostic

Usage:
  bash termux-diagnostic.sh
  bash termux-diagnostic.sh --help

This report is read-only. It does not install packages, change settings,
inspect personal file contents, or make network requests.
EOF
}

case "${1:-}" in
  "")
    ;;
  --help|-h)
    usage
    exit 0
    ;;
  *)
    usage >&2
    exit 2
    ;;
esac

# Fail closed outside a real Termux environment. This prevents a Linux
# desktop's dpkg database from being misreported as Android package data.
if [[ -z "${TERMUX_VERSION:-}" && "${PREFIX:-}" != */com.termux/files/usr ]]; then
  printf 'Unsupported environment: run this diagnostic inside Termux on Android.\n' >&2
  exit 3
fi

has() {
  command -v "$1" >/dev/null 2>&1
}

section() {
  printf '\n== %s ==\n' "$1"
}

printf 'CRISPY Garage Termux Diagnostic v%s\n' "$VERSION"
printf 'Mode: READ-ONLY\n'
printf 'Termux version: %s\n' "${TERMUX_VERSION:-detected from PREFIX}"
printf 'This report does not change settings, install packages, or inspect file contents.\n'
printf 'Review the output before sharing; it may include device and storage details.\n'

section "Environment"
printf 'Date: '
if has date; then
  date -Iseconds 2>/dev/null || date
else
  printf 'unavailable\n'
fi

printf 'Architecture: '
if has uname; then
  uname -m 2>/dev/null || printf 'unavailable\n'
else
  printf 'unavailable\n'
fi

if has getprop; then
  android_version="$(getprop ro.build.version.release 2>/dev/null || true)"
  if [[ -n "$android_version" ]]; then
    printf 'Android version: %s\n' "$android_version"
  else
    printf 'Android version: unavailable from getprop\n'
  fi
else
  printf 'Android version: getprop unavailable\n'
fi

printf 'Home path: %s\n' "${HOME:-not-set}"

section "Storage"
if has df && [[ -n "${HOME:-}" ]] && [[ -e "$HOME" ]]; then
  df -h "$HOME" 2>&1 || printf 'Could not read the home filesystem.\n'
else
  printf 'Home filesystem details unavailable.\n'
fi

if has df && [[ -d /storage/emulated/0 ]]; then
  df -h /storage/emulated/0 2>&1 || printf 'Shared storage filesystem details unavailable.\n'
else
  printf 'Shared Android storage path is not mounted or not accessible to this shell.\n'
fi

section "Termux package inventory"
if has dpkg-query; then
  package_count="$(dpkg-query -W -f='${binary:Package}\n' 2>/dev/null | awk 'END { print NR+0 }')"
  printf 'Installed package records: %s\n' "$package_count"
else
  printf 'dpkg-query unavailable; package count skipped.\n'
fi

for tool in pkg termux-info termux-battery-status; do
  if has "$tool"; then
    printf 'Available: %s\n' "$tool"
  else
    printf 'Not found: %s\n' "$tool"
  fi
done

section "Result"
printf 'Completed. No files were modified and no network requests were made.\n'
printf 'This is a basic inventory, not a malware scan or performance benchmark.\n'
