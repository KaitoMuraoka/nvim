return {
 -- LSP設定
   "neovim/nvim-lspconfig",
   dependencies = {
     "williamboman/mason.nvim",
     "williamboman/mason-lspconfig.nvim",
     {
       "WhoIsSethDaniel/mason-tool-installer.nvim",
       opts = {
         ensure_installed = { "stylua", "codelldb" },
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

     require("mason-lspconfig").setup({
       ensure_installed = { "lua_ls", "ts_ls", "pyright", "html", "cssls", "emmet_ls", "prismals", "kotlin_language_server", "jdtls" },
       automatic_enable = true,
     })

     -- sourcekit は Mason 管理外なので手動で有効化
     vim.lsp.enable("sourcekit")

     -- LSPキーマップ
     vim.api.nvim_create_autocmd("LspAttach", {
       callback = function(args)
         local opts = { buffer = args.buf }
         vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
         vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
         vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
         vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
         vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
         vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
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
         end, opts)
       end,
     })
   end,
 }
