# 502エラー対応ガイド

## 🚨 エラー内容

```
Failed to load resource: the server responded with a status of 502 ()
/api/openai/generate:1
```

502エラーは、Nginxがバックエンド（PHP-FPM）に接続できない場合に発生します。

## 🔍 原因

1. **PHP-FPMがTCPポート9000で起動している**（ソケットではなく）
2. **PHP-FPMのソケットパスが正しくない**
3. **既存のPHP-FPMプロセスが設定変更前に起動している**
4. **ソケットの権限が正しくない**
5. **Nginx設定が正しくない**

## ✅ 修正内容

### 1. Nginx設定の簡素化

`nginx.railway.conf`の`/api`ルート設定を簡素化しました。

### 2. PHP-FPM設定の修正（ビルド時）

`Dockerfile.railway`のビルド時にPHP-FPM設定ファイルを修正：
- ソケットパス（`/var/run/php-fpm.sock`）を設定
- ソケットの所有者とグループを`www-data`に設定
- ソケットの権限を`0660`に設定

### 3. PHP-FPM起動プロセスの改善

`Dockerfile.railway`のエントリーポイントスクリプトを修正：
- 既存のPHP-FPMプロセスを停止
- 設定ファイルを再確認・修正
- PHP-FPMを明示的に設定ファイルを指定して起動
- ソケットの作成を確認（詳細なログ出力）
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

- ✅ "SUCCESS: PHP-FPM socket created at /var/run/php-fpm.sock" が表示される
- ✅ "Starting PHP-FPM with socket configuration..." が表示される
- ❌ "ERROR: PHP-FPM socket not found" が表示されない
- ❌ "ERROR: unable to bind listening socket for address '9000'" が表示されない
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

1. **ログを確認**:
   - "ERROR: unable to bind listening socket for address '9000'" が表示される場合、既存のPHP-FPMプロセスが残っている可能性があります
   - "ERROR: PHP-FPM socket not found" が表示される場合、設定ファイルが正しく読み込まれていない可能性があります

2. **エントリーポイントスクリプトを確認**:
   - `Dockerfile.railway`のエントリーポイントスクリプトを確認
   - PHP-FPMの起動コマンドが正しいか確認（`-y /usr/local/etc/php-fpm.d/www.conf`が指定されているか）

3. **設定ファイルを確認**:
   - `/usr/local/etc/php-fpm.d/www.conf`の`listen`設定が`/var/run/php-fpm.sock`になっているか確認
   - ビルド時に設定ファイルが正しく修正されているか確認

4. **ソケットパスを確認**:
   - `/var/run/php-fpm.sock`が存在するか確認
   - 権限が正しいか確認（666または660）
   - 所有者が`www-data`になっているか確認

## 📝 変更ファイル

1. **`nginx.railway.conf`**: `/api`ルート設定を簡素化
2. **`Dockerfile.railway`**: PHP-FPM起動確認を強化

## 📚 参考

- [Nginx FastCGI Configuration](https://nginx.org/en/docs/http/ngx_http_fastcgi_module.html)
- [PHP-FPM Configuration](https://www.php.net/manual/en/install.fpm.configuration.php)
