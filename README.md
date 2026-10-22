# cl-exercises

Common Lisp の入門用エクササイズ集。独立した小さなコマンドラインプログラムを1つずつ作り、言語そのものとあわせて、Common Lisp のプロジェクト構成のベストプラクティス（ASDF によるシステム定義、ocicl による依存管理、実行ファイルのビルド）も身につける。

## 方針

- **再現性**：`git clone` して `make setup` を実行すれば、どのマシンでも同じ環境ができる。手作業の手順は持たない
- **自己完結**：`~/.sbclrc` などの個人設定には依存しない。SBCL は `--no-userinit` で起動し、必要な設定はすべて `Makefile` で行う
- **依存の固定**：依存ライブラリは ocicl で管理し、ロックファイル `ocicl.csv`（sha256 で固定）をコミットする

## 構成

```
Brewfile        必要なツール（SBCL、ocicl）
Makefile        setup / build / test
ocicl.csv       依存ライブラリのロックファイル
<name>.asd      演習ごとのシステム定義（本体 <name> とテスト <name>/tests）
src/<name>.lisp 演習の本体
tests/<name>.lisp 演習のテスト（FiveAM）
bin/            ビルドした実行ファイル（git 管理外）
ocicl/          取得した依存ライブラリ（git 管理外）
```

## セットアップ

前提：Homebrew がインストール済みであること。

```sh
make setup
```

ツールのインストール（`Brewfile`）、ocicl の初期設定（`~/.local/share/ocicl/ocicl-runtime.lisp` の配置）、依存ライブラリの取得（`ocicl.csv`）をまとめて行う。`ocicl setup` が表示する `~/.sbclrc` 向けの設定は使わない。

## 演習の作り方

### 1. ソースとシステム定義を作る

演習ごとに、プロジェクト直下の `<name>.asd` と `src/<name>.lisp` の組を作る。

- `<name>.asd`：システム定義
  - 依存ライブラリは `:depends-on` に書く。依存はこの1か所にだけ書けばよく、取得と `ocicl.csv` への記録はビルド時に ocicl-runtime が自動で行う
  - `:build-operation "program-op"`、`:build-pathname "bin/<name>"`、`:entry-point "<name>:main"` を書くと、実行ファイルを作れるようになる
  - 末尾の `#+sb-core-compression` の設定で実行ファイルを圧縮する（約 41MB → 約 11MB）。`(c (eql (asdf:find-system "<name>")))` と特定のシステムに限定して定義する（`asdf:system` 全体に定義すると ASDF 本体のメソッドを上書きしてしまう）
  - テスト用のシステム `<name>/tests` を同じファイルに定義する。本体側に `:in-order-to ((test-op (test-op "<name>/tests")))` を書き、テスト側の `:perform` で FiveAM の `run!` を呼ぶ。失敗時はエラーにして終了コードに反映する
- `src/<name>.lisp`：本体。パッケージ名は `<name>` とし、エントリポイントの `main` を export する。ファイル見出し（`;;;;`）、セクション（`;;;`）のコメントと、docstring を書く

- `tests/<name>.lisp`：テスト。パッケージ名は `<name>/tests`、スイート名は `<name>`。export していない関数は `<name>::関数名` で呼ぶ

### 2. テストする

```sh
make test EX=<name>
```

`asdf:test-system` を実行する。すべて成功すれば終了コード 0、失敗があれば 0 以外で終わる。

### 3. ビルドして実行する

```sh
make build EX=<name>
./bin/<name> [引数...]
```

初回のビルドでは依存ライブラリの取得とコンパイルが走り、警告が多く出る。証明書の `WARNING`（macOS の証明書ストアの1件を読み飛ばしたという通知）と、依存ライブラリの `STYLE-WARNING` は無視してよい。

## 演習一覧

| 名前 | 内容 | 使用ライブラリ |
|---|---|---|
| hello | コマンドライン引数で受け取った名前に挨拶する（`./bin/hello World` → `Hello, World!`） | clingon、fiveam（テスト） |
