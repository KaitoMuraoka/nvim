return {
  "wojciech-kulik/xcodebuild.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-treesitter/nvim-treesitter",
    "folke/snacks.nvim", -- image snack でプレビュー画像を表示
  },
  config = function()
    require("xcodebuild").setup()

    vim.keymap.set("n", "<leader>X", "<cmd>XcodebuildPicker<cr>", { desc = "Xcode Actions" })
    vim.keymap.set("n", "<leader>xb", "<cmd>XcodebuildBuild<cr>", { desc = "Xcode Build" })
    vim.keymap.set("n", "<leader>xr", "<cmd>XcodebuildBuildRun<cr>", { desc = "Xcode Build & Run" })
    vim.keymap.set("n", "<leader>xt", "<cmd>XcodebuildTest<cr>", { desc = "Xcode Test" })
    vim.keymap.set("n", "<leader>xl", "<cmd>XcodebuildToggleLogs<cr>", { desc = "Xcode Toggle Logs" })
    vim.keymap.set("n", "<leader>xc", "<cmd>XcodebuildToggleCodeCoverage<cr>", { desc = "Toggle Coverage" })
    vim.keymap.set("n", "<leader>xo", "<cmd>XcodebuildOpenInXcode<cr>", { desc = "Open in Xcode" })
    vim.keymap.set("n", "<leader>xp", "<cmd>XcodebuildPreviewGenerateAndShow<cr>", { desc = "Xcode Preview" })
    vim.keymap.set("n", "<leader>xP", "<cmd>XcodebuildPreviewGenerateAndShow hotReload<cr>", { desc = "Xcode Preview (Hot Reload)" })
  end,
}
