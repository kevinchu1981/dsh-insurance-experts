#!/bin/bash
# DSH Insurance Experts - Publish to npm & GitHub
#
# Prerequisites:
#   1. npm account: npm login (use your npmjs.com credentials)
#   2. GitHub CLI: gh auth login
#   3. All packages built: npm run build
#
# Usage:
#   chmod +x scripts/publish.sh
#   ./scripts/publish.sh

set -e

echo "=========================================="
echo "  DSH Insurance Experts - Publishing"
echo "=========================================="
echo ""

# Get the project root directory
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
cd "$PROJECT_ROOT"

# Step 1: Check npm login status
echo "[1/6] Checking npm login status..."
npm whoami || {
    echo "  Not logged in to npm. Please run: npm login"
    echo "  Sign up at https://www.npmjs.com if you don't have an account."
    exit 1
}
echo "  Logged in as: $(npm whoami)"
echo ""

# Step 2: Build all packages
echo "[2/6] Building all packages..."
npm run build
echo "  Build complete."
echo ""

# Step 3: Publish each package to npm
echo "[3/6] Publishing packages to npm..."

echo "  Publishing @kevinsales/dsh-insurance-ops-analyst..."
cd packages/insurance-ops-analyst
npm publish --access public
cd "$PROJECT_ROOT"

echo "  Publishing @kevinsales/dsh-insurance-company-analyst..."
cd packages/insurance-company-analyst
npm publish --access public
cd "$PROJECT_ROOT"

echo "  Publishing @kevinsales/dsh-insurance-product-analyst..."
cd packages/insurance-product-analyst
npm publish --access public
cd "$PROJECT_ROOT"

echo "  All packages published to npm!"
echo ""

# Step 4: Initialize git and push to GitHub
echo "[4/6] Setting up GitHub repository..."

# Check if git is already initialized
if [ ! -d ".git" ]; then
    git init
fi

git add -A
git commit -m "feat: DSH insurance expert plugins - ops analyst, company analyst, product analyst

Three DeepSeek Harness plugins for insurance analysis:
- @kevinsales/dsh-insurance-ops-analyst (Ying'an): solvency, profitability, EV, investment risk, compliance
- @kevinsales/dsh-insurance-company-analyst: financial & operating analysis, channels, peer comparison
- @kevinsales/dsh-insurance-product-analyst (InsureGuide): clause decoding, cost-effectiveness, comparison

Co-Authored-By: WorkBuddy"

echo ""
echo "  Git repository initialized and committed."
echo ""

# Create GitHub repo if gh CLI is available
if command -v gh &> /dev/null; then
    echo "  Creating GitHub repository..."
    gh repo create dsh-insurance-experts --public --source=. --remote=origin --push || {
        echo "  (Repository may already exist. Adding remote manually.)"
        git remote add origin "https://github.com/$(gh api user --jq .login)/dsh-insurance-experts.git" 2>/dev/null || true
    }
    echo "  GitHub repository created!"
else
    echo "  [!] GitHub CLI (gh) not found."
    echo "  Please install from: https://cli.github.com/"
    echo "  Then run: gh repo create dsh-insurance-experts --public --source=. --push"
    echo ""
    echo "  Or manually create a repo on GitHub and push:"
    echo "    git remote add origin https://github.com/YOUR_USERNAME/dsh-insurance-experts.git"
    echo "    git branch -M main"
    echo "    git push -u origin main"
fi
echo ""

# Step 5: Add dsh-plugin topic to GitHub repo
echo "[5/6] Adding 'dsh-plugin' topic to GitHub repository..."
if command -v gh &> /dev/null; then
    # Get the repo name
    REPO=$(gh repo view --json nameWithOwner --jq .nameWithOwner 2>/dev/null)
    if [ -n "$REPO" ]; then
        gh api -X PUT "/repos/$REPO/topics" -f "names[]=dsh-plugin" -f "names[]=deepseek" -f "names[]=deepseek-harness" -f "names[]=insurance" -f "names[]=cordis" -f "names[]=ai-plugin" 2>/dev/null && echo "  Topics added successfully!" || echo "  (Could not add topics automatically. Add them manually on GitHub.)"
    else
        echo "  (Could not determine repo name. Add topics manually on GitHub.)"
    fi
else
    echo "  [!] gh CLI not found. Add topics manually:"
    echo "    Go to your repo on GitHub -> About (right sidebar) -> Settings -> Topics"
    echo "    Add: dsh-plugin, deepseek, deepseek-harness, insurance, cordis, ai-plugin"
fi
echo ""

# Step 6: Summary
echo "[6/6] Publishing complete!"
echo ""
echo "=========================================="
echo "  Summary"
echo "=========================================="
echo ""
echo "  npm packages published:"
echo "    - @kevinsales/dsh-insurance-ops-analyst"
echo "    - @kevinsales/dsh-insurance-company-analyst"
echo "    - @kevinsales/dsh-insurance-product-analyst"
echo ""
echo "  GitHub repository pushed with dsh-plugin topic."
echo ""
echo "  Other users can now install:"
echo "    dsh plugin --profile web add @kevinsales/dsh-insurance-ops-analyst"
echo "    dsh plugin --profile web add @kevinsales/dsh-insurance-company-analyst"
echo "    dsh plugin --profile web add @kevinsales/dsh-insurance-product-analyst"
echo ""
echo "  Or via GitHub:"
echo "    dsh plugin --profile web add \"github:YOUR_USERNAME/dsh-insurance-experts#main\""
echo ""
