return {
  name = "file-details",
  cmd = { "FileDetails" },
  config = function()
    require("file-details").setup()
  end,
}
