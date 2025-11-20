return {
  "Iron-E/nvim-highlite",
  lazy = true,
  -- colorscheme = {
  --   "highlite",
  --   "highlite-ayu",
  --   "highlite-everforest",
  --   "highlite-gruvbox",
  --   "highlite-gruvbox-material",
  --   "highlite-iceberg",
  --   "highlite-molokai",
  --   "highlite-papercolor",
  -- },
  config = function()
    require("highlite").setup({ generator = { plugins = { vim = false }, syntax = false } })
  end,
  -- version = "^4.0.0",
}
