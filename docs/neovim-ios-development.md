# Neovim 単体で iOS アプリ開発を行う

Xcode を開かずに、Neovim だけで iOS アプリのコーディング・ビルド・実行・デバッグ・プレビューまで完結させるための環境構築手順をまとめる。

## 前提環境

- macOS
- Neovim 0.10+
- Xcode インストール済み（`xcode-select --install` 実行済み）
- プラグインマネージャ: [lazy.nvim](https://github.com/folke/lazy.nvim)
- 画像表示対応ターミナル（Ghostty, Kitty, WezTerm, iTerm2 など）

## 全体構成

今回追加・変更するファイルは以下の通り。

```
lua/plugins/
├── lsp/
│   └── lsp-config.lua      # sourcekit-lsp 追加
├── conform.lua              # swiftformat 追加
├── nvim-treesitter.lua      # swift パーサー追加
├── xcodebuild.lua           # 新規: ビルド・実行・テスト・プレビュー
└── nvim-dap.lua             # 新規: デバッグ環境
```

---

## 1. 外部ツールのインストール

```bash
# xcodebuild の出力を整形するツール
brew install xcbeautify

# Xcode プロジェクト構造を sourcekit-lsp に伝える BSP ブリッジ
brew install xcode-build-server

# Swift コードフォーマッタ（nicklockwood 版）
brew install swiftformat
```

`sourcekit-lsp` は Xcode に同梱されているため、別途インストールは不要。

```bash
# 確認
xcrun --find sourcekit-lsp
```

---

## 2. シンタックスハイライト（nvim-treesitter）

`ensure_installed` に `"swift"` を追加するだけで、Swift の構文がハイライトされるようになる。

```lua
-- lua/plugins/nvim-treesitter.lua
return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  main = "nvim-treesitter",
  opts = {
    ensure_installed = {
      -- ...既存の言語...
      "swift", -- 追加
    },
    auto_install = true,
    highlight = { enable = true },
    indent = { enable = true },
  },
}
```

---

## 3. LSP（sourcekit-lsp）

### なぜ Mason を使わないのか

sourcekit-lsp は Xcode に同梱されており、Mason のレジストリには存在しない。そのため mason-lspconfig の `handlers` の外で手動セットアップする必要がある。

### 設定

```lua
-- lua/plugins/lsp/lsp-config.lua の config 関数内、mason-lspconfig.setup() の後に追加

local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- sourcekit-lsp for Swift（Xcode 同梱）
lspconfig.sourcekit.setup({
  capabilities = vim.tbl_deep_extend("force", capabilities, {
    workspace = {
      didChangeWatchedFiles = {
        dynamicRegistration = true,
      },
    },
  }),
  cmd = { "sourcekit-lsp" },
  filetypes = { "swift", "objc", "objcpp" },
  root_dir = lspconfig.util.root_pattern(
    "buildServer.json",
    "*.xcodeproj",
    "*.xcworkspace",
    "Package.swift",
    ".git"
  ),
})
```

### ポイント: `didChangeWatchedFiles`

Neovim はデフォルトで `didChangeWatchedFiles` の動的登録をサポートしていない。この capability を明示的に有効化しないと、sourcekit-lsp がファイル変更を検知できず、LSP の再起動が頻繁に必要になる。

### ポイント: `root_dir` の優先順位

`buildServer.json` を最優先にしている。これは xcode-build-server が生成するファイルで、sourcekit-lsp がこれを検出すると Xcode プロジェクトのビルド設定を正しく理解できるようになる。

### Xcode プロジェクトとの連携

Swift Package Manager プロジェクト（`Package.swift` がある場合）は sourcekit-lsp がそのまま動作する。しかし `.xcodeproj` / `.xcworkspace` ベースのプロジェクトでは、xcode-build-server によるブリッジが必要になる。

```bash
cd /path/to/your/project

# .xcodeproj の場合
xcode-build-server config -project *.xcodeproj -scheme YourScheme

# .xcworkspace の場合
xcode-build-server config -workspace *.xcworkspace -scheme YourScheme
```

これにより `buildServer.json` が生成され、sourcekit-lsp が自動的に認識する。

---

## 4. コードフォーマット（conform.nvim + swiftformat）

conform.nvim は swiftformat をビルトインでサポートしているため、`formatters_by_ft` に追加するだけで保存時に自動フォーマットされる。

```lua
-- lua/plugins/conform.lua
return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  config = function()
    require("conform").setup({
      formatters_by_ft = {
        lua = { "stylua" },
        swift = { "swiftformat" }, -- 追加
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_format = "fallback",
      },
    })
  end,
}
```

プロジェクトルートに `.swiftformat` ファイルを置くことで、ルールをカスタマイズできる。

```
--indent 4
--swiftversion 5.9
```

---

## 5. ビルド・実行・テスト（xcodebuild.nvim）

[xcodebuild.nvim](https://github.com/wojciech-kulik/xcodebuild.nvim) は Neovim から iOS/macOS アプリのビルド・実行・テスト・カバレッジ・プレビューまでを一貫して行えるプラグイン。

```lua
-- lua/plugins/xcodebuild.lua
return {
  "wojciech-kulik/xcodebuild.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-treesitter/nvim-treesitter",
    "folke/snacks.nvim", -- プレビュー画像表示に必要
  },
  config = function()
    require("xcodebuild").setup()

    vim.keymap.set("n", "<leader>X", "<cmd>XcodebuildPicker<cr>", { desc = "Xcode Actions" })
    vim.keymap.set("n", "<leader>xb", "<cmd>XcodebuildBuild<cr>", { desc = "Xcode Build" })
    vim.keymap.set("n", "<leader>xr", "<cmd>XcodebuildBuildRun<cr>", { desc = "Xcode Build & Run" })
    vim.keymap.set("n", "<leader>xt", "<cmd>XcodebuildTest<cr>", { desc = "Xcode Test" })
    vim.keymap.set("n", "<leader>xl", "<cmd>XcodebuildToggleLogs<cr>", { desc = "Xcode Toggle Logs" })
    vim.keymap.set("n", "<leader>xc", "<cmd>XcodebuildToggleCodeCoverage<cr>", { desc = "Toggle Coverage" })
    vim.keymap.set("n", "<leader>xo", "<cmd>XcodebuildOpenInXcode<cr>", { desc = "Open in Xcode" })
    vim.keymap.set("n", "<leader>xp", "<cmd>XcodebuildPreviewGenerateAndShow<cr>", { desc = "Xcode Preview" })
    vim.keymap.set("n", "<leader>xP", "<cmd>XcodebuildPreviewGenerateAndShow hotReload<cr>", { desc = "Xcode Preview (Hot Reload)" })
  end,
}
```

### キーマップ一覧

| キー | 機能 |
|------|------|
| `<leader>X` | アクションピッカー（全コマンド一覧） |
| `<leader>xb` | ビルド |
| `<leader>xr` | ビルド & シミュレータで実行 |
| `<leader>xt` | テスト実行 |
| `<leader>xl` | ビルドログの表示/非表示 |
| `<leader>xc` | コードカバレッジの表示/非表示 |
| `<leader>xo` | Xcode で開く |
| `<leader>xp` | SwiftUI プレビュー生成 |
| `<leader>xP` | SwiftUI プレビュー（ホットリロード） |

### 初回セットアップ

Xcode プロジェクトを Neovim で開いた後、以下を実行する。

```
:XcodebuildSetup
```

Telescope でプロジェクト/ワークスペースとスキームを選択する。これにより xcode-build-server の `buildServer.json` も自動生成される。

---

## 6. デバッグ（nvim-dap + codelldb）

### codelldb のインストール

mason-tool-installer で自動インストールされるように設定する。

```lua
-- lua/plugins/lsp/lsp-config.lua の mason-tool-installer 部分
{
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  opts = {
    ensure_installed = { "stylua", "codelldb" }, -- codelldb を追加
  },
},
```

### デバッグ設定

```lua
-- lua/plugins/nvim-dap.lua
return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
    "wojciech-kulik/xcodebuild.nvim",
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    dapui.setup()

    -- DAP UI の自動開閉
    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end

    -- codelldb アダプタ（Xcode の LLDB を使用して Swift 型情報を正しく表示）
    dap.adapters.codelldb = {
      type = "server",
      port = "13000",
      executable = {
        command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
        args = {
          "--port",
          "13000",
          "--liblldb",
          -- Xcode 同梱の LLDB を指定（Swift のデバッグに必須）
          "/Applications/Xcode.app/Contents/SharedFrameworks/LLDB.framework/Versions/A/LLDB",
        },
      },
    }

    -- xcodebuild.nvim と連携した Swift デバッグ設定
    dap.configurations.swift = {
      {
        name = "iOS App (xcodebuild.nvim)",
        type = "codelldb",
        request = "attach",
        program = require("xcodebuild.platform.device").get_program_path,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        waitFor = true,
      },
    }

    vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
    vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Continue" })
    vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "Step Over" })
    vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Step Into" })
    vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "Toggle DAP UI" })
    vim.keymap.set("n", "<leader>dd", "<cmd>XcodebuildDebug<cr>", { desc = "Xcode Debug" })
    vim.keymap.set("n", "<leader>dD", "<cmd>XcodebuildDebugStop<cr>", { desc = "Xcode Debug Stop" })
  end,
}
```

### なぜ Xcode の LLDB を指定するのか

codelldb にはデフォルトで liblldb がバンドルされているが、これは C/C++ 向けであり、Swift の型情報を正しく解釈できない。Xcode 同梱の LLDB フレームワークを `--liblldb` で指定することで、Swift の変数やオブジェクトがデバッグ時に正しく表示される。

### デバッグの流れ

1. `<leader>db` でブレークポイントを設置
2. `<leader>dd` でデバッグ開始（ビルド → シミュレータ起動 → デバッガアタッチ）
3. ブレークポイントで停止したら、DAP UI が自動的に開く
4. `<leader>dc` で続行、`<leader>do` でステップオーバー、`<leader>di` でステップイン
5. `<leader>dD` でデバッグ停止

### デバッグ用キーマップ一覧

| キー | 機能 |
|------|------|
| `<leader>db` | ブレークポイントの設置/解除 |
| `<leader>dc` | 続行 |
| `<leader>do` | ステップオーバー |
| `<leader>di` | ステップイン |
| `<leader>du` | DAP UI の表示/非表示 |
| `<leader>dd` | デバッグ開始 |
| `<leader>dD` | デバッグ停止 |

---

## 7. SwiftUI プレビュー

Neovim 内で SwiftUI のプレビューを画像として表示できる。ターミナルの Kitty Graphics Protocol を利用するため、対応ターミナルが必要。

### 対応ターミナル

- Ghostty
- Kitty
- WezTerm
- iTerm2

macOS 標準の Terminal.app は非対応。

### Neovim 側の設定

xcodebuild.nvim の依存に `snacks.nvim` を追加済み（セクション 5 参照）。キーマップも設定済み。

### プロジェクト側の設定

各 Xcode プロジェクトに [xcodebuild-nvim-preview](https://github.com/wojciech-kulik/xcodebuild-nvim-preview) Swift パッケージを追加する必要がある。

1. Xcode で **File > Add Package Dependencies** を開く
2. `https://github.com/wojciech-kulik/xcodebuild-nvim-preview` を入力して追加
3. アプリのエントリポイントを修正:

```swift
import SwiftUI
import XcodebuildNvimPreview

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .setupNvimPreview { ContentView() }
        }
    }
}
```

`<leader>xp` を押すとアプリがビルド・実行され、プレビュー画像が Neovim 内に表示される。

---

## 8. プロジェクトごとの初回セットアップまとめ

新しい Xcode プロジェクトを Neovim で開発する際の手順。

```bash
# 1. プロジェクトディレクトリに移動
cd /path/to/MyApp

# 2. Neovim を起動
nvim .
```

```
# 3. Neovim 内でプロジェクトセットアップ
:XcodebuildSetup

# 4. プロジェクトとスキームを Telescope で選択

# 5. LSP を再起動
:LspRestart

# 6. 初回ビルド（sourcekit-lsp のインデックス生成のため）
:XcodebuildBuild
```

以降は `<leader>xr` でビルド & 実行、`<leader>dd` でデバッグ開始。

---

## 参考リンク

- [xcodebuild.nvim](https://github.com/wojciech-kulik/xcodebuild.nvim)
- [The Complete Guide to iOS & macOS Development in Neovim](https://wojciechkulik.pl/ios/the-complete-guide-to-ios-macos-development-in-neovim)
- [Zero to Swift Nvim (swift.org)](https://www.swift.org/documentation/articles/zero-to-swift-nvim.html)
- [xcode-build-server](https://github.com/SolaWing/xcode-build-server)
- [xcodebuild-nvim-preview](https://github.com/wojciech-kulik/xcodebuild-nvim-preview)
