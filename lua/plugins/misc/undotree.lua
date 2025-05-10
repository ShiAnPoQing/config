return {
  "mbbill/undotree",
  config = function()
    vim.keymap.set("n", ";u", vim.cmd.UndotreeToggle)
  end
}
