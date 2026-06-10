return {
	"nvim-orgmode/orgmode",
	event = "VeryLazy",
	ft = { "org" },
	config = function()
		-- Setup orgmode
		require("orgmode").setup({
			org_default_notes_file = "~/orgfiles/notes.org",
		})

		-- Experimental LSP support
		vim.lsp.enable("org")
	end,
}
