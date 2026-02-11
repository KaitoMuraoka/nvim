-- 背景を透過させる（ターミナルの背景が透けて見える）+ ハイコントラスト文字色
local vimApi = vim.api

local function apply_transparent_highcontrast()
	-- 背景を透過
	vimApi.nvim_set_hl(0, "Normal", { fg = "#FFFFFF", bg = "NONE" })
	vimApi.nvim_set_hl(0, "NormalNC", { fg = "#FFFFFF", bg = "NONE" })
	vimApi.nvim_set_hl(0, "NormalFloat", { fg = "#FFFFFF", bg = "NONE" })
	vimApi.nvim_set_hl(0, "SignColumn", { bg = "NONE" })
	vimApi.nvim_set_hl(0, "EndOfBuffer", { bg = "NONE" })

	-- ハイコントラスト: シンタックスハイライト
	vimApi.nvim_set_hl(0, "Comment", { fg = "#80A0FF", italic = true })
	vimApi.nvim_set_hl(0, "Keyword", { fg = "#FF6AC1", bold = true })
	vimApi.nvim_set_hl(0, "Function", { fg = "#50FA7B", bold = true })
	vimApi.nvim_set_hl(0, "String", { fg = "#F1FA8C" })
	vimApi.nvim_set_hl(0, "Number", { fg = "#FF9E64" })
	vimApi.nvim_set_hl(0, "Type", { fg = "#8BE9FD", bold = true })
	vimApi.nvim_set_hl(0, "Constant", { fg = "#FF9E64", bold = true })
	vimApi.nvim_set_hl(0, "Identifier", { fg = "#E0E0E0" })
	vimApi.nvim_set_hl(0, "Statement", { fg = "#FF6AC1", bold = true })
	vimApi.nvim_set_hl(0, "PreProc", { fg = "#FF79C6" })
	vimApi.nvim_set_hl(0, "Special", { fg = "#FFB86C" })
	vimApi.nvim_set_hl(0, "Operator", { fg = "#FF79C6" })
	vimApi.nvim_set_hl(0, "Delimiter", { fg = "#F8F8F2" })

	-- UI要素
	vimApi.nvim_set_hl(0, "LineNr", { fg = "#888888", bg = "NONE" })
	vimApi.nvim_set_hl(0, "CursorLineNr", { fg = "#FFFF00", bold = true, bg = "NONE" })
	vimApi.nvim_set_hl(0, "Visual", { bg = "#44475A" })
	vimApi.nvim_set_hl(0, "Search", { fg = "#000000", bg = "#FFFF00", bold = true })
	vimApi.nvim_set_hl(0, "StatusLine", { fg = "#FFFFFF", bg = "#333333" })
	vimApi.nvim_set_hl(0, "Pmenu", { fg = "#FFFFFF", bg = "#333333" })
	vimApi.nvim_set_hl(0, "PmenuSel", { fg = "#000000", bg = "#50FA7B", bold = true })

	-- 診断（エラー・警告など）
	vimApi.nvim_set_hl(0, "DiagnosticError", { fg = "#FF5555", bold = true })
	vimApi.nvim_set_hl(0, "DiagnosticWarn", { fg = "#FFB86C", bold = true })
	vimApi.nvim_set_hl(0, "DiagnosticInfo", { fg = "#8BE9FD" })
	vimApi.nvim_set_hl(0, "DiagnosticHint", { fg = "#50FA7B" })
end

vimApi.nvim_create_autocmd("ColorScheme", {
	callback = apply_transparent_highcontrast,
})
-- 初回読み込み時にも適用
apply_transparent_highcontrast()
