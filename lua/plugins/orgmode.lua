return {
  -- Orgmode: Core org-mode functionality
  {
    "nvim-orgmode/orgmode",
    event = "VeryLazy",
    ft = { "org" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("orgmode").setup({
        org_agenda_files = "~/org/**/*",
        org_default_notes_file = "~/org/main.org",

        -- TODO states
        org_todo_keywords = { "TODO", "DOING", "|", "DONE" },

        -- Log completion time
        org_log_done = "time",

        -- Use LOGBOOK drawer for clock entries
        org_clock_in_to_logbook = true,

        -- Capture templates
        org_capture_templates = {
          -- Personal (main.org)
          p = {
            description = "Personal",
            template = "",
            target = "~/org/main.org",
            subtemplates = {
              t = {
                description = "Task",
                template = "** TODO %?\n   SCHEDULED: %t\n   :PROPERTIES:\n   :CREATED: %U\n   :END:",
                target = "~/org/main.org",
                headline = "Tasks",
              },
              n = {
                description = "Note",
                template = "** %?\n   :PROPERTIES:\n   :CREATED: %U\n   :END:",
                target = "~/org/main.org",
                headline = "Notes",
              },
              j = {
                description = "Journal",
                template = "** %<%Y-%m-%d %A>\n*** %?",
                target = "~/org/main.org",
                headline = "Journal",
              },
            },
          },
          -- Work (work.org)
          w = {
            description = "Work",
            template = "",
            target = "~/org/work.org",
            subtemplates = {
              t = {
                description = "Task",
                template = "** TODO %?\n   SCHEDULED: %t\n   :PROPERTIES:\n   :CREATED: %U\n   :END:",
                target = "~/org/work.org",
                headline = "Tasks",
              },
              n = {
                description = "Note",
                template = "** %?\n   :PROPERTIES:\n   :CREATED: %U\n   :END:",
                target = "~/org/work.org",
                headline = "Notes",
              },
              m = {
                description = "Meeting",
                template = "** %?\n   :PROPERTIES:\n   :CREATED: %U\n   :ATTENDEES:\n   :END:\n*** Agenda\n*** Notes\n*** Action Items",
                target = "~/org/work.org",
                headline = "Meetings",
              },
            },
          },
        },

        -- Key mappings
        mappings = {
          global = {
            org_agenda = "<leader>oa",
            org_capture = "<leader>oc",
          },
          org = {
            org_todo = "<leader>ot",
            org_clock_in = "<leader>oxi",
            org_clock_out = "<leader>oxo",
            org_clock_cancel = "<leader>oxc",
            org_clock_goto = "<leader>oxg",
            org_set_effort = "<leader>oxe",
          },
        },
      })
    end,
  },

  -- Org-bullets: Visual decoration for headings
  {
    "akinsho/org-bullets.nvim",
    ft = { "org" },
    config = function()
      require("org-bullets").setup({
        concealcursor = true,
        symbols = {
          headlines = { "◉", "○", "◆", "◇", "★" },
          checkboxes = {
            half = { "", "OrgTSCheckboxHalfChecked" },
            done = { "✓", "OrgDone" },
            todo = { " ", "OrgTODO" },
          },
        },
      })
    end,
  },

  -- Telescope-orgmode: Fuzzy search for org files
  {
    "joaomsa/telescope-orgmode.nvim",
    dependencies = {
      "nvim-orgmode/orgmode",
      "nvim-telescope/telescope.nvim",
    },
    ft = { "org" },
    config = function()
      require("telescope").load_extension("orgmode")

      -- Search headlines
      vim.keymap.set("n", "<leader>os", function()
        require("telescope").extensions.orgmode.search_headings()
      end, { desc = "Org Search Headlines" })

      -- Refile headline
      vim.keymap.set("n", "<leader>or", function()
        require("telescope").extensions.orgmode.refile_heading()
      end, { desc = "Org Refile" })

      -- Insert link
      vim.keymap.set("n", "<leader>ol", function()
        require("telescope").extensions.orgmode.insert_link()
      end, { desc = "Org Insert Link" })
    end,
  },

  -- Headlines: Highlight for headings
  {
    "lukas-reineke/headlines.nvim",
    dependencies = "nvim-treesitter/nvim-treesitter",
    ft = { "org", "markdown", "norg" },
    config = function()
      require("headlines").setup({
        org = {
          headline_highlights = {
            "Headline1",
            "Headline2",
            "Headline3",
            "Headline4",
            "Headline5",
          },
          codeblock_highlight = "CodeBlock",
          dash_highlight = "Dash",
          quote_highlight = "Quote",
        },
      })

      -- Define highlight groups
      vim.api.nvim_set_hl(0, "Headline1", { bg = "#1e2718" })
      vim.api.nvim_set_hl(0, "Headline2", { bg = "#21262d" })
      vim.api.nvim_set_hl(0, "Headline3", { bg = "#262626" })
      vim.api.nvim_set_hl(0, "Headline4", { bg = "#262626" })
      vim.api.nvim_set_hl(0, "Headline5", { bg = "#262626" })
      vim.api.nvim_set_hl(0, "CodeBlock", { bg = "#1c1c1c" })
      vim.api.nvim_set_hl(0, "Dash", { fg = "#565f89" })
      vim.api.nvim_set_hl(0, "Quote", { fg = "#565f89", italic = true })
    end,
  },
}
