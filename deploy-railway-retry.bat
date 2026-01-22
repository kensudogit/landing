@echo off
setlocal enabledelayedexpansion

echo ========================================
echo Railway完全公開モードデプロイ（リトライ対応）
echo ========================================
echo.

set MAX_RETRIES=3
set RETRY_DELAY=10
set RETRY_COUNT=0

echo [1/5] Railwayログイン状態を確認中...
railway whoami
if %errorlevel% neq 0 (
    echo Railwayにログインしてください: railway login
    pause
    exit /b 1
)

echo.
echo [2/5] フロントエンドをビルド中...
cd frontend
call npm run build
if %errorlevel% neq 0 (
    echo ビルドエラーが発生しました
    pause
    exit /b 1
)
cd ..

echo.
echo [3/5] Railwayプロジェクトをリンク中...
echo 注意: プロジェクトを選択するか、新規プロジェクトを作成してください
railway link
if %errorlevel% neq 0 (
    echo プロジェクトのリンクに失敗しました
    pause
    exit /b 1
)

echo.
echo [4/5] Railwayサービスを選択中...
echo 注意: サービスを選択するか、新規サービスを作成してください
railway service
if %errorlevel% neq 0 (
    echo サービスの選択に失敗しました
    pause
    exit /b 1
)

echo.
echo [5/5] Railwayにデプロイ中（リトライ機能付き）...
:deploy_retry
set /a RETRY_COUNT+=1
echo.
echo デプロイ試行: !RETRY_COUNT!/%MAX_RETRIES%

railway up --detach
set DEPLOY_EXIT_CODE=%errorlevel%

if %DEPLOY_EXIT_CODE% equ 0 (
    echo.
    echo ========================================
    echo デプロイ成功！
    echo ========================================
    goto deploy_success
)

if !RETRY_COUNT! lss %MAX_RETRIES% (
    echo.
    echo デプロイがタイムアウトまたは失敗しました（エラーコード: %DEPLOY_EXIT_CODE%）
    echo %RETRY_DELAY%秒後に再試行します...
    timeout /t %RETRY_DELAY% /nobreak >nul
    goto deploy_retry
) else (
    echo.
    echo ========================================
    echo デプロイ失敗: 最大リトライ回数（%MAX_RETRIES%回）に達しました
    echo ========================================
    echo.
    echo 対処方法:
    echo 1. ネットワーク接続を確認してください
    echo 2. Railwayダッシュボードで手動デプロイを試してください
    echo 3. Railway CLIのバージョンを確認: railway --version
    echo 4. Railwayのステータスを確認: https://status.railway.app
    echo.
    pause
    exit /b 1
)

:deploy_success
echo.
echo 次のステップ:
echo 1. Railwayダッシュボードで以下を確認:
echo    - Settings ^> Network ^> Generate Domain を有効化
echo    - 公開ドメインが生成されているか確認
echo    - デプロイメントのステータスを確認
echo.
echo 2. 公開URLを確認:
echo    railway domain
echo.
echo 3. ログを確認（必要に応じて）:
echo    railway logs
echo.
echo 4. 環境変数を設定（必要に応じて）:
echo    railway variables set APP_KEY=base64:your-key
echo    railway variables set APP_ENV=production
echo    railway variables set APP_DEBUG=false
echo.
pause
endlocal
