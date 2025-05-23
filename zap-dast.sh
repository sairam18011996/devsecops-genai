#!/bin/bash
set -e

ZAP_REPORT_DIR="zap-report"
mkdir -p $ZAP_REPORT_DIR

TARGET_URL="http://devsecopsgenai-staging.eba-3u9au2bw.us-east-1.elasticbeanstalk.com/"

echo "🔍 Running ZAP scan on: $TARGET_URL"

docker run --user root \
  -v $(pwd)/$ZAP_REPORT_DIR:/zap/wrk/:rw \
  ghcr.io/zaproxy/zaproxy:stable zap-baseline.py \
  -t "$TARGET_URL" \
  -r zap-report.html || true

# ✅ The report is already saved into zap-report/ by the container, no need to move it.
echo "📁 Listing report folder contents..."
ls -lh $ZAP_REPORT_DIR

echo "✅ DAST scan completed. Report saved to $ZAP_REPORT_DIR/zap-report.html"
