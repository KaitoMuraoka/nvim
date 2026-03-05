return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  config = function()
    local wk = require("which-key")
    wk.setup()

    wk.add({
      { "<leader>f", group = "Find" },
      { "<leader>c", group = "Code" },
      { "<leader>r", group = "Refactor" },
      { "<leader>x", group = "Xcode" },
      { "<leader>d", group = "Debug" },
      { "<leader>t", group = "Terminal" },
      { "<leader>e", group = "Diagnostics" },
    })
  end,
}
