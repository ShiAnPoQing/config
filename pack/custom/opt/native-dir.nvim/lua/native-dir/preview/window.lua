--- @class NativeDir.Preview.Window:NativeDir.Preview
local M = {}

--- @class NativeDir.Preview.Window.WinOpts
--- @field title? string
--- @field title_pos? string
--- @field border? any[]|"none"|"single"|"double"|"rounded"|"solid"|"shadow"

--- @class NativeDir.Preview.Window.Opts
--- @field win? NativeDir.Preview.Window.WinOpts

--- @param file string
--- @param opts NativeDir.Preview.Window.Opts
function M.open(file, opts)
  opts = opts or {}
  if not opts.win then
    opts.win = {}
  end
  if not file then
    return
  end
  local buf = vim.uri_to_bufnr(vim.uri_from_fname(file))
  local width = math.floor(0.5 * vim.o.columns)
  local height = math.floor(0.5 * vim.o.lines)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)
  M.win = vim.api.nvim_open_win(buf, false, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "single",
    title = opts.win.title,
    title_pos = opts.win.title_pos or "center",
  })
end

function M.close()
  if M.win and vim.api.nvim_win_is_valid(M.win) then
    vim.api.nvim_win_close(M.win, true)
    M.win = nil
  end
end

function M.is_open()
  return M.win and vim.api.nvim_win_is_valid(M.win)
end

return M
