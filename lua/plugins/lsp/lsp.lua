return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "folke/neodev.nvim", opts = {} },
	},
	config = function()
		local lspconfig = require("lspconfig")
		local mason_lspconfig = require("mason-lspconfig")
		vim.api.nvim_create_autocmd("LspAttach", {
			desc = "LSP Actions",
			callback = function()
				vim.keymap.set("n", "K", vim.lsp.buf.hover, { noremap = true, silent = true })
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, { noremap = true, silent = true })
			end,
		})

		local cmp_nvim_lsp = require("cmp_nvim_lsp")
		local capabilities = cmp_nvim_lsp.default_capabilities()

		mason_lspconfig.setup_handlers({
			function(server_name)
				lspconfig[server_name].setup({
					capabilities = capabilities,
				})
			end,
		})

		-- swift
		lspconfig.sourcekit.setup({
			capabilities = {
				workspace = {
					didChangeWatchedFiles = {
						dynamicRegistration = true,
					},
				},
			},
			cmd = {
				"sourcekit-lsp",
				"-Xswiftc",
				"-sdk",
				"-Xswiftc",
				"/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator17.5.sdk",
				"-Xswiftc",
				"-target",
				"-Xswiftc",
				"x86_64-apple-ios17.5-simulator",
			},
		})

		lspconfig.emmet_ls.setup({
			capabilities = capabilities,
			filetypes = {
				"astro",
				"html",
				"typescriptreact",
				"javascriptreact",
				"css",
				"sass",
				"scss",
				"less",
				"svelte",
			},
		})

		--lua
		lspconfig.lua_ls.setup({
			capabilities = capabilities,
			setting = {
				Lua = {
					diagnostics = {
						globals = { "vim" },
					},
					completion = {
						callSnippet = "Replace",
					},
				},
			},
		})

		-- ccls
		lspconfig.ccls.setup({
			capabilities = capabilities,
		})
	end,
}
