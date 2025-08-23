# CRISPY Garage — Micro Shop (PWA)

Single-folder static app you can host on GitHub Pages (use `/docs` source) or any static host.
Edit links in `index.html` to your payment handle(s) and swap `products/sample-pack.zip` with your real pack.

## Deploy (GitHub Pages via /docs)
```bash
gh repo create CRISPY-GARAGE-SHOP --public -y
git init && git add . && git commit -m "init shop"
git branch -M main
git remote add origin git@github.com:YOURUSER/CRISPY-GARAGE-SHOP.git
git push -u origin main
# Enable Pages → Source: main branch, folder: /docs (Settings → Pages)
```
