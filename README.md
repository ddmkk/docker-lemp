# docker-lemp

Docker による LEMP 環境

## 環境
- PHP:8.1
- Nginx
- MySQL:5.7

### [データベース]

- user:"root"
- password:"password"

### その他

wordpress を使用する際は phpmyadmin でデータベースを作成後、htdocs 内に wordpress 本体をダウンロードして使用してください

### 使い方

makeコマンドでサーバーを立ち上げると権限問題をクリアできます。

.envファイルに以下を記述
```
UID=1000
GID=1000
```

makeコマンドを実行
```
make local
```
もしくは
```
make locald
```
でサーバーが起動します
