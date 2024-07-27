return {
	"hrsh7th/nvim-cmp",
	version = false,
	event = "InsertEnter",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-buffer",
		"L3MON4D3/LuaSnip",
	},
	config = function()
		local cmp = require("cmp")
		local luasnip = require("cmp")
		local opts = {
			-- Where to get completion results from
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "buffer" },
				{ name = "path" },
			}),
			mapping = cmp.mapping.preset.insert({
				-- Make 'enter' key select the completion
				["<CR>"] = cmp.mapping.confirm({ select = true }),
				-- Super-tab behavior
				["<tab>"] = cmp.mapping(function(original)
					if cmp.visible() then
						cmp.select_next_item() -- run completion selection if completing
					elseif luasnip.expand_or_jumpable() then
						luasnip.expand_or_jump() -- expand snippets
					else
						original() -- run the original behavior if not completing
					end
				end, { "i", "s" }),
				["<S-tab>"] = cmp.mapping(function(original)
					if cmp.visual() then
						cmp.select_prev_item()
					elseif luasnip.expand_or_jumpable() then
						luasnip.jump(-1)
					else
						original()
					end
				end, { "i", "s" }),
			}),
			snippets = {
				expand = function(args)
					luasnip.lsp_expand(args)
				end,
			},
		}
		cmp.setup(opts)
	end,
}
