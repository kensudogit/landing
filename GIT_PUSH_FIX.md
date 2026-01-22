# Gitプッシュエラー対応ガイド

## 🚨 エラー内容

```
! [rejected]        main -> main (non-fast-forward)
error: failed to push some refs to 'https://github.com/kensudogit/landing.git'
```

このエラーは、リモートブランチがローカルブランチより進んでいる場合に発生します。

## ✅ 解決方法

### 方法1: 自動同期スクリプトを使用（推奨）

```bash
cd C:\devlop\landing
git-sync.bat
```

このスクリプトは以下を自動的に実行します：
1. リモートの変更を取得
2. 現在の状態を確認
3. リモートとローカルの差分を確認
4. マージまたはリベースを選択
5. プッシュ

### 方法2: 手動でマージしてプッシュ

```bash
cd C:\devlop\landing

# 1. リモートの変更を取得
git fetch origin

# 2. リモートの変更をマージ
git pull origin main --no-rebase

# 3. コンフリクトがあれば解決
# （コンフリクトが発生した場合）
git status
# コンフリクトファイルを編集
git add .
git commit -m "Merge remote changes"

# 4. プッシュ
git push origin main
```

### 方法3: リベースしてプッシュ

```bash
cd C:\devlop\landing

# 1. リモートの変更を取得
git fetch origin

# 2. リベース
git pull origin main --rebase

# 3. コンフリクトがあれば解決
# （コンフリクトが発生した場合）
git status
# コンフリクトファイルを編集
git add .
git rebase --continue

# 4. プッシュ
git push origin main
```

## ⚠️ 重要な注意事項

### Force Pushは避ける

**絶対に実行しないでください**（チームで作業している場合）:

```bash
# ❌ 危険: これでリモートの履歴が上書きされます
git push --force origin main
```

Force pushは、リモートの履歴を完全に上書きするため、他のメンバーの作業に影響を与える可能性があります。

### コンフリクトが発生した場合

1. **コンフリクトファイルを確認**
   ```bash
   git status
   ```

2. **コンフリクトを解決**
   - エディタでコンフリクトファイルを開く
   - `<<<<<<<`, `=======`, `>>>>>>>` マーカーを探す
   - 必要な変更を残してマーカーを削除

3. **変更をステージング**
   ```bash
   git add .
   ```

4. **マージまたはリベースを続行**
   ```bash
   # マージの場合
   git commit -m "Resolve merge conflicts"
   
   # リベースの場合
   git rebase --continue
   ```

## 🔍 状況確認コマンド

### 現在の状態を確認

```bash
git status
```

### リモートとローカルの差分を確認

```bash
# リモートにのみあるコミット
git log HEAD..origin/main --oneline

# ローカルにのみあるコミット
git log origin/main..HEAD --oneline

# 両方の差分
git log --left-right --oneline HEAD...origin/main
```

### リモートの状態を確認

```bash
git fetch origin
git log origin/main --oneline -5
```

## 📝 今後の対策

### プッシュ前に必ずpullする

```bash
# 推奨ワークフロー
git pull origin main
git push origin main
```

### 定期的に同期する

```bash
# 毎日の作業開始前に
git fetch origin
git pull origin main
```

## 🐛 トラブルシューティング

### マージコンフリクトが解決できない場合

1. **変更を一時的に保存**
   ```bash
   git stash
   ```

2. **リモートの変更を取得**
   ```bash
   git pull origin main
   ```

3. **保存した変更を適用**
   ```bash
   git stash pop
   ```

4. **コンフリクトを解決してからプッシュ**

### リモートの変更を破棄したい場合（注意）

**⚠️ 警告**: これはリモートの変更を完全に失います。チームで作業している場合は絶対に実行しないでください。

```bash
# リモートの変更を無視してローカルの変更を強制プッシュ
git push --force origin main
```

## 📚 参考

- [Git Pull Documentation](https://git-scm.com/docs/git-pull)
- [Git Merge vs Rebase](https://www.atlassian.com/git/tutorials/merging-vs-rebasing)
- [Resolving Merge Conflicts](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/addressing-merge-conflicts)
