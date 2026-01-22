# 502エラー対応ガイド

## 🚨 エラー内容

```
Failed to load resource: the server responded with a status of 502 ()
/api/openai/generate:1
```

502エラーは、Nginxがバックエンド（PHP-FPM）に接続できない場合に発生します。

## 🔍 原因

1. **PHP-FPMが起動していない**
2. **PHP-FPMのソケットパスが正しくない**
3. **ソケットの権限が正しくない**
4. **Nginx設定が正しくない**

## ✅ 修正内容

### 1. Nginx設定の簡素化

`nginx.railway.conf`の`/api`ルート設定を簡素化しました。

### 2. PHP-FPM起動確認の強化

`Dockerfile.railway`のエントリーポイントスクリプトを修正：
- PHP-FPMの起動を確認
- ソケットの作成を確認
- ソケットの権限を設定

## 🚀 次のステップ

### 1. Railwayに再デプロイ

変更をコミットしてプッシュ：

```bash
cd C:\devlop\landing
git add nginx.railway.conf Dockerfile.railway
git commit -m "Fix 502 error: Improve PHP-FPM startup and Nginx configuration"
git push origin main
```

### 2. Railwayのログを確認

Railwayダッシュボードの「Logs」タブで以下を確認：

- ✅ "PHP-FPM socket created successfully" が表示される
- ❌ "ERROR: PHP-FPM socket not found" が表示されない
- ✅ Nginxが正常に起動している

### 3. 動作確認

ブラウザで以下を確認：

1. **コンソールログ**:
   - ✅ 「バックエンドAPI経由でOpenAI APIを呼び出し中...」と表示される
   - ❌ 502エラーが発生しない

2. **API呼び出し**:
   - ✅ `/api/openai/generate`が正常に動作する
   - ✅ OpenAI APIが正常に動作する

## 🔧 トラブルシューティング

### 502エラーが続く場合

1. **Railwayのログを確認**:
   - PHP-FPMが起動しているか確認
   - ソケットが作成されているか確認

2. **環境変数を確認**:
   - `OPENAI_API_KEY`が設定されているか確認

3. **Nginx設定を確認**:
   - `/api`ルートが正しく設定されているか確認
   - PHP-FPMのソケットパスが正しいか確認

### PHP-FPMが起動しない場合

1. **エントリーポイントスクリプトを確認**:
   - `Dockerfile.railway`のエントリーポイントスクリプトを確認
   - PHP-FPMの起動コマンドが正しいか確認

2. **ソケットパスを確認**:
   - `/var/run/php-fpm.sock`が存在するか確認
   - 権限が正しいか確認（666または660）

## 📝 変更ファイル

1. **`nginx.railway.conf`**: `/api`ルート設定を簡素化
2. **`Dockerfile.railway`**: PHP-FPM起動確認を強化

## 📚 参考

- [Nginx FastCGI Configuration](https://nginx.org/en/docs/http/ngx_http_fastcgi_module.html)
- [PHP-FPM Configuration](https://www.php.net/manual/en/install.fpm.configuration.php)
