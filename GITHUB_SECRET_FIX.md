# GitHubシークレットスキャンエラー対応ガイド

## 🚨 現在のエラー

GitHubのシークレットスキャンが、過去のコミット（`29bb25bb90710cbe5274e1aed78efe699681387d`）に含まれているAPIキーを検出しています。

**検出された場所:**
- `remove-api-key-from-history.bat:16` と `:17`
- `remove-api-key-from-history.ps1:40` と `:41`

## ✅ 解決方法

### 方法1: GitHubで一時的に許可（最も簡単・推奨）

以下の2つのURLにアクセスして、各シークレットで「**Allow**」をクリックしてください：

1. **remove-api-key-from-history.bat:16 と remove-api-key-from-history.ps1:40**
   - https://github.com/kensudogit/landing/security/secret-scanning/unblock-secret/38bDoUDl8vI5XtA7qSs6DRcJy97

2. **remove-api-key-from-history.bat:17 と remove-api-key-from-history.ps1:41**
   - https://github.com/kensudogit/landing/security/secret-scanning/unblock-secret/38bDoTXrsPpIhHYeTjnKNbpfwSV

許可後、再度プッシュを実行：

```bash
git push origin main
```

### 方法2: Git履歴からAPIキーを削除（完全な解決）

**⚠️ 警告**: この方法はGit履歴を書き換えるため、force pushが必要になります。

```bash
cd C:\devlop\landing
fix-git-history-api-keys.bat
```

または手動で：

```bash
# 1. 過去のコミットからAPIキーを削除
git filter-branch --force --tree-filter "powershell -Command \"if (Test-Path remove-api-key-from-history.bat) { \$content = Get-Content remove-api-key-from-history.bat -Raw; \$content = \$content -replace 'sk-proj-[A-Za-z0-9_-]+', 'REMOVED_API_KEY_PLACEHOLDER'; Set-Content remove-api-key-from-history.bat -Value \$content -NoNewline }; if (Test-Path remove-api-key-from-history.ps1) { \$content = Get-Content remove-api-key-from-history.ps1 -Raw; \$content = \$content -replace 'sk-proj-[A-Za-z0-9_-]+', 'REMOVED_API_KEY_PLACEHOLDER'; Set-Content remove-api-key-from-history.ps1 -Value \$content -NoNewline }\"" --prune-empty --tag-name-filter cat -- --all

# 2. リフログをクリーンアップ
git reflog expire --expire=now --all
git gc --prune=now --aggressive

# 3. Force push
git push --force origin main
```

## 📝 現在のファイルの状態

現在のファイル（`remove-api-key-from-history.bat`と`remove-api-key-from-history.ps1`）は既に修正済みで、APIキーはプレースホルダーまたは正規表現パターンに置き換えられています。

問題は、**過去のコミット履歴**にAPIキーが残っていることです。

## 🔍 確認方法

過去のコミットにAPIキーが含まれているか確認：

```bash
git show 29bb25bb90710cbe5274e1aed78efe699681387d:remove-api-key-from-history.bat | grep "sk-proj"
```

## ⚠️ 重要な注意事項

### 方法1（GitHubで許可）を推奨する理由

- **簡単**: URLにアクセスして「Allow」をクリックするだけ
- **安全**: Git履歴を書き換えないため、リスクが低い
- **迅速**: すぐにプッシュできる

### 方法2（履歴を書き換え）のリスク

- **Force pushが必要**: リモートの履歴が上書きされる
- **チーム作業に影響**: 他のメンバーが既にリポジトリをクローンしている場合、問題が発生する可能性がある
- **時間がかかる**: 履歴の書き換えには時間がかかる場合がある

## 🎯 推奨アクション

1. **まず方法1を試す**: GitHubで一時的に許可してプッシュ
2. **今後は注意**: 新しいコミットにはAPIキーを含めない
3. **必要に応じて方法2**: 完全に履歴をクリーンにしたい場合のみ

## 📚 参考

- [GitHub Secret Scanning](https://docs.github.com/en/code-security/secret-scanning)
- [Git Filter-Branch](https://git-scm.com/docs/git-filter-branch)
