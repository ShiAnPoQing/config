return {
  dir = vim.fn.stdpath("config") .. "/lua/custom/plugins/show-file-info",
  name = "show-file-info",
  cmd = { "ShowFileInfo" },
  config = function(opt)
    require("custom.plugins.show-file-info").setup()
  end
}
