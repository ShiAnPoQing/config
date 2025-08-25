return {
  dir = vim.fn.stdpath("config") .. "/lua/custom/plugins/parse-option",
  name = "parse-option",
  config = function(opt)
    require("parse-option").setup({
      paths = {
        "options/options",
        "options/typescript",
        "options/markdown",
        "options/css",
        "options/text",
        "options/help",
      },
    })
  end,
}
