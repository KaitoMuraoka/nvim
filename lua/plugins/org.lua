return {
	"nvim-orgmode/orgmode",
	event = "VeryLazy",
	ft = { "org" },
	config = function()
		-- Setup orgmode
		require("orgmode").setup({
			org_agenda_files = {
				"~/org/*.org",
				"~/org/projects/*.org",
			},
			org_default_notes_file = "~/org/inbox.org",
			org_capture_templates = {
				t = {
					description = "Task (inbox)",
					template = "* TODO %?\n  %U",
					target = "~/org/inbox.org",
				},
				r = {
					description = "Routine",
					template = "* TODO %?\n  SCHEDULED: %t",
					target = "~/org/routine.org",
				},
			},
		})

		-- Experimental LSP support
		vim.lsp.enable("org")
	end,
}
