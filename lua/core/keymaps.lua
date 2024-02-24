vim.g.mapleader = " "

local keymap = vim.keymap

-- general keymaps

-- keymap.set("i", "jk", "<ESC>") -- When in internal mode, typing "jk" behaves the same as pressing esc key.
-- Modes
--   normal_mode = 'n',
--   insert_mode = 'i',
--   visual_mode = 'v',
--   visual_block_mode = 'x',
--   term_mode = 't',
--   command_mode = 'c',

-- nvim-tree
keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")
