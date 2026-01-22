# クイック修正ガイド - GitHubシークレットスキャンエラー

## 🚨 問題

GitHubへのプッシュ時に、シークレットスキャンがAPIキーを検出してブロックされています。

## ✅ 最も簡単な解決方法

### ステップ1: 現在の変更をコミット

```bash
cd C:\devlop\landing
git add set-openai-api-key.bat SETUP_OPENAI_API_KEY.md
git commit -m "Remove API keys from files (use environment variables instead)"
```

### ステップ2: 新しいクリーンな履歴で開始

```bash
# 現在のブランチをバックアップ（念のため）
git branch backup-before-clean

# 新しいオーファンブランチを作成（履歴なし）
git checkout --orphan clean-main

# すべてのファイルを追加
git add .

# 初回コミット
git commit -m "Initial commit: Remove API keys from history"

# 古いmainブランチを削除
git branch -D main

# 新しいブランチをmainにリネーム
git branch -m main

# Force push（⚠️ 警告: これで履歴が完全に書き換えられます）
git push --force origin main
```

### ステップ3: バックアップブランチを削除（オプション）

```bash
# ローカルのバックアップを削除
git branch -D backup-before-clean

# リモートのバックアップも削除する場合
git push origin --delete backup-before-clean
```

## ⚠️ 重要な注意事項

1. **Force pushは危険です**: チームで作業している場合は、必ず全員に確認を取ってから実行してください。
2. **履歴が失われます**: この方法では、以前のコミット履歴がすべて失われます。
3. **バックアップを推奨**: 念のため、バックアップブランチを作成することをお勧めします。

## 🔍 確認方法

プッシュ後、GitHubで以下を確認してください：

1. リポジトリの「Security」タブを開く
2. 「Secret scanning」セクションを確認
3. APIキーが検出されていないことを確認

## 📝 今後の対策

- ✅ `.env`ファイルは`.gitignore`に含まれている
- ✅ スクリプトは環境変数またはユーザー入力からAPIキーを取得するように修正済み
- ✅ ドキュメントからAPIキーを削除済み
- ✅ Git履歴からAPIキーを削除（今回の作業）

## 🔐 APIキーの設定方法

APIキーを設定するには、`set-openai-api-key.bat`スクリプトを実行してください：

```bash
cd C:\devlop\landing
set-openai-api-key.bat
```

スクリプト実行時にAPIキーの入力が求められます。
