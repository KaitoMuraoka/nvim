-- 基本設定
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.smartindent = true
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250
vim.opt.clipboard = "unnamedplus"

-- 半透明な背景にする
vim.opt.termguicolors = true
vim.opt.winblend = 20 -- Windowの透明度 (0-100)
vim.opt.pumblend = 20 -- ポップアップメニューの透明度 (0-100)

-- 背景を透過させる（ターミナルの背景が透けて見える）
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "NormalNC", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "NONE" })
  end,
})
-- 初回読み込み時にも適用
vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
vim.api.nvim_set_hl(0, "NormalNC", { bg = "NONE" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE" })
vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "NONE" })

-- リーダーキー
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- lazy.nvim読み込み
require("config.lazy")
