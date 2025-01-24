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

vim.api.nvim_create_autocmd("InsertLeave", {
  pattern = "*",
  callback = function()
    -- ノーマルモードに戻るときにIMEをオフにする
    vim.fn.system(vim.g.im_select_command .. " " .. vim.g.im_select_default)
  end,
})

vim.api.nvim_create_autocmd("InsertEnter", {
  pattern = "*",
  callback = function()
    -- インサートモードに入ったときIMEを元の状態に戻す
    local current_ime = vim.fn.system(vim.g.im_select_command)
    if current_ime ~= vim.g.im_select_default then
      vim.g.last_used_ime = current_ime
    end
  end,
})

