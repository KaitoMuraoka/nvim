vim.g.mapleader = " "

local keymap = vim.keymap

keymap.set("n", "<leader>tt", ":terminal<CR>", { desc = "open terminal" })
