@echo off
echo ========================================
echo 変更をコミットしてプッシュするスクリプト
echo ========================================
echo.

echo [1/4] 現在の状態を確認中...
git status

echo.
echo [2/4] すべての変更をステージング中...
git add .

if %errorlevel% neq 0 (
    echo エラー: ステージングに失敗しました。
    pause
    exit /b 1
)

echo.
echo [3/4] コミット中...
git commit -m "Resolve merge conflicts and remove API keys from scripts"

if %errorlevel% neq 0 (
    echo エラー: コミットに失敗しました。
    echo コミットする変更がない可能性があります。
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
    echo.
    echo 考えられる原因:
    echo 1. GitHubのシークレットスキャンがAPIキーを検出している
    echo 2. リモートブランチがローカルより進んでいる
    echo.
    echo エラーメッセージを確認してください。
    echo.
    echo GitHubのシークレットスキャンエラーの場合:
    echo - エラーメッセージに表示されているURLにアクセス
    echo - シークレットで「Allow」をクリック
    echo - 再度プッシュを実行: git push origin main
    echo.
    echo unrelated historiesエラーの場合:
    echo - git-merge-unrelated.bat を実行してください
) else (
    echo.
    echo ========================================
    echo プッシュが完了しました！
    echo ========================================
)

echo.
pause
