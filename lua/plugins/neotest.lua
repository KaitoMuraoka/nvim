return {
  -- テスト実行: rspec / minitest 両対応
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "olimorris/neotest-rspec",
    "zidhuss/neotest-minitest",
  },
  ft = { "ruby" },
  config = function()
    require("neotest").setup({
      adapters = {
        require("neotest-rspec"),
        require("neotest-minitest"),
      },
    })
    local nt = require("neotest")
    -- <leader>t* は Terminal が使用済みのため <leader>T* に割り当て
    vim.keymap.set("n", "<leader>Tn", function() nt.run.run() end, { desc = "Test: nearest" })
    vim.keymap.set("n", "<leader>Tf", function() nt.run.run(vim.fn.expand("%")) end, { desc = "Test: file" })
    vim.keymap.set("n", "<leader>Ts", function() nt.summary.toggle() end, { desc = "Test: summary" })
    vim.keymap.set("n", "<leader>To", function() nt.output.open({ enter = true }) end, { desc = "Test: output" })
  end,
}
