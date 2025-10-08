local M = {}

--- @class TagPeekPreviewOptions
--- @field path string
--- @field line number

local filetypeMap = {
  ["lua"] = "lua",
  ["ts"] = "typescript",
  ["tsx"] = "typescriptreact",
}
--- @param opts TagPeekPreviewOptions
function M.preview(opts)
  if M.win and vim.api.nvim_win_is_valid(M.win) then
    vim.api.nvim_win_close(M.win, true)
  end
  local width = vim.o.columns
  local height = vim.o.lines

  local title = vim.fs.basename(opts.path)
  local ext = vim.fn.fnamemodify(title, ":e")
  --- @type vim.api.keyset.win_config
  local default_config = {
    relative = "editor",
    style = "minimal",
    width = 80,
    height = 10,
    row = 15,
    col = math.floor((width - 80) / 2),
    border = "single",
    title = title,
    title_pos = "center",
    focusable = false,
  }
  M.buf = vim.api.nvim_create_buf(false, true)
  M.win = vim.api.nvim_open_win(M.buf, true, default_config)
  local lines = vim.fn.readfile(opts.path)
  vim.api.nvim_buf_set_lines(M.buf, 0, -1, false, lines)
  vim.api.nvim_set_option_value("filetype", filetypeMap[ext] or "markdown", {
    buf = M.buf,
  })
  vim.api.nvim_set_option_value("number", true, {
    win = M.win,
  })
  vim.api.nvim_set_option_value("cursorline", true, {
    win = M.win,
  })
  vim.api.nvim_win_set_cursor(M.win, { opts.line, 0 })
  -- vim.api.nvim_buf_set_extmark(M.buf, vim.api.nvim_create_namespace("tag-peek-preview"), opts.line - 1, 0, {
  --   end_line = opts.line,
  --   hl_group = "Cursorline",
  -- })
end

return M
