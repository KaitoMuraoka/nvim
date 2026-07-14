return {
	"nvim-orgmode/orgmode",
	event = "VeryLazy",
	config = function()
		-- Setup orgmode
		local path = "~/Library/Mobile Documents/com~apple~CloudDocs/org/note.org"
		require("orgmode").setup({
			org_agenda_files = path,
			org_default_notes_file = path,
		})
		-- Experimental LSP support
		vim.lsp.enable("org")
	end,
}
