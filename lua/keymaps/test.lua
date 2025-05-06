return {
  ["<F6>"] = {
    function()
      local c = vim.regex("\\k\\+")
      print(c)
    end,
    "n"
  },
}
