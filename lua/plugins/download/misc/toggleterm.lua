return {
  "akinsho/toggleterm.nvim",
  -- version = "*",
  cmd = {
    "ToggleTerm",
    "ToggleTermSetName",
    "ToggleTermToggleAll",
    "ToggleTermSendCurrentLine",
    "ToggleTermSendVisualLines",
    "ToggleTermSendVisualSelection",
    "TermExec",
    "TermNew",
    "TermSelect",
  },
  key = {
    ["<leader>tf"] = {
      function()
        require("toggleterm").toggle(vim.v.count, 0, vim.uv.cwd(), "float")
      end,
      "n",
      desc = "Toggle Terminal[float]",
    },
    ["<leader>tF"] = {
      function()
        require("toggleterm").toggle(vim.v.count, 0, vim.fn.expand("%:p:h"), "float")
      end,
      "n",
      desc = "Toggle Terminal[float][cursor file path]",
    },
    ["<leader>th"] = {
      function()
        require("toggleterm").toggle(vim.v.count, 15, vim.uv.cwd(), "horizontal")
      end,
      "n",
      desc = "Toggle Terminal Horizontal",
    },
    ["<leader>tH"] = {
      function()
        require("toggleterm").toggle(vim.v.count, 15, vim.fn.expand("%:p:h"), "horizontal")
      end,
      "n",
      desc = "Toggle Terminal Horizontal[cursor file path]",
    },
    ["<leader>tv"] = {
      function()
        require("toggleterm").toggle(vim.v.count, vim.o.columns * 0.4, vim.uv.cwd(), "vertical")
      end,
      "n",
      desc = "Toggle Terminal Vertical",
    },
    ["<leader>tV"] = {
      function()
        require("toggleterm").toggle(vim.v.count, vim.o.columns * 0.4, vim.fn.expand("%:p:h"), "vertical")
      end,
      "n",
      desc = "Toggle Terminal Vertical[cursor file path]",
    },
    ["<leader>tt"] = {
      function()
        require("toggleterm").toggle(vim.v.count, 0, vim.uv.cwd(), "tab")
      end,
      "n",
      desc = "Toggle Terminal Tabpage",
    },
    ["<leader>tT"] = {
      function()
        require("toggleterm").toggle(vim.v.count, 0, vim.fn.expand("%:p:h"), "tab")
      end,
      "n",
      desc = "Toggle Terminal Tabpage[cursor file path]",
    },
    ["<leader>tn"] = {
      "<cmd>ToggleTermSetName<cr>",
      "n",
      desc = "Set Terminal Name",
    },
    ["<leader>ts"] = {
      "<cmd>TermSelect<cr>",
      "n",
      desc = "Select Terminal",
    },
    ["<leader>tM"] = {
      "ToggleTermToggleAll",
      "n",
      desc = "Toggle Terminal for all",
    },
  },
  config = function()
    require("toggleterm").setup({
      float_opts = {
        title_pos = "center",
        -- title = { "Terminal", "Error" },
      },
    })
  end,
}
