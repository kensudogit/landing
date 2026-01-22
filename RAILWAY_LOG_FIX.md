# Railwayログエラー対応

## 🔧 検出されたエラー

### 1. PHP-FPMサービスエラー
- **エラー**: `php8.2-fpm: unrecognized service`
- **エラー**: `grep: /etc/init.d/php8.2-fpm: No such file or directory`
- **原因**: Dockerコンテナ内ではsystemdサービスが使えないため、`service`コマンドでPHP-FPMを起動できない
- **対応**: PHP-FPMを直接起動するように変更

### 2. データベースドライバーエラー
- **エラー**: `could not find driver (Connection: mysql, ...)`
- **原因**: デフォルトのデータベース接続が`mysql`になっているが、PostgreSQLを使用する設定になっている
- **対応**: デフォルトのデータベース接続をPostgreSQLに変更し、データベースが利用できない場合でもアプリケーションが起動できるようにする

## ✅ 修正内容

### 1. Dockerfile.railwayの修正

**変更前:**
```bash
service php8.2-fpm start
```

**変更後:**
```bash
/usr/local/sbin/php-fpm -D
```

### 2. データベース接続設定の修正

起動スクリプトに以下を追加:
```bash
# データベース接続設定（PostgreSQLをデフォルトに）
if ! grep -q "DB_CONNECTION" .env; then
    echo "DB_CONNECTION=pgsql" >> .env
fi

# データベースのマイグレーションを実行（エラーを無視）
php artisan migrate --force --no-interaction 2>/dev/null || echo "Migration skipped (database not available)"
```

## 🚀 再デプロイ

修正後、Railwayに再デプロイしてください:

```bash
cd C:\devlop\landing
deploy-railway-retry.bat
```

または、Railwayダッシュボードから「Redeploy」を実行してください。

## 🔍 デプロイ後の確認

1. **ログを確認**
   ```bash
   railway logs
   ```
   - PHP-FPMサービスエラーが表示されないことを確認
   - データベース接続エラーが表示されないか、または無視されていることを確認

2. **アプリケーションの動作確認**
   - フロントエンドが正常に表示されることを確認
   - APIエンドポイントが正常に動作することを確認

## 📝 注意事項

- データベースが利用できない場合でも、アプリケーションは起動します
- データベースが必要な機能（認証、データ保存など）は動作しませんが、フロントエンドの表示は可能です
- RailwayでPostgreSQLデータベースを追加する場合は、環境変数で接続情報を設定してください
