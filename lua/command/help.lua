--- new tab help
vim.api.nvim_create_user_command("Thelp", function(ev)
  vim.cmd("tab help" .. (ev.bang and "! " or " ") .. ev.args)
end, {
  nargs = "?",
  complete = "help",
  bang = true,
  bar = true,
})
vim.api.nvim_create_user_command("Th", function(ev)
  vim.cmd("tab help" .. (ev.bang and "! " or " ") .. ev.args)
end, {
  nargs = "?",
  complete = "help",
  bang = true,
  bar = true,
})

--- vertical help
vim.api.nvim_create_user_command("Vhelp", function(ev)
  vim.cmd("vert help" .. (ev.bang and "! " or " ") .. ev.args)
end, {
  nargs = "?",
  complete = "help",
  bang = true,
  bar = true,
})
vim.api.nvim_create_user_command("Vh", function(ev)
  vim.cmd("vert help" .. (ev.bang and "! " or " ") .. ev.args)
end, {
  nargs = "?",
  complete = "help",
  bang = true,
  bar = true,
})

--- current window help
vim.api.nvim_create_user_command("Help", function(ev)
  local subject = ev.args
  local buf = vim.api.nvim_get_current_buf()
  local help = "help" .. (ev.bang and "! " or " ") .. subject
  local buftype = vim.api.nvim_get_option_value("buftype", { buf = buf })
  if buftype == "help" then
    vim.cmd(help)
    return
  end
  vim.api.nvim_set_option_value("buftype", "help", { buf = buf })
  vim.cmd(help)
  if vim.api.nvim_get_current_buf() ~= buf then
    vim.api.nvim_buf_call(buf, function()
      vim.api.nvim_set_option_value("buftype", buftype, { buf = buf })
    end)
  end
end, {
  nargs = "?",
  complete = "help",
  bang = true,
  bar = true,
})
