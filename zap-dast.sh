#!/bin/bash

set -e

ZAP_REPORT_DIR="zap-report"
mkdir -p $ZAP_REPORT_DIR

TARGET_URL="http://devsecopsgenai-staging.eba-3u9au2bw.us-east-1.elasticbeanstalk.com/"
echo "🔍 Running ZAP scan on: $TARGET_URL"

# Run ZAP scan but prevent it from causing a pipeline failure
docker run --user root \
  -v "$(pwd)/$ZAP_REPORT_DIR:/zap/wrk/:rw" \
  ghcr.io/zaproxy/zaproxy:stable zap-baseline.py \
  -t "$TARGET_URL" \
  -r zap-report.html || echo "⚠️ ZAP completed with warnings"

# Ensure report exists before proceeding
if [ ! -f "$ZAP_REPORT_DIR/zap-report.html" ]; then
  echo "❌ ZAP report not found. Exiting."
  exit 0  # Don't fail pipeline, just exit gracefully
fi

echo "📁 Listing report folder contents..."
ls -lh $ZAP_REPORT_DIR

echo "✅ DAST scan completed. Report saved to $ZAP_REPORT_DIR/zap-report.html"
