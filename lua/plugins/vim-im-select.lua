return {
  {
    "brglng/vim-im-select",
    lazy = false,
    config = function()
      -- IME切り替えのコマンド設定（OSに応じて変更）
      vim.g.im_select_command = "im-select" -- im-selectツールを使う場合
      vim.g.im_select_default = "com.apple.keylayout.ABC" -- macOSのデフォルトIME例
      -- Linuxでは以下のようにibusを使う
      -- vim.g.im_select_command = "ibus engine"
      -- vim.g.im_select_default = "xkb:us::eng" -- デフォルトの英語キーボード
    end,
  },
}

