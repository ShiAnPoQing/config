local utils = require("utils.mark")

return {
  ["<F6>"] = {
    function()
    end,
    "n",
    -- { expr = true }
  },
  ["<CR>"] = {
    "<nop>",
    "n"
  }
}
