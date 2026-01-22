# Git履歴からAPIキーを削除するPowerShellスクリプト

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Git履歴からAPIキーを削除するスクリプト" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "警告: このスクリプトはGit履歴を書き換えます。" -ForegroundColor Yellow
Write-Host "リモートにプッシュ済みの場合は、force pushが必要になります。" -ForegroundColor Yellow
Write-Host ""

$confirm = Read-Host "続行しますか？ (y/N)"
if ($confirm -ne "y" -and $confirm -ne "Y") {
    Write-Host "キャンセルしました。" -ForegroundColor Red
    exit
}

Write-Host ""
Write-Host "[1/3] 現在の変更をコミット中..." -ForegroundColor Green

# 変更をステージング
git add set-openai-api-key.bat SETUP_OPENAI_API_KEY.md 2>$null

# コミット（変更がない場合はスキップ）
$status = git status --porcelain
if ($status) {
    git commit -m "Remove API keys from files (use environment variables instead)"
    Write-Host "変更をコミットしました。" -ForegroundColor Green
} else {
    Write-Host "コミットする変更がありません。" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "[2/3] Git履歴を書き換え中..." -ForegroundColor Green
Write-Host "これには時間がかかる場合があります..." -ForegroundColor Yellow
Write-Host ""

# 削除するAPIキー
$oldKeys = @(
    "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",
    "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"
)

# git filter-branchを使用して履歴を書き換え
# ファイルの内容を置き換え
$filterScript = @"
if (Test-Path set-openai-api-key.bat) {
    `$content = Get-Content set-openai-api-key.bat -Raw
    `$content = `$content -replace 'sk-proj-[A-Za-z0-9_-]+', 'REMOVED_API_KEY'
    Set-Content set-openai-api-key.bat -Value `$content -NoNewline
}
if (Test-Path SETUP_OPENAI_API_KEY.md) {
    `$content = Get-Content SETUP_OPENAI_API_KEY.md -Raw
    `$content = `$content -replace 'sk-proj-[A-Za-z0-9_-]+', 'your-openai-api-key-here'
    Set-Content SETUP_OPENAI_API_KEY.md -Value `$content -NoNewline
}
"@

# filter-branchを実行
Write-Host "履歴を書き換え中..." -ForegroundColor Yellow
git filter-branch --force --tree-filter $filterScript --prune-empty --tag-name-filter cat -- --all 2>&1 | Out-Null

Write-Host ""
Write-Host "[3/3] リフログをクリーンアップ中..." -ForegroundColor Green
git reflog expire --expire=now --all
git gc --prune=now --aggressive

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "完了！" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "次のステップ:" -ForegroundColor Yellow
Write-Host "1. git log で履歴を確認してください" -ForegroundColor White
Write-Host "2. 問題なければ、force pushを実行してください:" -ForegroundColor White
Write-Host "   git push --force --all" -ForegroundColor Cyan
Write-Host ""
Write-Host "警告: force pushは危険です。チームで作業している場合は" -ForegroundColor Red
Write-Host "必ず全員に確認を取ってから実行してください。" -ForegroundColor Red
Write-Host ""
