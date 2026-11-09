# docker-lemp

Docker による LEMP 環境(WordPress 開発向け・wp-cli 付き)

## 環境

| 対象 | バージョン |
|---|---|
| PHP (fpm) | 8.4.27 |
| nginx | 1.31.8 |
| MySQL | 9.7.4 |
| phpMyAdmin | 5.2.3 |
| Mailpit | v1.33.1 |
| wp-cli | 2.12.0 |

PHP 拡張: bcmath / exif / gd / imagick / intl / mysqli / opcache / zip

## アクセス先

| サービス | URL |
|---|---|
| Web (nginx) | http://localhost:8080 |
| phpMyAdmin | http://localhost:9080 |
| Mailpit (受信メール確認) | http://localhost:8025 |

ポートは `.env` で変更できます。

### データベース

- host: `db`(ホストからは `127.0.0.1:3306`)
- user: `root`
- password: `password`(`.env` の `DB_ROOT_PASSWORD` で変更可)
- database: `wordpress`(初回起動時に自動作成。`.env` の `DB_NAME` で変更可)

> パスワードや DB 名を変更しても、既存の `db_data` ボリュームには反映されません。
> 反映するにはボリュームの再作成が必要です。

## 使い方

ホストとコンテナの UID/GID を一致させることで、パーミッション問題を回避します。

```
cp .env.example .env   # UID/GID は `id -u` / `id -g` の値に合わせる
make locald            # バックグラウンドで起動
```

### make コマンド

| コマンド | 内容 |
|---|---|
| `make local` / `make up` | フォアグラウンドで起動 |
| `make locald` / `make upd` | バックグラウンドで起動 |
| `make build` | イメージをビルド |
| `make down` | 停止・コンテナ削除(DB データは残る) |
| `make restart` | 再起動 |
| `make logs` | ログを表示 |
| `make ps` | コンテナ状態を表示 |
| `make shell` | php コンテナに入る |
| `make wp ARGS="..."` | wp-cli を実行 |

## WordPress の構築(wp-cli)

`htdocs/` が WordPress のルートです。php コンテナには wp-cli が入っており、
`htdocs/` 内で実行されます(`make shell` で入って `wp ...` と直接実行しても構いません)。

```
make wp ARGS="core download --locale=ja"
make wp ARGS="config create --dbname=wordpress --dbpass=password"
make wp ARGS="core install --url=http://localhost:8080 --title=サイト名 --admin_user=admin --admin_password=admin --admin_email=admin@example.com --skip-email"
```

- `core install` は英語でインストールされるため、日本語化するには続けて次を実行します。

  ```
  make wp ARGS="language core install ja --activate"
  make wp ARGS="option update timezone_string Asia/Tokyo"
  ```

- `core download` は日本語版、`config create` は `dbhost=db` / `dbuser=root` / `utf8mb4` が既定です
  (`docker/php/wp-cli.yml`)。
- 既存の `htdocs/index.php`(phpinfo)がある場合、`core download` は `--force` が必要です。
- メールは Mailpit に転送されます。WordPress のメール送信は http://localhost:8025 で確認できます。

## 設定ファイル

| ファイル | 内容 |
|---|---|
| `docker/php/php.ini` | タイムゾーン・opcache・アップロード上限(30M)・sendmail(Mailpit) |
| `docker/php/wp-cli.yml` | wp-cli の既定値 |
| `docker/php/mysql-client.cnf` | mysql クライアント設定(開発用に SSL 無効) |
| `docker/nginx/default.conf` | nginx 設定(アップロード上限 40M、xmlrpc.php・隠しファイルの拒否) |
| `docker/mysql/my.cnf` | MySQL 設定(utf8mb4、タイムゾーン +09:00) |

## 注意

開発用の設定です(`display_errors` 有効、MySQL クライアントの SSL 無効、DB ポート公開など)。
本番環境にはそのまま使用しないでください。
