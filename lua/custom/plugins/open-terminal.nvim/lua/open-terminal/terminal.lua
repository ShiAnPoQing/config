local M = {}

local function is_buf_valid()
  return M.buf and vim.api.nvim_buf_is_valid(M.buf)
end

--- @class OpenTerminal.Create
--- @field direction OpenTerminalDirection
--- @field buf_options? vim.api.keyset.option
--- @field win_options? vim.api.keyset.option

--- @param options OpenTerminal.Create
function M.create(options)
  options = options or {}
  local is_valid = is_buf_valid()

  if not is_valid then
    M.buf = vim.api.nvim_create_buf(false, true)
  end

  local config = {}
  if options.direction == "float" then
    local width = math.floor(vim.o.columns * 0.8)
    local height = math.floor(vim.o.lines * 0.8)
    config = {
      relative = "editor",
      style = "minimal",
      border = "rounded",
      width = width,
      height = height,
      row = math.floor((vim.o.lines - height) / 2),
      col = math.floor((vim.o.columns - width) / 2),
    }
    vim.api.nvim_create_autocmd("VimResized", {
      callback = function()
        local w = math.floor(vim.o.columns * 0.8)
        local h = math.floor(vim.o.lines * 0.8)
        config.width = w
        config.height = h
        config.row = math.floor((vim.o.lines - h) / 2)
        config.col = math.floor((vim.o.columns - w) / 2)
        vim.api.nvim_win_set_config(M.win, config)
      end,
    })
  end

  if
    options.direction == "above"
    or options.direction == "below"
    or options.direction == "left"
    or options.direction == "right"
  then
    config = {
      width = math.floor(vim.o.columns * 0.3),
      split = options.direction,
      win = vim.api.nvim_get_current_win(),
    }
  end

  M.win = vim.api.nvim_open_win(M.buf, true, config)

  if not is_valid then
    vim.cmd.terminal()
    vim.cmd("normal! i")
  end
end

return M
