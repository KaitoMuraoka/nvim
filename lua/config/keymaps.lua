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
keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })

keymap.set("n", "<leader>fml", "<cmd>Telescope memo list<cr>", { desc = "Show memo list"})
-- format
keymap.set("n", "<leader>lf", function()
  vim.lsp.buf.format({ async = true })
end, { desc = "Format Lua code" })

-- neo tree
-- keymap.set("n", "<C-q>", "<cmd>Neotree close<CR>")
keymap.set("n", "<C-q>", "<cmd>Neotree toggle<CR>")

-- LazyGit
keymap.set("n", "<leader>lg", "<cmd>LazyGit<cr>", { desc = "LazyGit" })

-- opt
keymap.set("n", "<leader>gi", "<cmd>Octo issue list<CR>", { desc = "List Issues (Octo)" })
keymap.set("n", "<leader>gI", "<cmd>Octo issue search<CR>", { desc = "Search Issues (Octo)" })
keymap.set("n", "<leader>gp", "<cmd>Octo pr list<CR>", { desc = "List PRs (Octo)" })
keymap.set("n", "<leader>gP", "<cmd>Octo pr search<CR>", { desc = "Search PRs (Octo)" })
keymap.set("n", "<leader>gr", "<cmd>Octo repo list<CR>", { desc = "List Repos (Octo)" })
keymap.set("n", "<leader>gS", "<cmd>Octo search<CR>", { desc = "Search (Octo)" })

-- lsp
local opts = { noremap = true, silent = true }
local lspbuf = vim.lsp.buf
keymap.set("n", "gd", lspbuf.definition, { desc = "定義への移動" }) -- 定義への移動
keymap.set("n", "gD", lspbuf.declaration, { desc = "宣言への移動" }) -- 宣言へ移動
keymap.set("n", "gr", lspbuf.references, { desc = "参照箇所を表示" }) -- 参照箇所を表示
keymap.set("n", "K", lspbuf.hover, { desc = "ドキュメントの表示" }) -- ドキュメントの表示

-- WebSearhcer
keymap.set("v", "<leader>ss", ":lua require('websearcher').search_selected()<CR>", { desc = "Default Search" })
keymap.set("v", "<leader>se", ":lua require('websearcher').search_selected_with_engine()<CR>", { desc = "Select Search" })
keymap.set("v", "<leader>sm", ":lua require('websearcher').search_selected_multiple()<CR>", { desc = "Multiple Search" })

-- memo
keymap.set("n", "<leader>mn", ":MemoNew", { desc = "New Memo" })

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
