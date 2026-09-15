-- Markdown標準の折りたたみ機能を有効化
vim.g.markdown_folding = 1

vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function()
		-- ファイルを開いた直後はすべて展開した状態にする
		vim.opt_local.foldlevel = 99
		-- ノーマルモードでTabキーを押すと折りたたみを切り替える(za)
		vim.keymap.set("n", "<Tab>", "za", { buffer = true, silent = true })
	end,
})
