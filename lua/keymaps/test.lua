return {
  ["<F6>"] = {
    function()
      local c = vim.fn.getcharstr()
      print(c)
    end,
    "n"
  },
}
