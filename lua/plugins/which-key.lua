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
      { "<leader>o", group = "Org" },
      { "<leader>ox", group = "Org Clock" },
    })
  end,
}
