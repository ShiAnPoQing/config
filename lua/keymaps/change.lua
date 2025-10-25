return {
  ["gi"] = {
    function()
      local changelist = vim.fn.getchangelist(vim.api.nvim_get_current_buf())
      local idx = changelist[2]
      if idx > 0 then
        return "g;"
      else
        vim.notify("Already at the start change")
      end
    end,
    "n",
    expr = true,
    desc = "Go to [count] older position in change list.",
  },
  ["go"] = {
    function()
      local changelist = vim.fn.getchangelist(vim.api.nvim_get_current_buf())
      local list = changelist[1]
      local idx = changelist[2]
      if idx < #list - 1 then
        return "g,"
      else
        vim.notify("Already at the last change")
      end
    end,
    "n",
    expr = true,
    desc = "Go to [count] newer position in change list.",
  },
}
