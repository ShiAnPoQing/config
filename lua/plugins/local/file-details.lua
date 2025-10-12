return {
  name = "file-details",
  cmd = { "FileDetails" },
  config = function(opt)
    require("file-details").setup()
  end,
}
