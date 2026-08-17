# CRISPY Revenue Design — Manual First, Automated Next

## Goal
Turn the existing CRISPY Garage page into a real sale surface without pretending automatic fulfillment already exists.

## Phase 1 — live manual service
- Offer: **CRISPY Phone Cleanup + Tune-Up — $15**.
- Payment: Cash App `$Lcrispy`.
- Fulfillment: manual. Buyer pays, then emails `CRISPY@crispy-creations.com` with the payment name and device model so the job can be scheduled.
- Scope: Android/Termux storage review, cache/log cleanup guidance, startup/process review, and a before/after summary. No promise of rooting, account recovery, bypassing security controls, or guaranteed performance gains.
- Existing cleanup scripts remain free and inspectable as a separate demo/tool item. They are not relabeled as a paid download.
- The page must state that automatic paid delivery is not connected yet.

## Phase 2 — automated checkout
Later replace the manual payment/contact handoff with a provider-backed checkout and order record while keeping the catalog display independent from the payment provider. Provider credentials and webhooks are intentionally not embedded in the static site.

## Data flow
Visitor → catalog → $15 service card → Cash App payment → email intake → manual fulfillment.

## Acceptance
A stranger can understand the offer, see the exact price, pay, know what to do next, and separately inspect the free scripts. The site makes no claim that payment automatically unlocks anything until Phase 2 is actually connected.
