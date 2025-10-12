return {
  "MagicDuck/grug-far.nvim",
  cmd = "GrugFar",
  keys = {
    ["<leader>sr"] = {
      function()
        local grug = require("grug-far")
        local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
        grug.grug_far({
          transient = true,
          prefills = {
            filesFilter = ext and ext ~= "" and "*." .. ext or nil,
          },
        })
      end,
      { "n", "v" },
      desc = "Search and Replace",
    },
  },
  config = function()
    require("grug-far").setup({
      headerMaxWidth = 80,
    })
  end,
}
