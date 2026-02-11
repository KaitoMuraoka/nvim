-- 背景を透過させる（ターミナルの背景が透けて見える）
local vimApi = vim.api
vimApi.nvim_create_autocmd("ColorScheme", {
	callback = function()
		vimApi.nvim_set_hl(0, "Normal", { bg = "NONE" })
		vimApi.nvim_set_hl(0, "NormalNC", { bg = "NONE" })
		vimApi.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
		vimApi.nvim_set_hl(0, "SignColumn", { bg = "NONE" })
		vimApi.nvim_set_hl(0, "EndOfBuffer", { bg = "NONE" })
	end,
})
-- 初回読み込み時にも適用
vimApi.nvim_set_hl(0, "Normal", { bg = "NONE" })
vimApi.nvim_set_hl(0, "NormalNC", { bg = "NONE" })
vimApi.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
vimApi.nvim_set_hl(0, "SignColumn", { bg = "NONE" })
vimApi.nvim_set_hl(0, "EndOfBuffer", { bg = "NONE" })

-- リーダーキー
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- lazy.nvim読み込み
require("core.init")
require("config.lazy")
