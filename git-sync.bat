@echo off
echo ========================================
echo Git同期スクリプト
echo ========================================
echo.

echo [1/4] リモートの変更を取得中...
git fetch origin
if %errorlevel% neq 0 (
    echo エラー: git fetchに失敗しました
    pause
    exit /b 1
)

echo.
echo [2/4] 現在の状態を確認中...
git status

echo.
echo [3/4] リモートとローカルの差分を確認中...
git log HEAD..origin/main --oneline
if %errorlevel% equ 0 (
    echo.
    echo リモートに新しいコミットがあります。
    echo.
    echo 選択してください:
    echo 1. リモートの変更をマージしてからプッシュ（推奨）
    echo 2. リベースしてからプッシュ
    echo 3. キャンセル
    echo.
    set /p choice="選択 (1/2/3): "
    
    if "%choice%"=="1" (
        echo.
        echo [4/4] リモートの変更をマージ中...
        git pull origin main --no-rebase
        if %errorlevel% neq 0 (
            echo エラー: マージに失敗しました。コンフリクトが発生している可能性があります。
            echo git status で確認してください。
            pause
            exit /b 1
        )
        echo.
        echo マージが完了しました。プッシュしますか？
        pause
        git push origin main
    ) else if "%choice%"=="2" (
        echo.
        echo [4/4] リベース中...
        git pull origin main --rebase
        if %errorlevel% neq 0 (
            echo エラー: リベースに失敗しました。コンフリクトが発生している可能性があります。
            echo git status で確認してください。
            pause
            exit /b 1
        )
        echo.
        echo リベースが完了しました。プッシュしますか？
        pause
        git push origin main
    ) else (
        echo キャンセルしました。
        pause
        exit /b 0
    )
) else (
    echo.
    echo リモートに新しいコミットはありません。
    echo [4/4] プッシュ中...
    git push origin main
)

echo.
echo ========================================
echo 完了！
echo ========================================
echo.
pause
