return {
  "vague-theme/vague.nvim",
  priority = 1000, -- make sure to load this before all the other plugins
  lazy = true,
  -- colorscheme = "vague",
  config = function()
    require("vague").setup({
      -- optional configuration here
    })
    vim.cmd("colorscheme vague")
  end,
}
