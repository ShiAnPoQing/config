local M = {}
--- @class Eye.Extmark.Opt
--- @field buf integer
--- @field ns_id integer
--- @field line integer
--- @field col integer
--- @field text string
--- @field hl_group string
--- @field virt? boolean
--- @field virt_text_pos? "eol" | "eol_right_align" | "overlay" | "right_align" | "inline"
--- @field right_gravity? boolean

--- @param opt Eye.Extmark.Opt
function M.set(opt)
  local line = opt.line
  local col = opt.col
  local ns_id = opt.ns_id
  local extmark_opts = {
    virt_text = { { opt.text, opt.hl_group } },
    hl_mode = "combine",
  }
  if opt.right_gravity ~= nil then
    extmark_opts.right_gravity = opt.right_gravity
  end
  if opt.virt_text_pos ~= nil then
    extmark_opts.virt_text_pos = opt.virt_text_pos
  end
  if opt.virt then
    extmark_opts.virt_text_win_col = col
    pcall(vim.api.nvim_buf_set_extmark, opt.buf, ns_id, line, 0, extmark_opts)
  else
    pcall(vim.api.nvim_buf_set_extmark, opt.buf, ns_id, line, col, extmark_opts)
  end
end

return M
