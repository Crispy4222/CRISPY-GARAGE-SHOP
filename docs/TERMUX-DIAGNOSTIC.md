# CRISPY Garage Termux Diagnostic

**Version:** 0.1.0  
**Type:** Read-only inventory  
**Platform:** Termux on Android

## What it reports

- Current date/time and CPU architecture.
- Android version, when the read-only `getprop` command is available.
- Filesystem capacity for the Termux home directory.
- Filesystem capacity for shared Android storage, when that path is mounted and accessible.
- Number of installed package records.
- Whether common Termux information commands are available.

## What it does not do

- It does not install, update, remove, move, or modify packages or files.
- It does not scan personal file contents or upload a report.
- It does not make network requests.
- It does not require root.
- It is not an antivirus scan, storage cleaner, repair tool, or performance benchmark.

The script reads basic system properties, filesystem capacity metadata, and the local package database. Android storage permissions can prevent a shared-storage result; the report will say when that path is unavailable.

## Run it

After the file is available from the Garage site, download it as a normal file and inspect it before running:

```bash
curl -fsSLO https://crispy4222.github.io/CRISPY-GARAGE-SHOP/scripts/termux-diagnostic.sh
less termux-diagnostic.sh
bash termux-diagnostic.sh
```

Help:

```bash
bash termux-diagnostic.sh --help
```

The download command writes the script into the current directory. The script itself only prints a report to the terminal.

## Privacy

The report can include Android version, architecture, storage capacity, and the Termux home path. Review and redact the output before sharing it publicly or sending it to support.
