return {
	"nvim-tree/nvim-tree.lua",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	keys = {
		{ "<leader>w", "<cmd>NvimTreeToggle<cr>", desc = "Toggle file tree" },
	},
	config = function()
		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1

		require("nvim-tree").setup({
			view = {
				number = true, -- ファイルツリーでも行番号を表示する
				relativenumber = true, -- 相対行番号を表示
			},
		})
	end,
}
