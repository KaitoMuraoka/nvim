local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)
vim.cmd([[highlight Normal guibg=NONE ctermbg=NONE]]) -- 背景をターミナルと同じにする

require("lazy").setup({
	spec = {
		-- import/override with your plugins
		{ import = "plugins" },
		{ import = "plugins.lsp" },
	},
	checker = {
		enabled = true, -- automatically check for plugin updates
		notify = false,
	},
	change_detection = {
		notify = false,
	},
})
