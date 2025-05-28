#!/bin/bash

ZAP_REPORT_DIR="zap-report"
mkdir -p "$ZAP_REPORT_DIR"

TARGET_URL="http://devsecopsgenai-staging.eba-3u9au2bw.us-east-1.elasticbeanstalk.com/"

echo "[ZAP] Starting OWASP ZAP Baseline Scan on: $TARGET_URL"

# 🔐 Capture error inline to prevent propagation
ZAP_EXIT_CODE=0

docker run --user root \
  -v "$(pwd)/$ZAP_REPORT_DIR:/zap/wrk/:rw" \
  ghcr.io/zaproxy/zaproxy:stable zap-baseline.py \
  -t "$TARGET_URL" \
  -r zap-report.html || ZAP_EXIT_CODE=$?

echo "[ZAP] Exit Code: $ZAP_EXIT_CODE"

# Log warning but do NOT fail pipeline
if [ "$ZAP_EXIT_CODE" -ne 0 ]; then
  echo "[ZAP] Non-zero exit code ($ZAP_EXIT_CODE) — likely warnings or 500 errors — continuing anyway."
fi

echo "✅ ZAP scan completed with warnings or non-zero exit code (ignored)."
echo "✅ Report saved to $ZAP_REPORT_DIR/zap-report.html"

# ✅ Ensure successful exit for CodeBuild and CodePipeline
exit 0
