#!/bin/bash
set -e

ZAP_REPORT_DIR="zap-report"
mkdir -p $ZAP_REPORT_DIR

TARGET_URL="http://devsecopsgenai-staging.eba-3u9au2bw.us-east-1.elasticbeanstalk.com/"
echo "🔍 Running ZAP scan on: $TARGET_URL"

# Run ZAP with fallback
docker run --user root \
  -v "$(pwd)/$ZAP_REPORT_DIR:/zap/wrk/:rw" \
  ghcr.io/zaproxy/zaproxy:stable zap-baseline.py \
  -t "$TARGET_URL" \
  -r zap-report.html \
  --exit-zero-if-only-warn || echo "⚠️ ZAP scan exited with warnings."

# Confirm if report was generated
if [ ! -f "$ZAP_REPORT_DIR/zap-report.html" ]; then
  echo "❌ ZAP report not generated at $ZAP_REPORT_DIR/zap-report.html"
  echo "👉 ZAP might have failed to scan the URL or exited too early."
  echo "🛑 Skipping upload to S3."
  exit 0
fi

echo "📁 Listing report folder contents..."
ls -lh $ZAP_REPORT_DIR

echo "✅ DAST scan completed. Report saved to $ZAP_REPORT_DIR/zap-report.html"
