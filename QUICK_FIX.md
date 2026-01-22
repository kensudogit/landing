# クイック修正ガイド - GitHubシークレットスキャンエラー

## 🚨 問題

GitHubへのプッシュ時に、シークレットスキャンがAPIキーを検出してブロックされています。

## ✅ 最も簡単な解決方法

### ステップ1: 現在の変更をコミット

```bash
cd C:\devlop\landing
git add .
git commit -m "Resolve merge conflicts and remove API keys from scripts"
```

### ステップ2: GitHubで一時的に許可（推奨）

GitHubのエラーメッセージに表示されているURLにアクセスして、シークレットで「**Allow**」をクリックしてください。

### ステップ3: プッシュ

```bash
git push origin main
```

## 📝 今後の対策

- ✅ `.env`ファイルは`.gitignore`に含まれている
- ✅ スクリプトは環境変数またはユーザー入力からAPIキーを取得するように修正済み
- ✅ ドキュメントからAPIキーを削除済み
- ✅ スクリプトファイルからAPIキーを削除済み（正規表現パターンを使用）

## 🔐 APIキーの設定方法

APIキーを設定するには、`set-openai-api-key.bat`スクリプトを実行してください：

```bash
cd C:\devlop\landing
set-openai-api-key.bat
```

スクリプト実行時にAPIキーの入力が求められます。
