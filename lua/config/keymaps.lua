vim.g.mapleader = " "

local keymap = vim.keymap

keymap.set("n", "<leader>tt", ":terminal<CR>", { desc = "open terminal" })

-- Telescope
local builtin = require("telescope.builtin")
keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Search for a string" })
keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Live open buffers in neovim instance" })
keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "List available help tags" })
keymap.set("n", "<leader>fc", builtin.git_branches, { desc = "Lists git commits" })
