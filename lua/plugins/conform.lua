return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo", "Format" },
  keys = {
    { "<leader>cf", function() require("conform").format({ async = true, lsp_format = "fallback" }) end, desc = "Format buffer" },
  },
  config = function()
    require("conform").setup({
      formatters_by_ft = {
        lua = { "stylua" },
        swift = { "swiftformat" },
        go = { "goimports" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        -- ERB は erb_formatter で整形 (前提: Gemfile に gem "erb_formatter")
        -- 破壊的になりやすいため保存時自動化はせず :Format / <leader>cf で手動実行する
        eruby = { "erb_format" },
      },
      format_on_save = function(bufnr)
        -- eruby は自動整形の対象外 (手動実行のみ)
        if vim.bo[bufnr].filetype == "eruby" then
          return nil
        end
        return { timeout_ms = 500, lsp_format = "fallback" }
      end,
    })

    -- 手動整形コマンド (eruby など保存時対象外のファイルを明示的に整形する)
    vim.api.nvim_create_user_command("Format", function()
      require("conform").format({ async = true, lsp_format = "fallback" })
    end, { desc = "Format current buffer" })
  end,
}
