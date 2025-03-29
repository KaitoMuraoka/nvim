return {
  --dir = "~/personalDevelop/neovim-plugin/websearcher.nvim/", -- クローン
  "KaitoMuraoka/websearcher.nvim",
  config = {
-- The shell command to use to open the URL.
-- As an empty string, it defaults to your OS defaults("open" for macOS, "xdg-open" for Linux)
open_cmd = "",

-- Specify search engine. Default is Google.
-- See the search_engine section for currently registered search engines
search_engine = "Google",

-- Use W3M in a floating window. Default is False
use_w3m = false,

-- Add custom search_engines.
-- See the search_engine section for currently registered search engines
search_engines = {},
}
}

