local M = {
  highlights = {
    EyeLabel = "EyeLabel",
    EyeNextLabel = "EyeNextLabel",
    EyeLayer = "EyeLayer",
  },
}

function M.setup()
  local highlights = M.highlights
  vim.api.nvim_set_hl(0, highlights.EyeLabel, {
    fg = "#ff007c",
    bold = true,
  })
  vim.api.nvim_set_hl(0, highlights.EyeNextLabel, {
    fg = "#00dfff",
    bold = true,
  })
  local Comment = vim.api.nvim_get_hl(0, { name = "Comment" })
  vim.api.nvim_set_hl(0, highlights.EyeLayer, { fg = Comment.fg })
end

function M.get_highlights()
  return vim.tbl_extend("force", {}, M.highlights)
end

--- @class Eye.highlight.RegisterSpec
--- @field name string
--- @field value vim.api.keyset.highlight

--- @param source Eye.highlight.RegisterSpec[]
function M.register_highlights(source)
  for _, spec in ipairs(source) do
    vim.api.nvim_set_hl(0, spec.name, spec.value)
  end
end

return M
