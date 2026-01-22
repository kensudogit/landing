# Railway再デプロイ手順（フロントエンド統合版）

## 🔄 変更内容

- フロントエンドとバックエンドを統合したDockerfileに変更
- Nginxを使用してフロントエンドの静的ファイルとAPIを配信
- ルートパス（/）でフロントエンドを表示
- /api/* でバックエンドAPIにアクセス

## 🚀 再デプロイ手順

### 方法1: Railway CLIから再デプロイ

```bash
cd C:\devlop\landing

# Railwayにログイン確認
railway whoami

# プロジェクトがリンクされているか確認
railway status

# 再デプロイ
railway up --detach
```

### 方法2: Railwayダッシュボードから

1. https://railway.app にアクセス
2. プロジェクト「landing」を開く
3. サービスを選択
4. 「Deployments」タブで「Redeploy」をクリック
5. または、GitHubリポジトリにプッシュすると自動デプロイされます

## ✅ デプロイ後の確認

1. **公開URLにアクセス**
   - `landing-production-69b3.up.railway.app` にアクセス
   - フロントエンドのサービス画面が表示されることを確認

2. **APIエンドポイントの確認**
   - `landing-production-69b3.up.railway.app/api/test` にアクセス
   - APIのJSONレスポンスが返ることを確認

3. **ログの確認**
   ```bash
   railway logs
   ```

## 🐛 トラブルシューティング

### フロントエンドが表示されない場合

1. **ビルドが成功しているか確認**
   - Railwayダッシュボードの「Deployments」タブでビルドログを確認
   - フロントエンドのビルドエラーがないか確認

2. **Nginx設定を確認**
   - `/var/www/html/public/frontend` にフロントエンドファイルが存在するか確認
   - Nginxのログを確認: `railway logs`

3. **ポート設定を確認**
   - RailwayのPORT環境変数が8000に設定されているか確認
   - `railway variables` で確認

### APIが動作しない場合

1. **Laravelの設定を確認**
   - `.env`ファイルが正しく設定されているか確認
   - `APP_KEY`が設定されているか確認

2. **データベース接続を確認**
   - PostgreSQLが正しく接続されているか確認
   - 環境変数 `DB_*` が正しく設定されているか確認

## 📝 環境変数の設定

必要に応じて以下の環境変数を設定:

```bash
railway variables set APP_ENV=production
railway variables set APP_DEBUG=false
railway variables set APP_KEY=base64:your-generated-key
```

データベースを使用する場合:

```bash
railway variables set DB_CONNECTION=pgsql
railway variables set DB_HOST=${{Postgres.PGHOST}}
railway variables set DB_PORT=${{Postgres.PGPORT}}
railway variables set DB_DATABASE=${{Postgres.PGDATABASE}}
railway variables set DB_USERNAME=${{Postgres.PGUSER}}
railway variables set DB_PASSWORD=${{Postgres.PGPASSWORD}}
```
