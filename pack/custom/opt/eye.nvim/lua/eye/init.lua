local M = {}

function M.setup()
  vim.api.nvim_set_hl(0, "EyeLabel", {
    fg = "#ff007c",
    bold = true,
  })
  vim.api.nvim_set_hl(0, "EyeNextLabel", {
    fg = "#00dfff",
    bold = true,
  })
  vim.api.nvim_set_hl(0, "EyeSearchIcon", {
    fg = "#ff007c",
    bold = true,
  })
end

return M
