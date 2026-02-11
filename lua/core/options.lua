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

-- 半透明な背景にする
opt.termguicolors = true
opt.winblend = 20 -- Windowの透明度 (0-100)
opt.pumblend = 20 -- ポップアップメニューの透明度 (0-100)

