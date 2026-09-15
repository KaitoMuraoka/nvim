return {
  -- 補完エンジン (Rust 製 fuzzy matcher / シグネチャヘルプ / cmdline 補完を内蔵)
  "saghen/blink.cmp",
  dependencies = { "L3MON4D3/LuaSnip" },
  -- v2 は開発中のため v1 系に固定する
  version = "1.*",
  event = { "InsertEnter", "CmdlineEnter" },
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    snippets = { preset = "luasnip" },

    -- <CR> で確定する既存の操作感を保ちつつ、Tab/S-Tab で候補を移動する
    keymap = {
      preset = "enter",
      ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
      ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
      ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
      ["<C-e>"] = { "hide", "fallback" },
      ["<C-b>"] = { "scroll_documentation_up", "fallback" },
      ["<C-f>"] = { "scroll_documentation_down", "fallback" },
    },

    appearance = { nerd_font_variant = "mono" },

    completion = {
      -- 候補を選ぶだけでドキュメントを表示する (VSCode の挙動)
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
        window = { border = "rounded" },
      },
      menu = {
        border = "rounded",
        draw = {
          columns = {
            { "kind_icon" },
            { "label", "label_description", gap = 1 },
            { "source_name" },
          },
        },
      },
      -- 選択中の候補をインラインにプレビューする
      ghost_text = { enabled = true },
      -- 先頭候補を選択状態にするが挿入はせず、<CR> で確定させる
      list = { selection = { preselect = true, auto_insert = false } },
      -- 関数を確定したときに括弧と引数プレースホルダを補う
      accept = { auto_brackets = { enabled = true } },
    },

    -- 入力中に引数のヒントをポップアップする
    signature = {
      enabled = true,
      window = { border = "rounded" },
    },

    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
      -- vim-dadbod-completion は blink 用モジュールを同梱しているので compat 層は不要
      per_filetype = {
        sql = { "dadbod", "snippets", "buffer" },
        mysql = { "dadbod", "snippets", "buffer" },
        plsql = { "dadbod", "snippets", "buffer" },
      },
      providers = {
        dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
      },
    },

    fuzzy = { implementation = "prefer_rust_with_warning" },
  },
  opts_extend = { "sources.default" },
}
