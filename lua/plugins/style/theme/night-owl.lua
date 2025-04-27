return {
  "oxfist/night-owl.nvim",
  lazy = false,    -- make sure we load this during startup if it is your main colorscheme
  enabled = true,
  priority = 1000, -- make sure to load this before all the other start plugins
  config = function()
    -- load the colorscheme here
    require("night-owl").setup({
      -- transparent_background = false,
      transparent_background = true,
    })
    vim.cmd.colorscheme("night-owl")
    vim.api.nvim_set_hl(0, "SignColumn", { fg = "white", bg = "NONE" })
    vim.api.nvim_set_hl(0, "FoldColumn", { fg = "#637777", bg = "NONE" })
    vim.api.nvim_set_hl(0, "CursorLine", { bg = "#01121f", fg = "NONE" })
  end,
}
