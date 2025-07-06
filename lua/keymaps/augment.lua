return {
  ["<C-CR>"] = {
    function()
      vim.cmd('call augment#Accept("\\n")')
    end,
    "i"
  }
}
