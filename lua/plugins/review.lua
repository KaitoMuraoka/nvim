-- https://github.com/slocook/review.nvim
return {
	"slocook/review.nvim",
	dependencies = {
		"esmuellert/codediff.nvim",
	},
	config = function()
		require("review").setup({
			export = {
				mode = "single", -- "single" | "per_comment"
			},
			beads = {
				enabled = false,
				branch_pattern = "epic/([^/]+)",
			},
		})
	end,
}
