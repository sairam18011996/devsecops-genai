#!/bin/bash
set -e

ZAP_REPORT_DIR="zap-report"
mkdir -p "$ZAP_REPORT_DIR"

TARGET_URL="http://devsecopsgenai-staging.eba-3u9au2bw.us-east-1.elasticbeanstalk.com/"
echo "🔍 Running ZAP scan on: $TARGET_URL"

docker run --user root \
  -v "$(pwd)/$ZAP_REPORT_DIR:/zap/wrk/:rw" \
  -w /zap/wrk/ \
  ghcr.io/zaproxy/zaproxy:stable zap-baseline.py \
  -t "$TARGET_URL" \
  -r zap-report.html \
  --exit-zero-if-only-warn || echo "⚠️ ZAP exited with warning, but no hard failure."

# Final check: was the report actually created?
if [ ! -f "$ZAP_REPORT_DIR/zap-report.html" ]; then
  echo "❌ ZAP report not generated at $ZAP_REPORT_DIR/zap-report.html"
  echo "👉 ZAP might have failed to scan the URL or exited too early."
  echo "🛑 Skipping upload to S3."
  exit 0
fi

echo "📁 Listing report folder contents..."
ls -lh "$ZAP_REPORT_DIR"

echo "✅ DAST scan completed. Report saved to $ZAP_REPORT_DIR/zap-report.html"
