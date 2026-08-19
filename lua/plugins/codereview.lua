-- https://github.com/afewyards/codereview.nvim
return {
	"afewyards/codereview.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	cmd = {
		"CodeReview",
		"CodeReviewAI",
		"CodeReviewAIFile",
		"CodeReviewStart",
		"CodeReviewSubmit",
		"CodeReviewApprove",
		"CodeReviewOpen",
		"CodeReviewPipeline",
		"CodeReviewComments",
		"CodeReviewFiles",
		"CodeReviewToggleScroll",
		"CodeReviewCommits",
	},
	opts = {
		platform = "github",
		ai = {
			provider = "claude_cli",
			claude_cli = {
				cmd = "claude",
				agent = false,
			},
		},
	},
}
