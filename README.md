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

Inspect the cleanup source before running either cleanup helper. They perform deletions: `termux-clean.sh` runs `apt-get autoremove -y` and removes selected caches and older logs; `storage-pass.sh` removes files from Android's thumbnail cache. Back up important data first. Do not pipe an unreviewed script directly into a shell.

## Support

Optional project support: https://cash.app/$Lcrispy

Support is voluntary. The source and free tools remain available without payment.
