@echo off
echo ========================================
echo Git履歴からAPIキーを削除するスクリプト
echo ========================================
echo.
echo 警告: このスクリプトはGit履歴を書き換えます。
echo リモートにプッシュ済みの場合は、force pushが必要になります。
echo.
pause

echo.
echo [1/3] 古いAPIキーを検索中...
echo.

REM 検出されたAPIキー（過去のコミットに含まれている可能性があるもの）
REM 注意: APIキーは環境変数から取得するか、ユーザー入力で取得してください
set OLD_KEY1=REMOVED_API_KEY_PLACEHOLDER
set OLD_KEY2=REMOVED_API_KEY_PLACEHOLDER

echo [2/3] Git履歴を書き換え中...
echo これには時間がかかる場合があります...
echo.

REM git filter-branchを使用して履歴を書き換え
git filter-branch --force --index-filter "git rm --cached --ignore-unmatch set-openai-api-key.bat SETUP_OPENAI_API_KEY.md 2>nul || true" --prune-empty --tag-name-filter cat -- --all

REM 特定のファイルの内容を置き換え
git filter-branch --force --tree-filter "powershell -Command \"if (Test-Path set-openai-api-key.bat) { (Get-Content set-openai-api-key.bat) -replace '%OLD_KEY1%', 'REMOVED_API_KEY' -replace '%OLD_KEY2%', 'REMOVED_API_KEY' | Set-Content set-openai-api-key.bat }; if (Test-Path SETUP_OPENAI_API_KEY.md) { (Get-Content SETUP_OPENAI_API_KEY.md) -replace '%OLD_KEY1%', 'your-openai-api-key-here' -replace '%OLD_KEY2%', 'your-openai-api-key-here' | Set-Content SETUP_OPENAI_API_KEY.md }\"" --prune-empty --tag-name-filter cat -- --all

echo.
echo [3/3] リフログをクリーンアップ中...
git reflog expire --expire=now --all
git gc --prune=now --aggressive

echo.
echo ========================================
echo 完了！
echo ========================================
echo.
echo 次のステップ:
echo 1. git log で履歴を確認してください
echo 2. 問題なければ、force pushを実行してください:
echo    git push --force --all
echo.
echo 警告: force pushは危険です。チームで作業している場合は
echo 必ず全員に確認を取ってから実行してください。
echo.
pause
