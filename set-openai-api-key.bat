@echo off
echo ========================================
echo OpenAI APIキー設定スクリプト
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

echo [1/3] フロントエンドの.envファイルを設定中...
cd frontend
if not exist .env (
    copy env.example .env
    echo .envファイルを作成しました
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
cd ..

echo.
echo [2/3] バックエンドの.envファイルを設定中...
cd backend
if not exist .env (
    if exist .env.example (
        copy .env.example .env
        echo .envファイルを作成しました
    ) else (
        echo APP_KEY=base64: > .env
        echo APP_ENV=local >> .env
        echo APP_DEBUG=true >> .env
        echo .envファイルを新規作成しました
    )
)

REM OPENAI_API_KEYが既に存在するか確認
findstr /C:"OPENAI_API_KEY" .env >nul 2>&1
if %errorlevel% equ 0 (
    echo OPENAI_API_KEYが既に存在します。更新します...
    powershell -Command "(Get-Content .env) -replace 'OPENAI_API_KEY=.*', 'OPENAI_API_KEY=%API_KEY%' | Set-Content .env"
) else (
    echo. >> .env
    echo # OpenAI API設定 >> .env
    echo OPENAI_API_KEY=%API_KEY% >> .env
    echo OPENAI_API_KEYを追加しました
)
cd ..

echo.
echo [3/3] Railway環境変数を設定中...
echo Railway CLIを使用して環境変数を設定します...
echo.
echo フロントエンド用（VITE_OPENAI_API_KEY）:
railway variables set VITE_OPENAI_API_KEY=%API_KEY%
echo.
echo バックエンド用（OPENAI_API_KEY）:
railway variables set OPENAI_API_KEY=%API_KEY%

echo.
echo ========================================
echo 設定完了！
echo ========================================
echo.
echo 設定された環境変数:
echo - フロントエンド: frontend/.env の VITE_OPENAI_API_KEY
echo - バックエンド: backend/.env の OPENAI_API_KEY
echo - Railway: VITE_OPENAI_API_KEY と OPENAI_API_KEY
echo.
echo 注意: .envファイルは.gitignoreに含まれているため、Gitにコミットされません。
echo.
pause
