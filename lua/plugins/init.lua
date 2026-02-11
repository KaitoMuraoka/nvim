return {




  -- Org-mode
  {
    "nvim-orgmode/orgmode",
    dependencies = {
      { "nvim-treesitter/nvim-treesitter" },
    },
    event = "VeryLazy",
    ft = { "org" },
    config = function()
      -- Orgmode設定
      require("orgmode").setup({
        org_agenda_files = { "~/org/**/*" },
        org_default_notes_file = "~/org/notes.org",

        -- TODO keywords
        org_todo_keywords = { "TODO", "DOING", "|", "DONE" },

        -- TODO keyword faces (色設定)
        org_todo_keyword_faces = {
          TODO = ":foreground #FF6B6B :weight bold",
          DOING = ":foreground #4ECDC4 :weight bold",
          DONE = ":foreground #95E1D3 :weight bold",
        },

        -- Mappings
        mappings = {
          org = {
            org_toggle_checkbox = "<leader>o<space>",
            org_todo = "<leader>ot",
            org_insert_todo_heading = "<leader>oi",
            org_clock_in = "<leader>oI",
            org_clock_out = "<leader>oO",
            org_set_tags_command = "<leader>oT",
            org_priority = "<leader>op",
            org_cycle = "<Tab>",
            org_global_cycle = "<S-Tab>",
            org_timestamp = "<leader>od",
            org_schedule = "<leader>os",
            org_deadline = "<leader>oD",
            org_archive_subtree = "<leader>oA",
            org_show_help = "g?",
          },
          agenda = {
            org_agenda_later = "f",
            org_agenda_earlier = "b",
            org_agenda_goto_today = ".",
            org_agenda_day_view = "vd",
            org_agenda_week_view = "vw",
            org_agenda_month_view = "vm",
            org_agenda_year_view = "vy",
            org_agenda_quit = "q",
          },
        },
      })
    end,
  },
}
