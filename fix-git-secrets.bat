@echo off
echo ========================================
echo Git履歴からAPIキーを削除するスクリプト
echo ========================================
echo.
echo このスクリプトは以下の作業を実行します:
echo 1. 現在の変更をコミット
echo 2. Git履歴からAPIキーを削除
echo 3. リフログをクリーンアップ
echo.
echo 警告: リモートにプッシュ済みの場合は、force pushが必要になります。
echo.
pause

echo.
echo PowerShellスクリプトを実行します...
powershell -ExecutionPolicy Bypass -File "%~dp0remove-api-key-from-history.ps1"

echo.
echo 完了しました。
echo.
echo 詳細は GIT_SECRET_REMOVAL.md を参照してください。
echo.
pause
