local opt = vim.opt

opt.number = true -- 行番号を有効
opt.wrap = true -- 行の折り返しを有効にします

opt.relativenumber = true -- 絶対値行番号にする

-- tabs & indentation
opt.tabstop = 2 -- 2 spaces for tabs (prettier default)
opt.shiftwidth = 2 -- 2 spaces for indent width
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one

-- clipboard
opt.clipboard = "unnamed" -- ヤンクをクリップボードに送る
