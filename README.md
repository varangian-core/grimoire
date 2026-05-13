# grimoire

AI-consumable automation scripts for GCP, GitHub, and beyond.

## For AI assistants

Fetch the script index first, then execute what you need:

```sh
# 1. Read the index
curl -fsSL https://raw.githubusercontent.com/varangian-core/grimoire/main/SCRIPTS.md

# 2. Run a script (example)
URI=https://your-service.run.app/healthz \
  bash <(curl -fsSL https://raw.githubusercontent.com/varangian-core/grimoire/main/gcp/cloud-run-keepalive.sh)
```

## Scripts

See [SCRIPTS.md](SCRIPTS.md) for the full index with usage, required variables, and raw URLs.

## Structure

```
grimoire/
├── SCRIPTS.md          ← AI-readable index of all scripts
├── gcp/                ← Google Cloud Platform
└── (more providers as added)
```
