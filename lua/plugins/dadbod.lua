return {
  -- DB ブラウザ / SQL 実行 (RubyMine の DB ツール相当)
  -- 接続文字列は認証情報を含むため設定に直書きせず :DBUIAddConnection か環境変数で管理する
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      "tpope/vim-dadbod",
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" } },
    },
    cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
    end,
    keys = { { "<leader>fd", "<cmd>DBUIToggle<cr>", desc = "Database UI" } },
  },
}
