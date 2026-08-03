return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
    "wojciech-kulik/xcodebuild.nvim",
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    dapui.setup()

    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end

    dap.adapters.codelldb = {
      type = "server",
      port = "13000",
      executable = {
        command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
        args = {
          "--port",
          "13000",
          "--liblldb",
          "/Applications/Xcode-26.3.0-Release.Candidate.app/Contents/SharedFrameworks/LLDB.framework/Versions/A/LLDB",
        },
      },
    }

    dap.configurations.swift = {
      {
        name = "iOS App (xcodebuild.nvim)",
        type = "codelldb",
        request = "attach",
        program = require("xcodebuild.platform.device").get_program_path,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        waitFor = true,
      },
    }

    -- Ruby デバッグ (ruby/debug の rdbg を nvim-dap に接続)
    -- launch: rdbg を自動起動 / attach: 既存 rdbg(--open --port) に接続
    -- 前提: プロジェクトの Gemfile に `gem "debug"` を追加し bundle install 済みであること
    dap.adapters.ruby = function(callback, config)
      if config.request == "attach" then
        callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 38698 })
      else
        callback({
          type = "server",
          host = "127.0.0.1",
          port = "${port}",
          executable = {
            -- rdbg は必ず bundle 経由 (グローバル gem だとプロジェクトの gem ロードに失敗する)
            command = "bundle",
            args = { "exec", "rdbg", "--open", "--port", "${port}", "-c", "--", config.command, unpack(config.args or {}) },
          },
        })
      end
    end

    dap.configurations.ruby = {
      -- 現在開いている spec を 1 本デバッグ実行 (launch)
      {
        type = "ruby",
        name = "Debug current spec (rspec)",
        request = "launch",
        command = "bundle",
        args = function()
          return { "exec", "rspec", vim.fn.expand("%:p") }
        end,
        localfs = true,
      },
      -- 任意の Ruby ファイルを実行 (launch)
      {
        type = "ruby",
        name = "Debug current file (ruby)",
        request = "launch",
        command = "ruby",
        args = function()
          return { vim.fn.expand("%:p") }
        end,
        localfs = true,
      },
      -- 起動中の Rails サーバに attach
      -- 事前に `bundle exec rdbg --open --port 38698 -n --nonstop -c -- bin/rails server -p 3000` で起動しておく
      {
        type = "ruby",
        name = "Attach to Rails (rdbg :38698)",
        request = "attach",
        host = "127.0.0.1",
        port = 38698,
        localfs = true,
      },
    }

    vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
    vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Continue" })
    vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "Step Over" })
    vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Step Into" })
    vim.keymap.set("n", "<leader>dO", dap.step_out, { desc = "Step Out" })
    vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "Toggle DAP UI" })
    vim.keymap.set("n", "<leader>dr", dap.run_last, { desc = "Debug: run last" })
    vim.keymap.set("n", "<leader>dt", dap.terminate, { desc = "Debug: terminate" })
    vim.keymap.set("n", "<leader>dB", function()
      dap.set_breakpoint(vim.fn.input("Condition: "))
    end, { desc = "Conditional Breakpoint" })
    vim.keymap.set("n", "<leader>dd", "<cmd>XcodebuildDebug<cr>", { desc = "Xcode Debug" })
    vim.keymap.set("n", "<leader>dD", "<cmd>XcodebuildDebugStop<cr>", { desc = "Xcode Debug Stop" })
  end,
}
