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

-- neo tree
keymap.set("n", "<C-q>", "<cmd>Neotree close<CR>")
keymap.set("n", "<C-w>", "<cmd>Neotree toggle<CR>")

-- LazyGit
keymap.set("n", "<leader>lg", "<cmd>LazyGit<cr>", { desc = "LazyGit" })

-- opt
keymap.set("n", "<leader>gi", "<cmd>Octo issue list<CR>", { desc = "List Issues (Octo)" })
keymap.set("n", "<leader>gI", "<cmd>Octo issue search<CR>", { desc = "Search Issues (Octo)" })
keymap.set("n", "<leader>gp", "<cmd>Octo pr list<CR>", { desc = "List PRs (Octo)" })
keymap.set("n", "<leader>gP", "<cmd>Octo pr search<CR>", { desc = "Search PRs (Octo)" })
keymap.set("n", "<leader>gr", "<cmd>Octo repo list<CR>", { desc = "List Repos (Octo)" })
keymap.set("n", "<leader>gS", "<cmd>Octo search<CR>", { desc = "Search (Octo)" })

-- { "<leader>a", "", desc = "+assignee (Octo)", ft = "octo" },
-- { "<leader>c", "", desc = "+comment/code (Octo)", ft = "octo" },
-- { "<leader>l", "", desc = "+label (Octo)", ft = "octo" },
-- { "<leader>i", "", desc = "+issue (Octo)", ft = "octo" },
-- { "<leader>r", "", desc = "+react (Octo)", ft = "octo" },
-- { "<leader>p", "", desc = "+pr (Octo)", ft = "octo" },
-- { "<leader>v", "", desc = "+review (Octo)", ft = "octo" },
-- { "@", "@<C-x><C-o>", mode = "i", ft = "octo", silent = true },
-- { "#", "#<C-x><C-o>", mode = "i", ft = "octo", silent = true },
-- },
