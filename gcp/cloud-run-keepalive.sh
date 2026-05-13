#!/usr/bin/env bash
set -euo pipefail

# Required
URI="${URI:?Set URI to the endpoint to ping, e.g. URI=https://your-service.run.app/healthz}"

# Optional
JOB_NAME="${JOB_NAME:-keep-alive-tick}"
SCHEDULE="${SCHEDULE:-*/5 * * * *}"
LOCATION="${LOCATION:-us-east1}"
TIMEZONE="${TIMEZONE:-America/New_York}"
SERVICE_ACCOUNT="${SERVICE_ACCOUNT:-}"
SERVICE_NAME="${SERVICE_NAME:-}"

gcloud services enable cloudscheduler.googleapis.com --quiet

# Grant invoker role when running against a private Cloud Run service
if [[ -n "$SERVICE_ACCOUNT" && -n "$SERVICE_NAME" ]]; then
  echo "Granting roles/run.invoker to $SERVICE_ACCOUNT on $SERVICE_NAME..."
  gcloud run services add-iam-policy-binding "$SERVICE_NAME" \
    --member="serviceAccount:$SERVICE_ACCOUNT" \
    --role="roles/run.invoker" \
    --region="$LOCATION" \
    --quiet
fi

build_args() {
  local verb="$1"
  local args=(
    "$verb" http "$JOB_NAME"
    --schedule="$SCHEDULE"
    --uri="$URI"
    --http-method=GET
    --location="$LOCATION"
    --time-zone="$TIMEZONE"
  )
  if [[ -n "$SERVICE_ACCOUNT" ]]; then
    args+=(
      --oidc-service-account-email="$SERVICE_ACCOUNT"
      --oidc-token-audience="$URI"
    )
  fi
  gcloud scheduler jobs "${args[@]}"
}

if gcloud scheduler jobs describe "$JOB_NAME" --location="$LOCATION" &>/dev/null; then
  echo "Job already exists — updating..."
  build_args update
else
  echo "Creating scheduler job..."
  build_args create
fi

echo ""
echo "Done. Job status:"
gcloud scheduler jobs describe "$JOB_NAME" --location="$LOCATION" \
  --format="table(name,schedule,state,lastAttemptTime)"
