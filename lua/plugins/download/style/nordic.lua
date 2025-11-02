return {
  "AlexvZyl/nordic.nvim",
  priority = 1000,
  colorscheme = "nordic",
  config = function()
    ---@diagnostic disable-next-line: missing-parameter
    require("nordic").load()
  end,
}
