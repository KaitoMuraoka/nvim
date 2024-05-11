-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--vim.opt.relativenumber = false
local opt = vim.opt

-- line numbers
opt.number = true

-- タブとインデント
opt.tabstop = 2 -- タブの幅を2空ける（デフォルトの方がきれい）
opt.shiftwidth = 2 -- インデント幅を2スペースにする
opt.expandtab = true -- タブをスペースに展開する
opt.autoindent = true -- 新しい行を始めるときに現在の行のインデントをコピーする

-- 行の折り返し
opt.wrap = false -- 行の折り返しを無効にする

-- 検索設定
opt.ignorecase = true -- 検索時に大文字と小文字を区別しない。
opt.smartcase = true -- 検索に大文字と小文字が混在している場合、大文字と小文字を区別する。

-- 外観--
-- nightfly colorchemeが動作するようにtermguicolorsをオンにする。
-- (iterm2または他のトゥルーカラーターミナルを使用する必要があります)
opt.termguicolors = true
opt.background = "dark" -- 明暗をつけられるカラースキームは暗くする。
opt.signcolumn = "yes" -- テキストがずれないように符号列を表示する。

-- バックスペース
opt.backspace = "indent,eol,start" -- インデント、行末、挿入モードの開始位置でバックスペースを許可する。

-- クリップボード
opt.clipboard:append("unnamedplus") --システムのクリップボードをデフォルトのレジスタとして使う-- ウィンドウの分割

opt.splitright = true -- 垂直ウィンドウを右に分割
opt.splitbelow = true -- 水平ウィンドウを下に分割する

-- swapfileをオフにする
opt.swapfile = false
