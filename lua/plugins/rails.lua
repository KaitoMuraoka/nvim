return {
  -- Rails ナビゲーション (tpope)
  -- :Emodel / :Eview / :Econtroller、:A (関連ファイル切替)、partial・route への gf を提供
  {
    "tpope/vim-rails",
    dependencies = {
      "tpope/vim-projectionist", -- :A / :E* の基盤
      "tpope/vim-bundler",       -- bundle 連携
      "vim-ruby/vim-ruby",       -- ruby ftplugin / 高度なインデント
    },
    ft = { "ruby", "eruby", "haml", "slim" },
    cmd = { "Rails", "Emodel", "Eview", "Econtroller" },
  },
}
