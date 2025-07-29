return {
  dir = vim.fn.stdpath("config") .. "/lua/custom/plugins/win-action",
  name = "win-action",
  cmd = { "WindowFocus", "WindowExchange" },
  config = function(opt)
    require("custom.plugins.win-action").setup()
  end,
}
