return {
  "norcalli/snippets.nvim",
  config = function ()
    require("snippets").use_suggested_mappings()
  end,
}
