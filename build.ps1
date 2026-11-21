$ErrorActionPreference = "Stop"

Write-Host "=========================================" -ForegroundColor Magenta
Write-Host "   Avang VPN - GitHub Auto Build Tool    " -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Magenta

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "خطا: Git روی سیستم نصب نیست!" -ForegroundColor Red
    exit 1
}

if (-not (Test-Path ".git")) {
    Write-Host "در حال ساخت مخزن محلی Git..." -ForegroundColor Yellow
    git init
    git branch -M main
}

$remoteUrl = git remote get-url origin 2>$null
if (-not $remoteUrl) {
    $repoInput = Read-Host "لینک مخزن GitHub خود را وارد کنید (مثال: https://github.com/username/AvangVPN.git)"
    git remote add origin $repoInput
}

Write-Host "در حال آماده‌سازی فایل‌ها..." -ForegroundColor Cyan
git add .

$commitMsg = "Build AvangVPN Release - $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
git commit -m "$commitMsg" --allow-empty

Write-Host "در حال ارسال کدها به GitHub..." -ForegroundColor Yellow
git push -u origin main

Write-Host "=========================================" -ForegroundColor Green
Write-Host "ارسال با موفقیت انجام شد!" -ForegroundColor Green
Write-Host "وارد بخش Actions در مخزن GitHub خود شوید و فایل AvangVPN-Signed-APK را دانلود کنید." -ForegroundColor White
Write-Host "=========================================" -ForegroundColor Green