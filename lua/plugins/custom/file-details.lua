return {
  dir = vim.fn.stdpath("config") .. "/lua/custom/plugins/file-details",
  name = "file-details",
  cmd = { "FileDetails" },
  config = function(opt)
    require("file-details").setup()
  end,
}
