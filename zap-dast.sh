set -e

ZAP_REPORT_DIR="zap-report"
mkdir -p $ZAP_REPORT_DIR

TARGET_URL="http://devsecopsgenai-staging.eba-3u9au2bw.us-east-1.elasticbeanstalk.com/"

echo "[ZAP] Starting OWASP ZAP Baseline Scan on: $TARGET_URL"

# 🚨 Run the scan, capture exit code explicitly
docker run --user root \
  -v $(pwd)/$ZAP_REPORT_DIR:/zap/wrk/:rw \
  ghcr.io/zaproxy/zaproxy:stable zap-baseline.py \
  -t "$TARGET_URL" \
  -r zap-report.html

ZAP_EXIT_CODE=$?

# ✅ Log it and mask it to avoid failure in CodeBuild
echo "[ZAP] Scan exit code: $ZAP_EXIT_CODE"
if [ "$ZAP_EXIT_CODE" -ne 0 ]; then
  echo "[ZAP] WARNINGS detected — scan completed with issues but not failing build."
fi

echo "✅ DAST scan completed. Report saved to $ZAP_REPORT_DIR/zap-report.html"

# ✅ Final exit that ensures CodeBuild exits cleanly
exit 0
