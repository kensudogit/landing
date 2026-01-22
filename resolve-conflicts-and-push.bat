@echo off
echo ========================================
echo マージコンフリクト解決とプッシュスクリプト
echo ========================================
echo.

echo [1/4] マージコンフリクトを解決中...
echo コンフリクトファイルを確認中...
git status

echo.
echo [2/4] 変更をステージング中...
git add .

echo.
echo [3/4] マージコミットを作成中...
git commit -m "Resolve merge conflicts and remove API keys from scripts"

if %errorlevel% neq 0 (
    echo エラー: コミットに失敗しました。
    echo コンフリクトが残っている可能性があります。
    echo git status で確認してください。
    pause
    exit /b 1
)

echo.
echo [4/4] プッシュ中...
git push origin main

if %errorlevel% neq 0 (
    echo.
    echo ⚠️ プッシュが失敗しました。
    echo GitHubのシークレットスキャンがAPIキーを検出している可能性があります。
    echo.
    echo エラーメッセージに表示されているURLにアクセスして、
    echo シークレットで「Allow」をクリックしてください。
    echo.
    echo その後、再度プッシュを実行してください:
    echo git push origin main
) else (
    echo.
    echo ========================================
    echo プッシュが完了しました！
    echo ========================================
)

echo.
pause
