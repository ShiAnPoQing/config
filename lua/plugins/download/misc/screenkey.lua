return {
  "NStefan002/screenkey.nvim",
  version = "main", -- or branch = "main", to use the latest commit
  cmd = "Screenkey",
  config = function()
    require("screenkey").setup()
  end,
}
