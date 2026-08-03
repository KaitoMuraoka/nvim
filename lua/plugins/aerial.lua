return {
  -- 構造ビュー (クラス/メソッド一覧、RubyMine の Structure 相当)
  {
    "stevearc/aerial.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    cmd = { "AerialToggle" },
    keys = { { "<leader>cs", "<cmd>AerialToggle<cr>", desc = "Structure (symbols)" } },
    opts = {
      backends = { "lsp", "treesitter" },
      layout = { default_direction = "right" },
    },
  },
}
