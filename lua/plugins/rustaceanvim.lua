return {
	"mrcjkb/rustaceanvim",
	version = "^9",
	lazy = false,
	init = function()
		-- rust-analyzer の起動・設定は rustaceanvim に一本化する
		-- (lsp-config.lua 側からは有効化しない)
		-- 関数で渡すことで capabilities の評価を rust ファイルを開いた時まで遅らせる
		vim.g.rustaceanvim = function()
			return {
				server = {
					capabilities = require("blink.cmp").get_lsp_capabilities(),
					default_settings = {
						["rust-analyzer"] = {
							check = { command = "clippy" },
							inlayHints = {
								bindingModeHints = { enable = true },
								closureReturnTypeHints = { enable = "always" },
								parameterHints = { enable = true },
							},
						},
					},
				},
			}
		end
	end,
}
