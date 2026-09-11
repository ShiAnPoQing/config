vim.api.nvim_create_user_command("Ts", function(ev)
  local tag = ev.args
  require("neo-tagstack").tselect(tag)
end, {
  nargs = 1,
})
