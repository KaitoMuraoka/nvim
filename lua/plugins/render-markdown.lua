return {
	"MeanderingProgrammer/render-markdown.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons", -- アイコン表示に必要
	},
	ft = { "markdown" }, -- Markdown を開いた時だけ読み込む
	opts = {
		-- 見出しの設定
		heading = {
			enabled = true,
			-- 見出しレベルごとのアイコン (# ## ### ...)
			icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
		},
		-- コードブロックの設定
		code = {
			enabled = true,
			style = "full", -- "full" | "normal" | "language" | "none"
		},
		-- チェックボックスの設定
		checkbox = {
			enabled = true,
			unchecked = { icon = "󰄱 " },
			checked = { icon = "󰱒 " },
		},
	},
}
