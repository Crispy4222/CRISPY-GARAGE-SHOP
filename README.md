# CRISPY Garage — CRISPYcreations

**Live shop:** https://crispy4222.github.io/CRISPY-GARAGE-SHOP/

## Current paid offer

**CRISPY Phone Cleanup + Tune-Up — $15 one-time**

A manual Android/Termux service covering:
- Storage review.
- Selected cache and log cleanup guidance.
- Startup and process review.
- A device-specific before-and-after summary.

[Pay by card through Stripe Checkout](https://buy.stripe.com/3cIfZhgoff0g7TQcf54ko01) · [Open the shop for Cash App and intake details](https://crispy4222.github.io/CRISPY-GARAGE-SHOP/)

**Fulfillment is manual.** Stripe collects the contact and device details needed for review; CRISPY Garage follows up by email. The service does not automatically access or modify a device. No rooting, account recovery, security bypass, remote access, or guaranteed performance improvement is promised.

## Free inspectable tools

The repository includes two free Termux helpers that perform selected deletions:
- [termux-clean.sh](docs/scripts/termux-clean.sh)
- [storage-pass.sh](docs/scripts/storage-pass.sh)

It also includes a separate [read-only Termux diagnostic](docs/scripts/termux-diagnostic.sh) that reports basic environment, filesystem-capacity, and package-inventory information without changing files or making network requests. See the [usage and privacy notes](docs/TERMUX-DIAGNOSTIC.md).

The cleanup helpers are **destructive if run**. `termux-clean.sh` runs `apt-get autoremove -y` (which can remove packages marked as no longer required), purges pip and npm caches, deletes cache files older than 7 days, and deletes home-directory log files older than 14 days. `storage-pass.sh` deletes files in Android's thumbnail cache. These actions do not provide an interactive per-file confirmation. Inspect the source and back up important data first. The catalog snippet only downloads the scripts for inspection; do not pipe an unreviewed script directly into a shell.

## Support

Optional project support: https://cash.app/$Lcrispy

Support is voluntary. The source and free tools remain available without payment.
