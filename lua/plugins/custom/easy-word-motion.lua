return {
  dir = vim.fn.stdpath("config") .. "/lua/custom/plugins/word-easy-motion",
  name = "word-easy-motion",
  config = function(opt)
    require("custom.plugins.word-easy-motion").setup()
  end
}
