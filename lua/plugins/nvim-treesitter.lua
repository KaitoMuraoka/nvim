return {
  -- Treesitter: シンタックスハイライト
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    require("nvim-treesitter").install({
      "lua",
      "vim",
      "vimdoc",
      "javascript",
      "typescript",
      "tsx",
      "python",
      "html",
      "css",
      "json",
      "yaml",
      "markdown",
      "markdown_inline",
      "bash",
      "go",
      "rust",
      "c",
      "cpp",
      "prisma",
      "kotlin",
      "java",
      "swift",
    })

    vim.api.nvim_create_autocmd("FileType", {
      callback = function()
        pcall(vim.treesitter.start)
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
}
