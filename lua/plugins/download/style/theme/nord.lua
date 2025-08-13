return {
  "shaunsingh/nord.nvim",
  lazy = false,
  enabled = true,
  config = function()
    vim.cmd([[colorscheme nord]])
    -- vim.g.nord_disable_background = true
    -- Load the colorscheme
    -- require('nord').set()
  end,
}
