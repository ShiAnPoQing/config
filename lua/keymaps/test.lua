local utils = require("utils.mark")

return {
  ["<F6>"] = {
    function()
      print((155 - 1 - 26) / 26)
    end,
    "n",
    -- { expr = true }
  },
  ["<CR>"] = {
    "<nop>",
    "n"
  }
}
