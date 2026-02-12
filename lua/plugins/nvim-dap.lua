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

    vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
    vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Continue" })
    vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "Step Over" })
    vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Step Into" })
    vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "Toggle DAP UI" })
    vim.keymap.set("n", "<leader>dd", "<cmd>XcodebuildDebug<cr>", { desc = "Xcode Debug" })
    vim.keymap.set("n", "<leader>dD", "<cmd>XcodebuildDebugStop<cr>", { desc = "Xcode Debug Stop" })
  end,
}
