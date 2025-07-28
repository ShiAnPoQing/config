return {
  dir = vim.fn.stdpath("config") .. "/lua/custom/plugins/register-control",
  name = "register-control",
  cmd = { "RegisterOpen" },
  config = function(opt)
    require("custom.plugins.register-control").setup()
  end
}
