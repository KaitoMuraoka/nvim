return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require('lspconfig')
      local cmp_nvim_lsp = require('cmp_nvim_lsp')

      local capabilities = cmp_nvim_lsp.default_capabilities()
      capabilities.textDocument.completion.completionItem.snippetSupport = true

      -- Swift LSP設定を追加
      lspconfig.sourcekit.setup {
        capabilities = {
          workspace = {
            didChangeWatchedFiles = {
              dynamicRegistration = true,
            },
          },
        },
      }

      -- Lua LSPの設定を追加
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        settings = {
          Lua = {
            runtime = {
              -- LuaJIT（Neovimで使用されているLuaの実行環境）を指定
              version = 'LuaJIT',
              path = vim.split(package.path, ';'),
            },
            diagnostics = {
              -- 'vim' をグローバル変数として無視（診断エラーを防止）
              globals = { 'vim' },
            },
            workspace = {
              -- Neovim関連ファイルをLSPワークスペースに追加
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,  -- 不要なサードパーティチェックを無効化
            },
            telemetry = {
              enable = false,  -- 不要なテレメトリを無効化
            },
          },
        },
      })

      -- Java LSP: 
      -- Python LSP:
      -- bash shellscript
      lspconfig.bashls.setup({
        capabilities = capabilities,
      })

      -- gopls
      lspconfig.gopls.setup({
        capabilities = capabilities,
      })

      vim.api.nvim_create_autocmd('LspAttach', {
        desc = "LSP Actions",
        callback = function(args)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, {noremap = true, silent = true})
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, {noremap = true, silent = true})
        end,
      })
    end,
  },
}
