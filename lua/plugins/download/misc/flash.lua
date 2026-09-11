return {
  "folke/flash.nvim",
  key = {
    ["0s"] = {
      function()
        require("flash").jump()
      end,
      { "n", "x", "o" },
      desc = "Flash",
    },
    ["0R"] = {
      function()
        --- test
        --- test
        --- test
        require("flash").treesitter()
      end,
      { "n", "x", "o" },
      desc = "Flash Treesitter",
    },
    ["0r"] = {
      function()
        require("flash").remote()
      end,
      "n",
      desc = "Remote Flash",
    },
    -- ["0R"] = {
    --   function()
    --     require("flash").treesitter_search()
    --   end,
    --   { "o", "x" },
    --   desc = "Treesitter Search",
    -- },
    ["<c-s>"] = {
      function()
        require("flash").toggle()
      end,
      { "c" },
      desc = "Toggle Flash Search",
    },
  },
  config = function()
    require("flash").setup({})
  end,
}
