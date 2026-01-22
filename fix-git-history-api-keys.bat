@echo off
echo ========================================
echo Git履歴からAPIキーを削除するスクリプト
echo ========================================
echo.
echo 警告: このスクリプトはGit履歴を書き換えます。
echo 過去のコミット（29bb25bb90710cbe5274e1aed78efe699681387d）から
echo APIキーを削除します。
echo.
pause

echo.
echo [1/4] 現在の変更をコミット中...
git add remove-api-key-from-history.bat remove-api-key-from-history.ps1
git commit -m "Remove API keys from history cleanup scripts" 2>nul || echo "変更がないか、既にコミット済みです"

echo.
echo [2/4] 過去のコミットからAPIキーを削除中...
echo これには時間がかかる場合があります...
echo.

REM 過去のコミットのファイルを修正するために、git filter-branchを使用
REM 正規表現でAPIキーを検索・置換
powershell -Command "$script = 'if (Test-Path remove-api-key-from-history.bat) { $content = Get-Content remove-api-key-from-history.bat -Raw; $content = $content -replace ''sk-proj-[A-Za-z0-9_-]+'', ''REMOVED_API_KEY_PLACEHOLDER''; Set-Content remove-api-key-from-history.bat -Value $content -NoNewline }; if (Test-Path remove-api-key-from-history.ps1) { $content = Get-Content remove-api-key-from-history.ps1 -Raw; $content = $content -replace ''sk-proj-[A-Za-z0-9_-]+'', ''REMOVED_API_KEY_PLACEHOLDER''; Set-Content remove-api-key-from-history.ps1 -Value $content -NoNewline }'; git filter-branch --force --tree-filter $script --prune-empty --tag-name-filter cat -- --all"

if %errorlevel% neq 0 (
    echo.
    echo ⚠️ filter-branchが失敗しました。
    echo 別の方法を試します...
    echo.
    echo 方法1: GitHubで一時的に許可する（推奨）
    echo 以下のURLにアクセスして「Allow」をクリックしてください:
    echo https://github.com/kensudogit/landing/security/secret-scanning/unblock-secret/38bDoUDl8vI5XtA7qSs6DRcJy97
    echo https://github.com/kensudogit/landing/security/secret-scanning/unblock-secret/38bDoTXrsPpIhHYeTjnKNbpfwSV
    echo.
    pause
    exit /b 1
)

echo.
echo [3/4] リフログをクリーンアップ中...
git reflog expire --expire=now --all
git gc --prune=now --aggressive

echo.
echo [4/4] Force pushを実行しますか？
echo ⚠️ 警告: これでリモートの履歴が上書きされます。
echo.
set /p confirm="Force pushを実行しますか？ (y/N): "

if /i "%confirm%"=="y" (
    echo.
    echo Force pushを実行中...
    git push --force origin main
    
    if %errorlevel% neq 0 (
        echo.
        echo ⚠️ Force pushが失敗しました。
        echo GitHubで一時的に許可する方法を試してください。
    ) else (
        echo.
        echo ========================================
        echo 完了！
        echo ========================================
    )
) else (
    echo.
    echo Force pushをスキップしました。
    echo.
    echo 次のステップ:
    echo 1. GitHubで一時的に許可する（推奨）:
    echo    https://github.com/kensudogit/landing/security/secret-scanning/unblock-secret/38bDoUDl8vI5XtA7qSs6DRcJy97
    echo    https://github.com/kensudogit/landing/security/secret-scanning/unblock-secret/38bDoTXrsPpIhHYeTjnKNbpfwSV
    echo.
    echo 2. その後、通常のプッシュを実行:
    echo    git push origin main
)

echo.
pause
