return {
  dir = vim.fn.stdpath("config") .. "/lua/custom/plugins/parse-keymap",
  name = "parse-keymap",
  config = function(opt)
    local parse_keymap = require("parse-keymap").setup()
    vim.api.nvim_create_autocmd("BufReadPre", {
      pattern = "*",
      callback = function()
        parse_keymap.del({
          ["in"] = { "x" },
        })
      end,
    })
  end,
}
