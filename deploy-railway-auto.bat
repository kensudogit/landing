@echo off
echo ========================================
echo Railway完全公開モードデプロイ（自動）
echo ========================================
echo.

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

echo.
echo [4/5] Railwayサービスを選択中...
echo 注意: サービスを選択するか、新規サービスを作成してください
railway service

echo.
echo [5/5] Railwayにデプロイ中...
railway up --detach

echo.
echo ========================================
echo デプロイ完了！
echo ========================================
echo.
echo 次のステップ:
echo 1. Railwayダッシュボードで以下を確認:
echo    - Settings ^> Network ^> Generate Domain を有効化
echo    - 公開ドメインが生成されているか確認
echo.
echo 2. 公開URLを確認:
echo    railway domain
echo.
echo 3. 環境変数を設定（必要に応じて）:
echo    railway variables set APP_KEY=base64:your-key
echo    railway variables set APP_ENV=production
echo    railway variables set APP_DEBUG=false
echo.
pause
