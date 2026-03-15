-- 言語設定
vim.cmd.language('ja_JP.utf8')

-- ヘルプファイルの言語設定
vim.opt.helplang = { 'ja', 'en' }

-- 基本設定
local opt = vim.opt
opt.number = true
opt.relativenumber = true
opt.expandtab = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.smartindent = true
opt.termguicolors = true
opt.signcolumn = "yes"
opt.updatetime = 250
opt.clipboard = "unnamedplus"
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldlevel = 99
opt.foldenable = true

-- 半透明な背景にする
opt.termguicolors = true
opt.winblend = 20 -- Windowの透明度 (0-100)
opt.pumblend = 20 -- ポップアップメニューの透明度 (0-100)

-- ターミナルバッファでも行番号を表示する
-- （Neovimはterm://バッファを開くと自動でnumber/relativenumberを無効にするため）
vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    vim.opt_local.number = true
    vim.opt_local.relativenumber = true
  end,
})
