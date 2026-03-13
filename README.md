# Neovim設定

lazy.nvimを使用した最低限のNeovim開発環境。

## セットアップ

### 必要なツール

```bash
# im-select（ノーマルモード時のIME自動切り替え）
brew tap daipeihust/tap && brew install im-select
```

### インストール

Neovimを起動すると、lazy.nvimとプラグインが自動でインストールされる。

## キーバインド

リーダーキー: `<Space>`

### 基本操作

| キー | 説明 |
|------|------|
| `<Space>` + 待機 | which-keyでキーバインド一覧表示 |

### ファイル検索（Telescope）

| キー | 説明 |
|------|------|
| `<Space>ff` | ファイル検索 |
| `<Space>fg` | 文字列検索（grep） |
| `<Space>fb` | バッファ一覧 |
| `<Space>fh` | ヘルプ検索 |

### ファイルツリー

| キー | 説明 |
|------|------|
| `<leader>w` | ファイルツリー開閉 |

### LSP

| キー | 説明 |
|------|------|
| `gd` | 定義へジャンプ |
| `gr` | 参照一覧 |
| `K` | ホバー情報 |
| `<Space>rn` | リネーム |
| `<Space>ca` | コードアクション |

### 補完（nvim-cmp）

| キー | 説明 |
|------|------|
| `<Tab>` | 次の候補 |
| `<S-Tab>` | 前の候補 |
| `<CR>` | 確定 |
| `<C-Space>` | 補完を開く |
| `<C-e>` | 補完をキャンセル |

### コメント

| キー | 説明 |
|------|------|
| `gcc` | 行コメント切り替え |
| `gc` + モーション | 範囲コメント切り替え |

### ターミナル（toggleterm）

| キー | 説明 |
|------|------|
| `<C-\>` | ターミナルトグル |
| `<leader>tf` | 浮動ターミナル |
| `<leader>th` | 水平分割ターミナル |
| `<leader>tv` | 垂直分割ターミナル |

### フォーマット（conform）

ファイル保存時に自動フォーマット（stylua / swiftformat / prettier）。

### 診断

| キー | 説明 |
|------|------|
| `<leader>e` | 診断をフロートウィンドウで表示 |
| `<leader>ey` | カーソル行の診断をクリップボードにコピー |

### デバッグ（nvim-dap）

| キー | 説明 |
|------|------|
| `<leader>db` | ブレークポイント切り替え |
| `<leader>dc` | 実行（Continue） |
| `<leader>do` | ステップオーバー |
| `<leader>di` | ステップイン |
| `<leader>du` | DAP UI トグル |
| `<leader>dd` | Xcodeデバッグ開始 |

### Xcode開発（xcodebuild）

| キー | 説明 |
|------|------|
| `<leader>X` | Xcodeアクション一覧 |
| `<leader>xb` | ビルド |
| `<leader>xr` | ビルド＆実行 |
| `<leader>xt` | テスト実行 |
| `<leader>xl` | ログトグル |
| `<leader>xc` | コードカバレッジトグル |
| `<leader>xo` | Xcodeで開く |
| `<leader>xp` | プレビュー表示 |
| `<leader>xP` | プレビュー（ホットリロード） |

## プラグイン一覧

| プラグイン | 用途 |
|-----------|------|
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | シンタックスハイライト |
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | LSP設定 |
| [mason.nvim](https://github.com/williamboman/mason.nvim) | LSPサーバー管理 |
| [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) | 補完 |
| [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) | ファジーファインダー |
| [nvim-tree.lua](https://github.com/nvim-tree/nvim-tree.lua) | ファイルツリー |
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | Git差分表示 |
| [Comment.nvim](https://github.com/numToStr/Comment.nvim) | コメント |
| [nvim-autopairs](https://github.com/windwp/nvim-autopairs) | 括弧自動補完 |
| [which-key.nvim](https://github.com/folke/which-key.nvim) | キーバインドヘルプ |
| [conform.nvim](https://github.com/stevearc/conform.nvim) | コード自動フォーマット（stylua / swiftformat / prettier） |
| [nvim-dap](https://github.com/mfussenegger/nvim-dap) | デバッグ（DAP） |
| [nvim-dap-ui](https://github.com/rcarriga/nvim-dap-ui) | デバッグUI |
| [xcodebuild.nvim](https://github.com/wojciech-kulik/xcodebuild.nvim) | Xcode / iOS開発統合 |
| [toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim) | ターミナル統合 |
| [render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim) | Markdownレンダリング |
| [snacks.nvim](https://github.com/folke/snacks.nvim) | ユーティリティ（画像表示等） |
| [im-select.nvim](https://github.com/keaising/im-select.nvim) | ノーマルモード時IME自動切り替え |
| [lua-console.nvim](https://github.com/Yarospace/lua-console.nvim) | Lua REPLコンソール |

## IME自動切り替え

im-select.nvimにより、ノーマルモード移行時に自動で英語入力に切り替わる。

## コマンド

| コマンド | 説明 |
|---------|------|
| `:Lazy` | プラグイン管理画面 |
| `:Mason` | LSPサーバー管理画面 |
| `:TSInstall <lang>` | Treesitterパーサー追加 |
| `:checkhealth` | 環境チェック |
| `:ConformInfo` | フォーマッター状態確認 |
| `:DapUI` | デバッグUI |
