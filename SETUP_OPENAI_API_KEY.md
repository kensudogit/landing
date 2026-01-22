# OpenAI APIキー設定ガイド

## 🔐 セキュリティ重要事項

⚠️ **APIキーは機密情報です。以下の点に注意してください：**
- コード内に直接書かない
- Gitにコミットしない（.gitignoreに含まれています）
- 公開リポジトリにプッシュしない
- 環境変数として管理する

## 📝 設定方法

### 0. 自動設定スクリプト（推奨）

`set-openai-api-key.bat`スクリプトを使用すると、簡単にAPIキーを設定できます：

```bash
cd C:\devlop\landing
set-openai-api-key.bat
```

スクリプト実行時にAPIキーの入力が求められます。または、環境変数`OPENAI_API_KEY`を事前に設定しておくこともできます。

### 1. ローカル開発環境（フロントエンド）

`frontend/.env`ファイルを作成または編集：

```bash
# frontend/.env
VITE_OPENAI_API_KEY=your-openai-api-key-here
```

### 2. ローカル開発環境（バックエンド）

`backend/.env`ファイルを作成または編集：

```bash
# backend/.env
OPENAI_API_KEY=your-openai-api-key-here
```

### 3. Railway本番環境

#### 方法1: Railway CLIから設定

```bash
cd C:\devlop\landing

# フロントエンド用（Vite環境変数）
railway variables set VITE_OPENAI_API_KEY=your-openai-api-key-here

# バックエンド用
railway variables set OPENAI_API_KEY=your-openai-api-key-here
```

#### 方法2: Railwayダッシュボードから設定

1. https://railway.app にアクセス
2. プロジェクト「landing」を開く
3. サービスを選択
4. 「Variables」タブを開く
5. 「+ New Variable」をクリック
6. 以下を追加：

   **フロントエンド用:**
   - Name: `VITE_OPENAI_API_KEY`
   - Value: `your-openai-api-key-here`（実際のAPIキーに置き換えてください）

   **バックエンド用:**
   - Name: `OPENAI_API_KEY`
   - Value: `your-openai-api-key-here`（実際のAPIキーに置き換えてください）

7. 「Add」をクリック

## ✅ 設定確認

### ローカル環境

```bash
# フロントエンド
cd frontend
cat .env | grep VITE_OPENAI_API_KEY

# バックエンド
cd backend
cat .env | grep OPENAI_API_KEY
```

### Railway環境

```bash
railway variables | grep OPENAI
```

## 🔄 環境変数の使用箇所

### フロントエンド
- `frontend/src/components/healthcare_lp_react_tailwind_ui.jsx`
  - `import.meta.env.VITE_OPENAI_API_KEY` で参照

### バックエンド
- `backend/app/Http/Controllers/OpenAIController.php`
  - `env('OPENAI_API_KEY')` で参照

## 🚨 セキュリティチェックリスト

- [ ] `.env`ファイルが`.gitignore`に含まれている
- [ ] `.env`ファイルがGitにコミットされていない
- [ ] Railwayの環境変数に設定されている
- [ ] コード内にAPIキーが直接書かれていない
- [ ] 公開リポジトリにプッシュしていない

## 📚 参考

- [OpenAI API Keys](https://platform.openai.com/api-keys)
- [Vite Environment Variables](https://vitejs.dev/guide/env-and-mode.html)
- [Laravel Environment Configuration](https://laravel.com/docs/10.x/configuration#environment-configuration)
