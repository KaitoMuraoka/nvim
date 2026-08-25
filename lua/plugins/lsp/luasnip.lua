return {
  -- スニペット本体 (blink.cmp の snippets プリセットから利用する)
  "L3MON4D3/LuaSnip",
  dependencies = { "rafamadriz/friendly-snippets" },
  config = function()
    local luasnip = require("luasnip")

    -- friendly-snippets (ruby/rails/eruby 等) を読み込む
    require("luasnip.loaders.from_vscode").lazy_load()

    -- ruby-lsp は RBS の `def self?.foo` 宣言をインスタンスメソッドとして
    -- インデックスしないため (rbs_indexer.rb の real_owner 判定)、
    -- Kernel#gets / Kernel#puts などが補完に出ない。snippets/ で補う
    require("luasnip.loaders.from_lua").lazy_load({
      paths = { vim.fn.stdpath("config") .. "/snippets" },
    })

    -- Rails スニペット(create_table 等)は filetype "rails" 紐付けのため、
    -- ruby/eruby バッファでも展開できるよう拡張する
    -- (ruby-lsp は ActiveRecord::Migration[x] のスーパークラスを解決できず
    --  マイグレーション内の DSL 補完が出ないため、スニペットで補う)
    luasnip.filetype_extend("ruby", { "rails" })
    luasnip.filetype_extend("eruby", { "rails" })
  end,
}
