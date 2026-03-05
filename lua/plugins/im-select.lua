return {
	"keaising/im-select.nvim",
	config = function()
		require("im_select").setup({
			-- ーマルモード時のデフォルトIME（英語）
			default_im_select = "com.apple.keylayout.ABC",

			-- IMEを切り替えるコマンド
			default_command = "im-select",

			-- デフォルトのIMEにままに設定
			set_previous_events = { "InsertEnter" },
		})
	end,
}
