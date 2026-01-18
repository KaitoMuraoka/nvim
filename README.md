# Neovim設定

lazy.nvimを使用した最低限のNeovim開発環境。

## セットアップ

### 必要なツール

```bash
# Deno（skkeleton用）
brew install deno

# SKK辞書
mkdir -p ~/.skk
curl -o ~/.skk/SKK-JISYO.L.gz https://skk-dev.github.io/dict/SKK-JISYO.L.gz
gunzip ~/.skk/SKK-JISYO.L.gz
```

### インストール

Neovimを起動すると、lazy.nvimとプラグインが自動でインストールされる。

## キーバインド

リーダーキー: `<Space>`

### 基本操作

| キー | 説明 |
|------|------|
| `<Space>` + 待機 | which-keyでキーバインド一覧表示 |
| `<Space>e` | ファイルツリー開閉 |

### ファイル検索（Telescope）

| キー | 説明 |
|------|------|
| `<Space>ff` | ファイル検索 |
| `<Space>fg` | 文字列検索（grep） |
| `<Space>fb` | バッファ一覧 |
| `<Space>fh` | ヘルプ検索 |

### LSP

| キー | 説明 |
|------|------|
| `gd` | 定義へジャンプ |
| `gr` | 参照一覧 |
| `K` | ホバー情報 |
| `<Space>rn` | リネーム |
| `<Space>ca` | コードアクション |

### コメント

| キー | 説明 |
|------|------|
| `gcc` | 行コメント切り替え |
| `gc` + モーション | 範囲コメント切り替え |

### 補完（nvim-cmp）

| キー | 説明 |
|------|------|
| `<Tab>` | 次の候補 |
| `<S-Tab>` | 前の候補 |
| `<CR>` | 確定 |
| `<C-Space>` | 補完を開く |
| `<C-e>` | 補完をキャンセル |

## SKK（日本語入力）

Neovim内で動作する日本語入力。モード切り替え時のIME問題がない。

### 基本操作

| キー | 説明 |
|------|------|
| `<C-j>` | 日本語入力ON/OFF |

### 入力モード

| 操作 | 説明 |
|------|------|
| 小文字で入力 | ひらがな直接入力 |
| 大文字で開始 | 漢字変換モード |
| `q` | カタカナに変換 |
| `l` | ASCIIモードへ |
| `L` | 全角英数モードへ |

### 漢字変換の例

1. `<C-j>`で日本語入力ON
2. `Kanji`と入力（Kが大文字）→「▽かんじ」
3. `<Space>`で変換→「▼漢字」
4. `<CR>`または次の入力で確定

### 送り仮名の例

1. `OkuR`と入力（O, Rが大文字）→「▽おく*r」
2. `<Space>`で変換→「▼送r」
3. 確定すると「送り」

## プラグイン一覧

| プラグイン | 用途 |
|-----------|------|
| nvim-treesitter | シンタックスハイライト |
| nvim-lspconfig | LSP設定 |
| mason.nvim | LSPサーバー管理 |
| nvim-cmp | 補完 |
| telescope.nvim | ファジーファインダー |
| nvim-tree.lua | ファイルツリー |
| gitsigns.nvim | Git差分表示 |
| Comment.nvim | コメント |
| nvim-autopairs | 括弧自動補完 |
| skkeleton | 日本語入力（SKK） |
| which-key.nvim | キーバインドヘルプ |

## コマンド

| コマンド | 説明 |
|---------|------|
| `:Lazy` | プラグイン管理画面 |
| `:Mason` | LSPサーバー管理画面 |
| `:TSInstall <lang>` | Treesitterパーサー追加 |
| `:checkhealth` | 環境チェック |
