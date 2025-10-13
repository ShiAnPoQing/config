local M = {}
local Buffer = require("neo-buffer.buffer")
local Window = require("neo-buffer.window")
local Current = {}

local function del_autocmd(cmds)
  for _, value in ipairs(cmds) do
    vim.api.nvim_del_autocmd(value)
  end
end

local function create_events()
  local VimResized = vim.api.nvim_create_autocmd("VimResized", {
    callback = function()
      Window:update()
    end,
  })
  local BufWinEnter = vim.api.nvim_create_autocmd("BufWinEnter", {
    callback = function(ev)
      local buflisted = vim.api.nvim_get_option_value("buflisted", {
        buf = ev.buf,
      })
      if buflisted then
        Buffer:update(Window.win, ev.buf)
      end
    end,
  })
  local WinEnter = vim.api.nvim_create_autocmd("WinEnter", {
    callback = function(ev)
      if ev.buf == Buffer.buf or not vim.api.nvim_get_option_value("buflisted", {
        buf = ev.buf,
      }) then
        return
      end
      Current.win = vim.api.nvim_get_current_win()
      Buffer:update(Window.win, ev.buf)
    end,
  })
  vim.api.nvim_create_autocmd("BufHidden", {
    callback = function(ev)
      vim.schedule(function()
        vim.api.nvim_buf_delete(Buffer.buf, { force = true })
      end)
      del_autocmd({ WinEnter, BufWinEnter, VimResized })
      return true
    end,
    buffer = Buffer.buf,
  })
  vim.api.nvim_create_autocmd("BufWriteCmd", {
    callback = function()
      local lines = vim.api.nvim_buf_get_lines(Buffer.buf, 0, -1, false)
      for bufname, bufnr in pairs(Buffer.buffer_map) do
        if not vim.list_contains(lines, bufname) then
          if bufnr == vim.api.nvim_win_get_buf(Current.win) then
            vim.api.nvim_buf_call(bufnr, function()
              vim.cmd("bd")
            end)
          else
            vim.api.nvim_set_option_value("buflisted", false, {
              buf = bufnr,
            })
            vim.api.nvim_buf_delete(bufnr, { force = true })
          end
        end
      end
      Buffer:update(Window.win, vim.api.nvim_win_get_buf(Current.win))
    end,
    buffer = Buffer.buf,
  })
end

function M.buffers(position)
  if Window.win and vim.api.nvim_win_is_valid(Window.win) then
    vim.api.nvim_win_close(Window.win, true)
    return
  end

  Current.buf = vim.api.nvim_get_current_buf()
  Current.win = vim.api.nvim_get_current_win()

  Buffer:create()
  Window:create(Buffer.buf, position)
  Buffer:update(Window.win, Current.buf)
  create_events()

  vim.keymap.set("n", "<cr>", function()
    local current_line = vim.api.nvim_get_current_line()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local bufnr = Buffer.buffer_map[current_line]
    if not bufnr then
      return
    end
    vim.api.nvim_win_set_buf(Current.win, bufnr)
    Buffer:set_mark(cursor[1])
  end, { buffer = Buffer.buf })
end

return M
