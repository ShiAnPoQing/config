local utils = require("utils.mark")


return {
  ["<F6>"] = {
    function()
      -- vim.api.nvim_feedkeys("diw", "n", false)
      return "diw"
    end,
    "n",
    -- { expr = true }
  },
  ["<CR>"] = {
    "<nop>",
    "n"
  }
}
