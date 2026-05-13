# Grimoire — Script Index

> For AI assistants: fetch this file to discover all available scripts. Each entry includes a raw URL, purpose, required and optional variables, and a ready-to-run usage line. Execute scripts via `bash <(curl -fsSL <raw-url>)` with env vars set as shown.

---

## GCP

### cloud-run-keepalive
**File:** `gcp/cloud-run-keepalive.sh`
**Raw:** `https://raw.githubusercontent.com/varangian-core/grimoire/main/gcp/cloud-run-keepalive.sh`
**Purpose:** Creates a Google Cloud Scheduler job that pings a Cloud Run endpoint on a cron schedule to prevent cold-starts. Supports both public and IAM-authenticated services.

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `URI` | yes | — | Full URL of the endpoint to ping |
| `JOB_NAME` | no | `keep-alive-tick` | Cloud Scheduler job name |
| `SCHEDULE` | no | `*/5 * * * *` | Cron expression |
| `LOCATION` | no | `us-east1` | GCP region |
| `TIMEZONE` | no | `America/New_York` | Scheduler timezone |
| `SERVICE_ACCOUNT` | no | — | Service account email for private services |
| `SERVICE_NAME` | no | — | Cloud Run service name (required with `SERVICE_ACCOUNT`) |

**Usage — public endpoint:**
```sh
URI=https://your-service.run.app/healthz \
  bash <(curl -fsSL https://raw.githubusercontent.com/varangian-core/grimoire/main/gcp/cloud-run-keepalive.sh)
```

**Usage — private (IAM-authenticated) endpoint:**
```sh
URI=https://your-service.run.app/healthz \
SERVICE_ACCOUNT=my-sa@my-project.iam.gserviceaccount.com \
SERVICE_NAME=my-service \
  bash <(curl -fsSL https://raw.githubusercontent.com/varangian-core/grimoire/main/gcp/cloud-run-keepalive.sh)
```
