# CRISPY Manual Revenue Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Ship a truthful $15 manual cleanup/tune-up service flow while preserving the existing scripts as free inspectable tools.

**Architecture:** Keep the site static. `catalog.json` remains the source of offer data; `app.js` renders the offer and validates allowed links; `index.html` explains the manual payment/fulfillment state. No payment credentials or webhook logic are added in Phase 1.

**Tech Stack:** Static HTML/CSS/JavaScript, JSON catalog, Node built-in smoke test.

## Global Constraints
- Price is exactly `$15` for the manual service.
- Cash App target remains `https://cash.app/$Lcrispy`.
- Buyer contact is `CRISPY@crispy-creations.com`.
- Existing cleanup scripts remain free and inspectable.
- Do not claim automatic paid delivery is connected.

---

### Task 1: Revenue smoke test

**Files:**
- Create: `tests/revenue-smoke.mjs`

**Interfaces:**
- Consumes: `docs/catalog.json`, `docs/index.html`, `docs/app.js`.
- Produces: a zero-dependency validation command: `node tests/revenue-smoke.mjs`.

- [ ] Write assertions for the paid service, exact price, Cash App URL, mailto contact, separate free tools, explicit manual-delivery copy, and mailto link support.
- [ ] Run `node tests/revenue-smoke.mjs` against current files and confirm it fails because the paid service does not exist.
- [ ] Commit the failing smoke test.

### Task 2: Catalog and renderer

**Files:**
- Modify: `docs/catalog.json`
- Modify: `docs/app.js`

**Interfaces:**
- Consumes: catalog fields `title`, `desc`, `price`, `tip`, `tip_label`, `contact`, `links`, `note`.
- Produces: rendered pay and contact buttons with host/protocol validation.

- [ ] Add `CRISPY Phone Cleanup + Tune-Up` with `price: "$15"`, Cash App payment link, manual-contact mailto URL, scope copy, and manual-fulfillment note.
- [ ] Rename the existing script offer to `CRISPY Phone Cleanup Duo — Free Tools` and remove its tip/payment fields.
- [ ] Allow `mailto:` links in `safeHref` without opening arbitrary protocols.
- [ ] Render price/contact actions when present.
- [ ] Run the smoke test; it should still fail until landing-page copy is updated.
- [ ] Commit catalog/renderer changes.

### Task 3: Landing page truthfulness

**Files:**
- Modify: `docs/index.html`

**Interfaces:**
- Consumes: the Phase 1 service state.
- Produces: visible buyer instructions matching the catalog.

- [ ] Change the hero/status copy to advertise `$15 manual cleanup + tune-up` without implying automation.
- [ ] Explain: pay with Cash App, then email the payment name + device model to schedule fulfillment.
- [ ] State exactly that automatic paid delivery is not connected yet.
- [ ] Run `node tests/revenue-smoke.mjs` and confirm PASS.
- [ ] Commit landing-page changes.

### Task 4: Review branch

**Files:**
- No production changes.

**Interfaces:**
- Consumes: completed branch.
- Produces: a reviewable pull request into `main`.

- [ ] Compare `main...crispy-c-revenue` for accidental unrelated changes.
- [ ] Open a PR describing the real manual sale flow and the deferred automated-checkout phase.
- [ ] Do not merge without explicit operator approval.
