# Railway環境変数設定ガイド

## 🔐 環境変数の設定方法

Railwayでは、環境変数がビルド時と実行時の両方で利用可能になります。Viteはビルド時に環境変数を埋め込むため、Railwayの環境変数を正しく設定する必要があります。

## 📝 必要な環境変数

### フロントエンド用（ビルド時に必要）

1. **VITE_OPENAI_API_KEY**
   - OpenAI APIキー
   - Railwayダッシュボードの「Variables」タブで設定
   - ビルド時にフロントエンドのコードに埋め込まれます

2. **VITE_API_URL**（オプション）
   - バックエンドAPIのURL
   - デフォルト: `http://localhost:8000`

3. **VITE_ENVIRONMENT**（オプション）
   - 環境名（production, developmentなど）

### バックエンド用（実行時に必要）

1. **OPENAI_API_KEY**
   - OpenAI APIキー（バックエンドで使用）
   - Railwayダッシュボードの「Variables」タブで設定

## 🚀 Railwayでの設定手順

### 方法1: Railwayダッシュボードから設定（推奨）

1. https://railway.app にアクセス
2. プロジェクト「landing」を開く
3. サービスを選択
4. 「Variables」タブを開く
5. 「+ New Variable」をクリック
6. 以下を追加：

   **フロントエンド用:**
   - Name: `VITE_OPENAI_API_KEY`
   - Value: `sk-proj-...`（実際のAPIキー）

   **バックエンド用:**
   - Name: `OPENAI_API_KEY`
   - Value: `sk-proj-...`（実際のAPIキー）

7. 「Add」をクリック
8. Railwayが自動的に再デプロイを開始します

### 方法2: Railway CLIから設定

```bash
cd C:\devlop\landing

# フロントエンド用（ビルド時に使用）
railway variables set VITE_OPENAI_API_KEY=sk-proj-...

# バックエンド用（実行時に使用）
railway variables set OPENAI_API_KEY=sk-proj-...
```

## 🔍 確認方法

### ビルドログで確認

Railwayのデプロイログで、以下のように環境変数がビルド時に利用されていることを確認できます：

```
[frontend-builder] Building frontend...
[frontend-builder] VITE_OPENAI_API_KEY is set
```

### 実行時の確認

デプロイ後、ブラウザのコンソールで以下を確認：

```javascript
console.log(import.meta.env.VITE_OPENAI_API_KEY)
```

APIキーが表示されれば成功です。

## ⚠️ 重要な注意事項

1. **ビルド時の環境変数**: `VITE_`プレフィックスを持つ環境変数は、ビルド時にフロントエンドのコードに埋め込まれます。ビルド後に変更しても反映されません。

2. **再デプロイが必要**: 環境変数を変更した場合、Railwayが自動的に再デプロイを開始します。再デプロイが完了するまで待ってください。

3. **セキュリティ**: APIキーは機密情報です。Gitにコミットしないでください。`.env`ファイルは`.gitignore`に含まれています。

## 🐛 トラブルシューティング

### APIキーが未設定と表示される場合

1. **環境変数が設定されているか確認**
   ```bash
   railway variables
   ```

2. **再デプロイを実行**
   - Railwayダッシュボードで「Redeploy」をクリック
   - または、新しいコミットをプッシュ

3. **ビルドログを確認**
   - Railwayダッシュボードの「Deployments」タブでビルドログを確認
   - 環境変数がビルド時に利用されているか確認

### ビルド時に環境変数が利用できない場合

`Dockerfile.railway`で`ARG`と`ENV`が正しく設定されているか確認してください：

```dockerfile
ARG VITE_OPENAI_API_KEY
ENV VITE_OPENAI_API_KEY=${VITE_OPENAI_API_KEY}
```

## 📚 参考

- [Railway Environment Variables](https://docs.railway.app/develop/variables)
- [Vite Environment Variables](https://vitejs.dev/guide/env-and-mode.html)
- [Docker Build Arguments](https://docs.docker.com/engine/reference/builder/#arg)
