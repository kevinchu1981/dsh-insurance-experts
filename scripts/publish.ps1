# DSH Insurance Experts - Publish Script (Windows PowerShell)
#
# Prerequisites:
#   1. npm account: npm login
#   2. GitHub CLI: gh auth login
#   3. All packages built: npm run build
#
# Usage:
#   .\scripts\publish.ps1

$ErrorActionPreference = "Stop"

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "  DSH Insurance Experts - Publishing" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

$ProjectRoot = Split-Path -Parent $PSScriptRoot
Set-Location $ProjectRoot

# Step 1: Check npm login
Write-Host "[1/6] Checking npm login status..." -ForegroundColor Yellow
$npmUser = npm whoami 2>$null
if (-not $npmUser) {
    Write-Host "  Not logged in to npm. Please run: npm login" -ForegroundColor Red
    Write-Host "  Sign up at https://www.npmjs.com if you don't have an account."
    exit 1
}
Write-Host "  Logged in as: $npmUser" -ForegroundColor Green
Write-Host ""

# Step 2: Build all packages
Write-Host "[2/6] Building all packages..." -ForegroundColor Yellow
npm run build
if ($LASTEXITCODE -ne 0) {
    Write-Host "  Build failed!" -ForegroundColor Red
    exit 1
}
Write-Host "  Build complete." -ForegroundColor Green
Write-Host ""

# Step 3: Publish each package to npm
Write-Host "[3/6] Publishing packages to npm..." -ForegroundColor Yellow

$packages = @(
    "insurance-ops-analyst",
    "insurance-company-analyst",
    "insurance-product-analyst"
)

foreach ($pkg in $packages) {
    Write-Host "  Publishing $pkg..." -ForegroundColor White
    Set-Location "$ProjectRoot\packages\$pkg"
    npm publish --access public
    if ($LASTEXITCODE -ne 0) {
        Write-Host "  Failed to publish $pkg!" -ForegroundColor Red
        Set-Location $ProjectRoot
        exit 1
    }
    Set-Location $ProjectRoot
}
Write-Host "  All packages published to npm!" -ForegroundColor Green
Write-Host ""

# Step 4: Git init and push to GitHub
Write-Host "[4/6] Setting up GitHub repository..." -ForegroundColor Yellow

if (-not (Test-Path ".git")) {
    git init
}

git add -A
git commit -m "feat: DSH insurance expert plugins - ops analyst, company analyst, product analyst"
Write-Host "  Git repository committed." -ForegroundColor Green

# Create GitHub repo
$ghAvailable = Get-Command gh -ErrorAction SilentlyContinue
if ($ghAvailable) {
    Write-Host "  Creating GitHub repository..." -ForegroundColor White
    gh repo create dsh-insurance-experts --public --source=. --remote=origin --push
    if ($LASTEXITCODE -ne 0) {
        Write-Host "  (Repository may already exist.)" -ForegroundColor Yellow
    }
    Write-Host "  GitHub repository created!" -ForegroundColor Green
} else {
    Write-Host "  [!] GitHub CLI (gh) not found." -ForegroundColor Red
    Write-Host "  Install from: https://cli.github.com/"
    Write-Host "  Then run: gh repo create dsh-insurance-experts --public --source=. --push"
}
Write-Host ""

# Step 5: Add topics
Write-Host "[5/6] Adding 'dsh-plugin' topic..." -ForegroundColor Yellow
if ($ghAvailable) {
    $repo = gh repo view --json nameWithOwner --jq ".nameWithOwner" 2>$null
    if ($repo) {
        $topics = @("dsh-plugin", "deepseek", "deepseek-harness", "insurance", "cordis", "ai-plugin")
        $topicJson = $topics | ForEach-Object { '"$_"' } | Join-String -Separator ", "
        $topicJson = "{`"names`":[$topicJson]}"
        echo $topicJson | gh api -X PUT "/repos/$repo/topics" --input -
        Write-Host "  Topics added!" -ForegroundColor Green
    }
} else {
    Write-Host "  Add manually: GitHub repo -> Settings -> Topics -> dsh-plugin, deepseek, insurance" -ForegroundColor Yellow
}
Write-Host ""

# Step 6: Summary
Write-Host "[6/6] Publishing complete!" -ForegroundColor Green
Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "  Summary" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "  npm packages:"
Write-Host "    - @kevinsales/dsh-insurance-ops-analyst"
Write-Host "    - @kevinsales/dsh-insurance-company-analyst"
Write-Host "    - @kevinsales/dsh-insurance-product-analyst"
Write-Host ""
Write-Host "  Install commands:"
Write-Host "    dsh plugin --profile web add @kevinsales/dsh-insurance-ops-analyst"
Write-Host "    dsh plugin --profile web add @kevinsales/dsh-insurance-company-analyst"
Write-Host "    dsh plugin --profile web add @kevinsales/dsh-insurance-product-analyst"
Write-Host ""
