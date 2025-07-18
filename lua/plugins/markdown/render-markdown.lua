return {
  'MeanderingProgrammer/render-markdown.nvim',
  -- lazy = true,
  dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
  -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
  -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
  ---@module 'render-markdown'
  ---@type render.md.UserConfig
  opts = {},
  ft = { "markdown" },
  keys = {
    { ";md", "<cmd>RenderMarkdown toggle<cr>", desc = "Toggle Markdown Render" }
  },
  config = function()
    require('render-markdown').setup({
      completions = { blink = { enabled = true } },
      enabled = false
    })
  end
}
