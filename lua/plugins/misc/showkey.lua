return {
  "nvzone/showkeys",
  config = function()
    require("showkeys").setup({})
    vim.cmd("ShowkeysToggle")
  end,
}
