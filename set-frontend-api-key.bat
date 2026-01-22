@echo off
echo ========================================
echo フロントエンドAPIキー設定スクリプト
echo ========================================
echo.

REM APIキーを環境変数から取得、またはユーザー入力で取得
if "%OPENAI_API_KEY%"=="" (
    echo OpenAI APIキーを入力してください:
    set /p API_KEY="API Key: "
) else (
    set API_KEY=%OPENAI_API_KEY%
    echo 環境変数 OPENAI_API_KEY からAPIキーを取得しました
)
echo.

cd frontend

REM .envファイルが存在しない場合は作成
if not exist .env (
    if exist env.example (
        copy env.example .env
        echo .envファイルを作成しました（env.exampleからコピー）
    ) else (
        echo VITE_OPENAI_API_KEY= > .env
        echo .envファイルを新規作成しました
    )
)

REM VITE_OPENAI_API_KEYが既に存在するか確認
findstr /C:"VITE_OPENAI_API_KEY" .env >nul 2>&1
if %errorlevel% equ 0 (
    echo VITE_OPENAI_API_KEYが既に存在します。更新します...
    powershell -Command "(Get-Content .env) -replace 'VITE_OPENAI_API_KEY=.*', 'VITE_OPENAI_API_KEY=%API_KEY%' | Set-Content .env"
) else (
    echo VITE_OPENAI_API_KEY=%API_KEY% >> .env
    echo VITE_OPENAI_API_KEYを追加しました
)

echo.
echo ========================================
echo 設定完了！
echo ========================================
echo.
echo 設定された環境変数:
echo - フロントエンド: frontend/.env の VITE_OPENAI_API_KEY
echo.
echo 注意: 
echo - .envファイルは.gitignoreに含まれているため、Gitにコミットされません
echo - 開発サーバーを再起動してください: npm run dev
echo - 本番環境では、Railwayの環境変数に設定してください
echo.
cd ..
pause
