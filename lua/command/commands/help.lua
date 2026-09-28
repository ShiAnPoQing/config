--- new tab help

my.command.define("TAB_HELP", "Thelp", function(ev)
  vim.cmd("tab help" .. (ev.bang and "! " or " ") .. ev.args)
end, {
  nargs = "?",
  complete = "help",
  bang = true,
  bar = true,
})

my.command.define("TAB_H", "Th", function(ev)
  vim.cmd("tab help" .. (ev.bang and "! " or " ") .. ev.args)
end, {
  nargs = "?",
  complete = "help",
  bang = true,
  bar = true,
})

--- vertical help
my.command.define("VERTICAL_HELP", "Vhelp", function(ev)
  vim.cmd("vert help" .. (ev.bang and "! " or " ") .. ev.args)
end, {
  nargs = "?",
  complete = "help",
  bang = true,
  bar = true,
})

my.command.define("VERTICAL_H", "Vh", function(ev)
  vim.cmd("vert help" .. (ev.bang and "! " or " ") .. ev.args)
end, {
  nargs = "?",
  complete = "help",
  bang = true,
  bar = true,
})


--- @param ev vim.api.keyset.create_user_command.command_args
local cwindow_help_cmd = function(ev)
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
end

local cwindow_help_cmd_opts = {
  nargs = "?",
  complete = "help",
  bang = true,
  bar = true,
}

my.command.define("HELP", "Help", cwindow_help_cmd, cwindow_help_cmd_opts)
my.command.define("H", "H", cwindow_help_cmd, cwindow_help_cmd_opts)
