return {
  "folke/flash.nvim",
  keys = {
    {
      "0f",
      function()
        require("flash").jump()
      end,
      mode = { "n", "x", "o" },
      desc = "Flash",
    },
    {
      "0F",
      function()
        require("flash").treesitter()
      end,
      mode = { "n", "x", "o" },
      desc = "Flash Treesitter",
    },
    {
      "0r",
      function()
        require("flash").remote()
      end,
      mode = "o",
      desc = "Remote Flash",
    },
    {
      "0R",
      function()
        require("flash").treesitter_search()
      end,
      mode = { "o", "x" },
      desc = "Treesitter Search",
    },
    {
      "<c-s>",
      function()
        require("flash").toggle()
      end,
      mode = { "c" },
      desc = "Toggle Flash Search",
    },
  },
  config = function()
    require("flash").setup({})
  end,
}
