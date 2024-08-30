local opt = vim.opt

-- ファイル
opt.fileencoding = "utf-8" -- エンコーディングをutf-8に変更
opt.helplang = "ja" -- ヘルプファイルの言語は日本語

opt.number = true -- 行番号を有効
opt.wrap = true -- 行の折り返しを有効にします

opt.relativenumber = true -- 絶対値行番号にする
opt.modifiable = true

-- tabs & indentation
opt.tabstop = 2 -- タブ幅を2に設定
opt.shiftwidth = 2 -- シフト幅を2に設定
opt.expandtab = true -- タブ文字をスペースに置き換える
opt.autoindent = true -- 自動インデントを有効にする

-- clipboard
opt.clipboard = "unnamed" -- ヤンクをクリップボードに送る
