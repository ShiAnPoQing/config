return {
  dir = vim.fn.stdpath("config") .. "/lua/custom/plugins/word-move",
  name = "word-move",
  config = function(opt)
    require("custom.plugins.word-move").setup()
  end
}
