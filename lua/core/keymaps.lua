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

keymap.set("n", "<C-c>", '"+y')

-- nvim-tree
keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")
keymap.set("n", "<leader>f", ":NvimTreeFindFile<CR>")

-- telescope
keymap.set("n", "<C-p>", "<cmd>Telescope find_files<cr>")
keymap.set("n", "<C-s>", "<cmd>Telescope live_grep<cr>")
keymap.set("n", "<C-g>", "<cmd>Telescope grep_string<cr>")
keymap.set("n", "<C-b>", "<cmd>Telescope buffers<cr>")
keymap.set("n", "<C-h>", "<cmd>Telescope help_tags<cr>")
