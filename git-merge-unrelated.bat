@echo off
echo ========================================
echo Git unrelated histories 対応スクリプト
echo ========================================
echo.
echo エラー: refusing to merge unrelated histories
echo.
echo このエラーは、ローカルとリモートのGit履歴が完全に異なる場合に発生します。
echo 以前にGit履歴を書き換えた可能性があります。
echo.
echo 選択してください:
echo 1. リモートの履歴を許可してマージ（推奨）
echo 2. ローカルの履歴でリモートを上書き（注意: リモートの変更が失われます）
echo 3. キャンセル
echo.
set /p choice="選択 (1/2/3): "

if "%choice%"=="1" (
    echo.
    echo [1/2] リモートの履歴を許可してマージ中...
    git pull origin main --no-rebase --allow-unrelated-histories
    if %errorlevel% neq 0 (
        echo エラー: マージに失敗しました。コンフリクトが発生している可能性があります。
        echo git status で確認してください。
        pause
        exit /b 1
    )
    echo.
    echo [2/2] プッシュ中...
    git push origin main
    echo.
    echo マージが完了しました。
) else if "%choice%"=="2" (
    echo.
    echo ⚠️ 警告: これでリモートの履歴が完全に上書きされます。
    echo リモートの変更はすべて失われます。
    echo.
    set /p confirm="本当に実行しますか？ (yes/no): "
    if /i "%confirm%"=="yes" (
        echo.
        echo [1/2] ローカルの履歴でリモートを上書き中...
        git push --force origin main
        if %errorlevel% neq 0 (
            echo エラー: プッシュに失敗しました。
            pause
            exit /b 1
        )
        echo.
        echo リモートの履歴が上書きされました。
    ) else (
        echo キャンセルしました。
    )
) else (
    echo キャンセルしました。
)

echo.
echo ========================================
echo 完了！
echo ========================================
echo.
pause
