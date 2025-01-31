return {
  "chipsenkbeil/org-roam.nvim",
  tag = "0.1.1",
  dependencies = {
    {
      "nvim-orgmode/orgmode",
    },
  },
  config = function()
    require("org-roam").setup({
      directory = "~/ghq/note/",
      -- optional
      -- org_files = {
      --   "~/another_org_dir",
      --   "~/some/folder/*.org",
      --   "~/a/single/org_file.org",
      -- }
    })
  end
}
