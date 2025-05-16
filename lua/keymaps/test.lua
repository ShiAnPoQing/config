local utils = require("utils.mark")


return {
  ["<F6>"] = {
    function()
      local char = vim.fn.nr2char(vim.fn.getchar())
      print(char)
    end,
    "n",
    -- { expr = true }
  },
  ["<CR>"] = {
    "<nop>",
    "n"
  }
}
