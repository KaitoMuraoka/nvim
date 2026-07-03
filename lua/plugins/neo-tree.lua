-- neo-tree: ファイルツリー（netrw の代替）
return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  -- netrw をハイジャックするため、起動時に読み込んでおく必要がある
  -- （netrw の autocmd は lazy.nvim の cmd/keys による遅延読み込みより先に発火するため）
  lazy = false,
  keys = {
    { "<leader>w", "<cmd>Neotree toggle<cr>", desc = "Toggle file tree" },
  },
  config = function()
    require("neo-tree").setup({
      close_if_last_window = true,
      filesystem = {
        -- netrw を無効化し、ディレクトリを開いた際は現在のウィンドウを
        -- neo-tree に置き換える（旧 nvim-tree の挙動に合わせる）
        hijack_netrw_behavior = "open_current",
      },
    })

    -- neo-tree のツリーウィンドウでも行番号・相対行番号を表示する
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "neo-tree",
      callback = function()
        vim.opt_local.number = true
        vim.opt_local.relativenumber = true
      end,
    })
  end,
}
