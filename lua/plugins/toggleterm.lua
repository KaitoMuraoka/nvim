-- return {
--   -- amongst your other pluins
--   -- amongst your other plugins
--   "akinsho/toggleterm.nvim",
--   version = "*",
--   config = function()
--     require("toggleterm").setup({})
--   end,
-- }

return {
	{
		"kdheepak/lazygit.nvim",
		-- オプション: Telescope との連携が必要な場合
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
		},
		config = function()
			-- LazyGit の設定をここに記述
		end,
	},
}
