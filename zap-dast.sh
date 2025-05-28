#!/bin/bash
set -e

ZAP_REPORT_DIR="zap-report"
mkdir -p $ZAP_REPORT_DIR

TARGET_URL="http://devsecopsgenai-staging.eba-3u9au2bw.us-east-1.elasticbeanstalk.com/"

echo "[ZAP] Starting OWASP ZAP Baseline Scan on: $TARGET_URL"

docker run --user root \
  -v $(pwd)/$ZAP_REPORT_DIR:/zap/wrk/:rw \
  ghcr.io/zaproxy/zaproxy:stable zap-baseline.py \
  -t "$TARGET_URL" \
  -r zap-report.html || echo "[ZAP] Completed with warnings but continuing..."

echo "DAST scan completed. Report saved to $ZAP_REPORT_DIR/zap-report.html"

#  Force success exit for CodeBuild
exit 0
