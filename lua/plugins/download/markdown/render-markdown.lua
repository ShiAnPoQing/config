return {
  "MeanderingProgrammer/render-markdown.nvim",
  depend = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
  -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
  -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
  enabled = false,
  ft = { "markdown" },
  keys = {
    ["<leader>rd"] = {
      "<cmd>RenderMarkdown toggle<cr>",
      "n",
      desc = "Toggle Markdown Render",
    },
  },
  config = function()
    require("render-markdown").setup({
      -- completions = { lsp = { enabled = true } },
      enabled = false,
      ignore = function(a)
        return false
      end,
    })
  end,
}
