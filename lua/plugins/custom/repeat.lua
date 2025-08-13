return {
  dir = vim.fn.stdpath("config") .. "/lua/custom/plugins/repeat",
  name = "repeat",
  config = function(opt)
    require("repeat").setup({})
  end,
}
