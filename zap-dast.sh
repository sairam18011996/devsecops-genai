#!/bin/bash
set -e

ZAP_REPORT_DIR="zap-report"
mkdir -p $ZAP_REPORT_DIR

TARGET_URL=$TARGET_URL

docker run --user root \
  -v $(pwd)/$ZAP_REPORT_DIR:/zap/wrk/:rw \
  ghcr.io/zaproxy/zaproxy:stable zap-baseline.py \
  -t "$TARGET_URL" \
  -r zap-report.html || true

echo "📁 Listing report folder contents..."
ls -lh $ZAP_REPORT_DIR

echo "✅ DAST scan completed. Report saved to $ZAP_REPORT_DIR/zap-report.html"
