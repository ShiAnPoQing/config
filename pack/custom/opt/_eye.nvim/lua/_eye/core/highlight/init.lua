local Cfg = require("_eye.core.highlight.config")

local M = {
  EyeLabel = "_EyeLabel",
  EyeNextLabel = "_EyeNextLabel",
}

vim.api.nvim_set_hl(0, "_EyeLabel", { fg = "#ff007c", bold = true })
vim.api.nvim_set_hl(0, "_EyeNextLabel", { fg = "#00dfff", bold = true })

--- @class _Eye.Highlight.Spec: vim.api.keyset.set_extmark
--- @field buf integer
--- @field row integer
--- @field col integer

--- @param specs _Eye.Highlight.Spec[]
--- @param config? _Eye.Highlight.Config
function M.highlight(specs, config)
  config = Cfg.merge(config)
  local ns_id = vim.api.nvim_create_namespace("eye-highlight")
  local bufs = {}
  for _, spec in ipairs(specs) do
    local buf = spec.buf
    if not bufs[tostring(buf)] then
      bufs[tostring(buf)] = true
    end

    --- @type vim.api.keyset.set_extmark
    vim.api.nvim_buf_set_extmark(buf, ns_id, spec.row, spec.col, {
      virt_text_pos = spec.virt_text_pos or "overlay",
      sign_text = spec.sign_text or nil,
      sign_hl_group = spec.sign_hl_group or nil,
      virt_text = spec.virt_text,
      hl_mode = spec.hl_mode or "combine",
      virt_text_win_col = spec.virt_text_win_col or nil,
    })
  end
  vim.cmd.redraw()
  return function()
    for key, _ in pairs(bufs) do
      local buf = tonumber(key) --[[@as integer]]
      vim.api.nvim_buf_clear_namespace(buf, ns_id, 0, -1)
    end
  end
end

return M
