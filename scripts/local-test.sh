#!/bin/bash
# DSH Insurance Experts - Local Test Script
# Run this script after building all packages (npm run build)
#
# Prerequisites:
#   1. DeepSeek Harness (DSH) installed: npm install -g @anthropic/dsh
#   2. All packages built: npm run build
#
# Usage:
#   chmod +x scripts/local-test.sh
#   ./scripts/local-test.sh

set -e

echo "=========================================="
echo "  DSH Insurance Experts - Local Test"
echo "=========================================="
echo ""

# Get the project root directory
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

echo "[1/4] Adding plugins to DSH profile..."
echo ""

# Add each plugin via local link
dsh plugin --profile web add "link:$PROJECT_ROOT/packages/insurance-ops-analyst" || echo "  (ops-analyst already added or dsh not found)"
dsh plugin --profile web add "link:$PROJECT_ROOT/packages/insurance-company-analyst" || echo "  (company-analyst already added or dsh not found)"
dsh plugin --profile web add "link:$PROJECT_ROOT/packages/insurance-product-analyst" || echo "  (product-analyst already added or dsh not found)"

echo ""
echo "[2/4] Starting DSH web server..."
echo ""
echo "  Starting dsh web on http://127.0.0.1:3080"
echo "  Press Ctrl+C to stop after testing."
echo ""

# Start the web server in background
dsh web &
DSH_PID=$!

# Wait for server to be ready
sleep 3

echo "[3/4] DSH web server started (PID: $DSH_PID)"
echo ""
echo "  Open http://127.0.0.1:3080 in your browser."
echo ""
echo "  Test prompts:"
echo "  ---"
echo "  1. Insurance Ops Analyst (Ying'an):"
echo "     -> 用盈安的身份分析某寿险公司2024年偿付能力下降的原因"
echo ""
echo "  2. Insurance Company Analyst:"
echo "     -> 对比平安人寿和中国人寿2024年的NBV增速和渠道结构"
echo ""
echo "  3. Insurance Product Analyst (InsureGuide):"
echo "     -> 帮我对比某两款重疾险的性价比，预算年缴1万以内"
echo "  ---"
echo ""

echo "[4/4] Waiting for you to test (Ctrl+C to stop server)..."
wait $DSH_PID
