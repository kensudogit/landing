# Git履歴からAPIキーを削除する方法

## 🚨 問題

GitHubのシークレットスキャンがAPIキーを検出し、プッシュがブロックされています。過去のコミット履歴にAPIキーが含まれているため、現在のファイルを修正しても履歴には残っています。

## ✅ 解決方法

### 方法1: 簡単な手動修正（推奨・最も安全）

#### ステップ1: 現在の変更をコミット

```bash
cd C:\devlop\landing
git add set-openai-api-key.bat SETUP_OPENAI_API_KEY.md
git commit -m "Remove API keys from files (use environment variables instead)"
```

#### ステップ2: 新しいブランチを作成して履歴を修正

```bash
# 新しいブランチを作成
git checkout --orphan clean-history

# 現在のファイルを追加
git add .
git commit -m "Initial commit without API keys"

# メインブランチを削除して置き換え
git branch -D main
git branch -m main

# Force push（⚠️ 注意: これで履歴が完全に書き換えられます）
git push --force origin main
```

### 方法2: Git履歴を書き換える（上級者向け）

#### ステップ1: 現在の変更をコミット

```bash
cd C:\devlop\landing
git add set-openai-api-key.bat SETUP_OPENAI_API_KEY.md
git commit -m "Remove API keys from files (use environment variables instead)"
```

#### ステップ2: Git履歴からAPIキーを削除

**オプションA: BFG Repo-Cleanerを使用（推奨、高速）**

1. BFGをダウンロード: https://rtyley.github.io/bfg-repo-cleaner/
2. 以下のコマンドを実行:

```bash
# BFGを使用してAPIキーを削除
java -jar bfg.jar --replace-text passwords.txt

# passwords.txtファイルを作成し、削除したいAPIキーを記載:
# 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==>REMOVED_API_KEY
# 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==>REMOVED_API_KEY

git reflog expire --expire=now --all
git gc --prune=now --aggressive
```

**オプションB: git filter-branchを使用**

```bash
# 特定のファイルを履歴から削除
git filter-branch --force --index-filter "git rm --cached --ignore-unmatch set-openai-api-key.bat SETUP_OPENAI_API_KEY.md" --prune-empty --tag-name-filter cat -- --all

# または、ファイルの内容を置き換え
git filter-branch --force --tree-filter "powershell -Command \"if (Test-Path set-openai-api-key.bat) { (Get-Content set-openai-api-key.bat) -replace 'sk-proj-.*', 'REMOVED_API_KEY' | Set-Content set-openai-api-key.bat }\" --prune-empty --tag-name-filter cat -- --all

git reflog expire --expire=now --all
git gc --prune=now --aggressive
```

#### ステップ3: Force Push

```bash
git push --force --all
git push --force --tags
```

⚠️ **警告**: Force pushは危険です。チームで作業している場合は、必ず全員に確認を取ってから実行してください。

### 方法2: GitHubの許可URLを使用（一時的な解決策）

GitHubのエラーメッセージに表示されているURLを使用して、一時的に許可することもできますが、**推奨されません**。履歴にAPIキーが残り続けるため、セキュリティリスクがあります。

## 🔍 確認方法

履歴からAPIキーが削除されたか確認:

```bash
git log --all --full-history -- set-openai-api-key.bat SETUP_OPENAI_API_KEY.md | grep -i "sk-proj"
```

何も表示されなければ成功です。

## 📝 今後の対策

1. ✅ `.env`ファイルは`.gitignore`に含まれている
2. ✅ スクリプトは環境変数またはユーザー入力からAPIキーを取得するように修正済み
3. ✅ ドキュメントからAPIキーを削除済み
4. ⚠️ Git履歴からAPIキーを削除する必要がある（今回の作業）

## 🔐 セキュリティベストプラクティス

- APIキーは環境変数として管理する
- `.env`ファイルをGitにコミットしない
- コード内にAPIキーを直接書かない
- 公開リポジトリにプッシュする前にシークレットスキャンを実行する
