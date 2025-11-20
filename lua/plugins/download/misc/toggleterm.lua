return {
  "akinsho/toggleterm.nvim",
  version = "*",
  cmd = "ToggleTerm",
  keys = {
    {
      "<leader>tm",
      function()
        local count = vim.v.count
        if count > 0 then
          vim.cmd(count .. "ToggleTerm")
        else
          vim.cmd("ToggleTerm")
        end
      end,
      desc = "Toggle Terminal",
    },
    {
      "<leader>ts",
      "<cmd>TermSelect<cr>",
      desc = "Select Terminal",
    },
    {
      "<leader>tM",
      "ToggleTermToggleAll",
      desc = "Toggle Terminal for all",
    },
  },
  config = function()
    require("toggleterm").setup({})
  end,
}
