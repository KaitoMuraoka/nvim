return {
	    "neovim/nvim-lspconfig",
	    dependencies = {
		    {'williamboman/mason.nvim', config = true},
		    'williamboman/mason-lspconfig.nvim',
	    },
	config = function()
    local lspconfig = require('lspconfig')
lspconfig.sourcekit.setup {
    capabilities = {
        workspace = {
            didChangeWatchedFiles = {
                dynamicRegistration = true,
            },
        },
    },
}

local cmp_nvim_lsp = require("cmp_nvim_lsp")
local capabilities = cmp_nvim_lsp.default_capabilities()
lspconfig.lua_ls.setup{
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
}

    vim.api.nvim_create_autocmd('LspAttach', {
        desc = 'LSP Actions',
        callback = function(args)
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, {noremap = true, silent = true})
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {noremap = true, silent = true})
        end,
    })
end,

}
