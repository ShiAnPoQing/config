return {
  "folke/trouble.nvim",
  cmd = "Trouble",
  keys = {
    ["<leader>xx"] = {
      "<cmd>Trouble diagnostics toggle<cr>",
      "n",
      desc = "Diagnostics (Trouble)",
    },
    ["<leader>xX"] = {
      "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
      "n",
      desc = "Buffer Diagnostics (Trouble)",
    },
    ["<leader>cs"] = {
      "<cmd>Trouble symbols toggle focus=false<cr>",
      "n",
      desc = "Symbols (Trouble)",
    },
    ["<leader>cl"] = {
      "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
      "n",
      desc = "LSP Definitions / references / ... (Trouble)",
    },
    ["<leader>xL"] = {
      "<cmd>Trouble loclist toggle<cr>",
      "n",
      desc = "Location List (Trouble)",
    },
    ["<leader>xQ"] = {
      "<cmd>Trouble qflist toggle<cr>",
      "n",
      desc = "Quickfix List (Trouble)",
    },
  },
  config = function()
    require("trouble").setup()
  end,
}
