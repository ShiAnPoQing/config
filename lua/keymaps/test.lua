local utils = require("utils.mark")


return {
  ["<F6>"] = {
    function()
      vim.api.nvim_exec2([[
      execute "normal! \<Esc>"
      ]], {})
      print(utils.get_visual_mark(true))
    end,
    "x"
  },
}
