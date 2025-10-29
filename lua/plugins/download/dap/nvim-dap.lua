return {
  "mfussenegger/nvim-dap",
  depend = {
    "rcarriga/nvim-dap-ui",
    "jbyuki/one-small-step-for-vimkind",
    "theHamsta/nvim-dap-virtual-text",
  },
  ft = { "c", "cpp" },
  config = function()
    require("nvim-dap-virtual-text").setup({})
    require("dapui").setup()
    local dap = require("dap")
    local dapui = require("dapui")
    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end
    dap.configurations.lua = {
      {
        type = "nlua",
        request = "attach",
        name = "Attach to running Neovim instance",
      },
    }
    dap.configurations.c = {
      {
        name = "Launch",
        type = "gdb",
        request = "launch",
        program = function()
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,
        args = {}, -- provide arguments if needed
        cwd = "${workspaceFolder}",
        stopAtBeginningOfMainSubprogram = false,
      },
      {
        name = "Select and attach to process",
        type = "gdb",
        request = "attach",
        program = function()
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,
        pid = function()
          local name = vim.fn.input("Executable name (filter): ")
          return require("dap.utils").pick_process({ filter = name })
        end,
        cwd = "${workspaceFolder}",
      },
      {
        name = "Attach to gdbserver :1234",
        type = "gdb",
        request = "attach",
        target = "localhost:1234",
        program = function()
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,
        cwd = "${workspaceFolder}",
      },
    }
    dap.adapters.nlua = function(callback, config)
      callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 })
    end
    dap.adapters.gdb = {
      type = "executable",
      command = "gdb",
      args = { "--interpreter=dap", "--eval-command", "set print pretty on" },
    }
    vim.keymap.set("n", "<leader>db", require("dap").toggle_breakpoint, { noremap = true })
    vim.keymap.set("n", "<leader>dc", require("dap").continue, { noremap = true })
    vim.keymap.set("n", "<leader>do", require("dap").step_over, { noremap = true })
    vim.keymap.set("n", "<leader>di", require("dap").step_into, { noremap = true })
    vim.keymap.set("n", "<leader>dl", function()
      require("osv").launch({ port = 8086 })
    end, { noremap = true })
    vim.keymap.set("n", "<leader>dw", function()
      local widgets = require("dap.ui.widgets")
      widgets.hover()
    end)
    vim.keymap.set("n", "<leader>df", function()
      local widgets = require("dap.ui.widgets")
      widgets.centered_float(widgets.frames)
    end)
  end,
}
