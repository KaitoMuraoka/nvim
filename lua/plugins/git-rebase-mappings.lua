-- https://github.com/bagohart/git-rebase-mappings.nvim
return {
	"bagohart/git-rebase-mappings.nvim",
	ft = "gitrebase",
	config = function()
		vim.keymap.set("n", "<LocalLeader>a", "<Plug>(git-rebase-mappings-abbreviate)")
		vim.keymap.set("n", "<LocalLeader>A", "<Plug>(git-rebase-mappings-expand)")
		require("git-rebase-mappings").create_commit_command_mappings()
	end,
}
