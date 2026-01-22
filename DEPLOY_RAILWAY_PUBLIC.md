# Railway完全公開モードデプロイ手順

## 🚀 デプロイ手順

### 方法1: Railwayダッシュボードからデプロイ（推奨）

1. **Railwayにログイン**
   - https://railway.app にアクセス
   - GitHubアカウントでログイン

2. **新しいプロジェクトを作成**
   - 「New Project」をクリック
   - 「Deploy from GitHub repo」を選択
   - リポジトリを選択（または新規作成）

3. **サービスを追加**
   - 「+ New」→「GitHub Repo」を選択
   - リポジトリを選択
   - Railwayが自動的に`railway.toml`を検出

4. **完全公開モードを有効化**
   - サービスを選択
   - 「Settings」タブを開く
   - 「Network」セクションで以下を設定:
     - ✅ **Generate Domain** を有効化
     - ✅ **Public** を有効化
   - 公開ドメインが自動生成されます

5. **環境変数の設定**
   - 「Variables」タブを開く
   - 以下の環境変数を追加:

   **必須環境変数:**
   ```
   APP_ENV=production
   APP_DEBUG=false
   APP_KEY=base64:your-generated-key
   ```

   **データベース環境変数（PostgreSQL使用時）:**
   ```
   DB_CONNECTION=pgsql
   DB_HOST=${{Postgres.PGHOST}}
   DB_PORT=${{Postgres.PGPORT}}
   DB_DATABASE=${{Postgres.PGDATABASE}}
   DB_USERNAME=${{Postgres.PGUSER}}
   DB_PASSWORD=${{Postgres.PGPASSWORD}}
   ```

6. **PostgreSQLデータベースの追加（オプション）**
   - 「+ New」→「Database」→「Add PostgreSQL」を選択
   - Railwayが自動的にPostgreSQLインスタンスを作成
   - 接続情報は自動的に環境変数に設定されます

7. **デプロイ**
   - Railwayが自動的にデプロイを開始します
   - 「Deployments」タブで進行状況を確認

8. **公開URLの確認**
   - 「Settings」→「Network」で公開ドメインを確認
   - または「Domains」タブで確認

### 方法2: Railway CLIからデプロイ

```bash
# 1. Railwayにログイン
railway login

# 2. プロジェクトをリンク（対話的に選択）
railway link

# 3. サービスを選択（対話的に選択）
railway service

# 4. 環境変数を設定
railway variables set APP_ENV=production
railway variables set APP_DEBUG=false
railway variables set APP_KEY=base64:$(openssl rand -base64 32)

# 5. デプロイ
railway up --detach

# 6. 公開ドメインを生成（Railwayダッシュボードで設定）
# Settings > Network > Generate Domain を有効化

# 7. 公開URLを確認
railway domain
```

## ⚙️ Railway設定ファイル

プロジェクトには以下の設定ファイルが含まれています:

- `railway.toml`: Railway設定（公開モード有効）
- `railway.json`: Railway設定（JSON形式）
- `Dockerfile.railway`: Railway用Dockerfile

### railway.toml の設定

```toml
[build]
builder = "DOCKERFILE"
dockerfilePath = "Dockerfile.railway"

[deploy]
startCommand = ""
restartPolicyType = "ON_FAILURE"
restartPolicyMaxRetries = 10

[network]
public = true      # 完全公開モード
port = 8000        # ポート番号
```

## 🔧 環境変数の詳細

### Laravelアプリケーションキーの生成

```bash
# ローカルで生成
php artisan key:generate --show

# Railway CLIで設定
railway variables set APP_KEY=base64:your-generated-key
```

### データベース接続

Railway PostgreSQLを使用する場合、環境変数は以下の形式で参照します:

```
DB_HOST=${{Postgres.PGHOST}}
DB_PORT=${{Postgres.PGPORT}}
DB_DATABASE=${{Postgres.PGDATABASE}}
DB_USERNAME=${{Postgres.PGUSER}}
DB_PASSWORD=${{Postgres.PGPASSWORD}}
```

## 📝 デプロイ後の確認事項

1. ✅ デプロイが成功しているか（Deploymentsタブで確認）
2. ✅ 公開ドメインが生成されているか（Settings > Networkで確認）
3. ✅ 環境変数が正しく設定されているか（Variablesタブで確認）
4. ✅ アプリケーションが正常に動作しているか（公開URLで確認）
5. ✅ ログにエラーがないか（Logsタブで確認）

## 🐛 トラブルシューティング

### デプロイが失敗する場合

1. **ログを確認**
   ```bash
   railway logs
   ```

2. **Dockerfileを確認**
   - `Dockerfile.railway`が正しく設定されているか確認
   - ビルドエラーがないか確認

3. **環境変数を確認**
   ```bash
   railway variables
   ```

### 公開URLが表示されない場合

1. **Network設定を確認**
   - Settings > Network > Generate Domain が有効になっているか確認
   - Public が有効になっているか確認

2. **railway.tomlを確認**
   - `[network]`セクションに`public = true`が設定されているか確認

### アプリケーションにアクセスできない場合

1. **ポート設定を確認**
   - RailwayのPORT環境変数と一致しているか確認
   - `Dockerfile.railway`のEXPOSEポートを確認

2. **環境変数を確認**
   - `APP_URL`が正しく設定されているか確認

## 📚 参考リンク

- [Railway Documentation](https://docs.railway.app/)
- [Railway CLI Reference](https://docs.railway.app/develop/cli)
- [Railway Environment Variables](https://docs.railway.app/develop/variables)
