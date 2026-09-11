vim.api.nvim_create_user_command("CommandProxy", function(ev)
  local fargs = ev.fargs
  require("command-proxy").command[fargs[1]](vim.list_slice(fargs, 2))
end, {
  nargs = "+",
  complete = function(_, cmdline)
    local cmd_info = vim.api.nvim_parse_cmd(cmdline, {})
    if cmd_info.args then
      return require("command-proxy.util").get_command_proxy_completion(#cmd_info.args + 1)
    end
  end,
})
