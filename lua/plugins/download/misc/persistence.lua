return {
  "folke/persistence.nvim",
  event = "BufReadPre", -- this will only start session saving when an actual file was opened
  key = {
    ["<leader>qs"] = {
      function()
        require("persistence").load()
      end,
      "n",
      desc = "load the session for the current directory",
    },
    ["<leader>qS"] = {
      function()
        require("persistence").select()
      end,
      "n",
      desc = "select a session to load",
    },
    ["<leader>ql"] = {
      function()
        require("persistence").load({ last = true })
      end,
      "n",
      desc = "load the last session",
    },
    ["<leader>qd"] = {
      function()
        require("persistence").stop()
      end,
      "n",
      desc = "stop Persistence => session won't be saved on exit",
    },
  },
  config = function()
    require("persistence").setup({})
  end,
}
