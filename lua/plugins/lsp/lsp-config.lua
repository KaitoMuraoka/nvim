return {
 -- LSP設定
   "neovim/nvim-lspconfig",
   dependencies = {
     "williamboman/mason.nvim",
     "williamboman/mason-lspconfig.nvim",
     {
       "WhoIsSethDaniel/mason-tool-installer.nvim",
       opts = {
         ensure_installed = { "stylua", "codelldb", "goimports", "shfmt", "shellcheck" },
       },
     },
   },
   config = function()
     require("mason").setup()

     local capabilities = require("cmp_nvim_lsp").default_capabilities()

     -- デフォルトのLSP設定（全サーバーに適用）
     vim.lsp.config("*", {
       capabilities = capabilities,
     })

     -- lua_ls 個別設定
     vim.lsp.config("lua_ls", {
       settings = {
         Lua = {
           diagnostics = { globals = { "vim" } },
         },
       },
     })

     -- bashls 個別設定
     vim.lsp.config("bashls", {
       filetypes = { "sh", "bash" },
       settings = {
         bashIde = {
           shellcheckPath = vim.fn.exepath("shellcheck"),
         },
       },
     })

     -- sourcekit-lsp for Swift (Masonでは管理不可、Xcode同梱)
     vim.lsp.config("sourcekit", {
       capabilities = vim.tbl_deep_extend("force", capabilities, {
         workspace = {
           didChangeWatchedFiles = {
             dynamicRegistration = true,
           },
         },
       }),
       cmd = { "sourcekit-lsp" },
       filetypes = { "swift", "objc", "objcpp" },
       root_markers = {
         "buildServer.json",
         "*.xcodeproj",
         "*.xcworkspace",
         "Package.swift",
         ".git",
       },
     })

     -- ts_ls 個別設定（Biome採用リポジトリではフォーマットをBiome側に一本化）
     vim.lsp.config("ts_ls", {
       on_attach = function(client)
         client.server_capabilities.documentFormattingProvider = false
       end,
     })

     require("mason-lspconfig").setup({
       ensure_installed = { "lua_ls", "ts_ls", "pyright", "html", "cssls", "emmet_ls", "prismals", "kotlin_language_server", "jdtls", "gopls", "bashls", "biome" },
       automatic_enable = {
         exclude = { "stylua" },
       },
     })

     -- sourcekit は Mason 管理外なので手動で有効化
     vim.lsp.enable("sourcekit")

     -- ruby-lsp (Masonでは管理せず gem install したグローバル版を使う / rbenv shim経由)
     -- Railsアプリを検出すると ruby-lsp-rails アドオンを composed bundle に自動追加し、
     -- モデルのカラム/アソシエーション補完・実行時イントロスペクションを提供する。
     vim.lsp.config("ruby_lsp", {
       capabilities = capabilities,
       init_options = {
         -- プロジェクトに rubocop があれば自動採用、無ければ無効化（補完は常に動作）
         formatter = "auto",
       },
       filetypes = { "ruby", "eruby" },
     })
     vim.lsp.enable("ruby_lsp")

     -- solargraph は「補完専用」の補助として ruby-lsp と併用する。
     -- ruby-lsp の TypeInferrer はレシーバがリテラル/定数/Klass.new の時しか型を
     -- 解決できず(それ以外は変数名を CamelCase 化して同名定数を探すだけ)、
     -- gets.to_i のようなメソッドチェーンや Kernel#gets 自体が補完できない。
     -- solargraph は YARD の core ドキュメントから戻り値型を知っているため補える。
     -- 診断・定義ジャンプ・フォーマット等は ruby-lsp 側に一本化して衝突を避ける。
     -- (Masonでは管理せず gem install したグローバル版を使う / rbenv shim経由)
     vim.lsp.config("solargraph", {
       capabilities = capabilities,
       settings = {
         solargraph = {
           diagnostics = false,
           formatting = false,
           useBundler = false,
         },
       },
       on_attach = function(client)
         for _, cap in ipairs({
           "definitionProvider",
           "documentFormattingProvider",
           "documentRangeFormattingProvider",
           "documentSymbolProvider",
           "hoverProvider",
           "referencesProvider",
           "renameProvider",
           "signatureHelpProvider",
         }) do
           client.server_capabilities[cap] = nil
         end
       end,
     })
     vim.lsp.enable("solargraph")

     -- rust-analyzer (Masonでは管理せず rustup 経由のバイナリを使う)
     vim.lsp.config("rust_analyzer", {
       capabilities = capabilities,
       settings = {
         ["rust-analyzer"] = {
           check = {
             command = "clippy",
           },
         },
       },
     })
     vim.lsp.enable("rust_analyzer")

     -- LSPキーマップ
     vim.api.nvim_create_autocmd("LspAttach", {
       callback = function(args)
         local buf = args.buf
         vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = buf, desc = "Go to definition" })
         vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = buf, desc = "Hover" })
         vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = buf, desc = "Rename" })
         vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = buf, desc = "Code action" })
         vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = buf, desc = "References" })
         vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { buffer = buf, desc = "Diagnostics" })
         vim.keymap.set("n", "<leader>ey", function()
           local diagnostics = vim.diagnostic.get(0, { lnum = vim.api.nvim_win_get_cursor(0)[1] - 1 })
           if #diagnostics == 0 then
             vim.notify("No diagnostics on this line", vim.log.levels.INFO)
             return
           end
           local messages = {}
           for _, d in ipairs(diagnostics) do
             table.insert(messages, d.message)
           end
           vim.fn.setreg("+", table.concat(messages, "\n"))
           vim.notify("Diagnostic copied to clipboard", vim.log.levels.INFO)
         end, { buffer = buf, desc = "Copy diagnostic" })
       end,
     })
   end,
 }
