local M = {}

local default_config = {
  position = "float",
}

local Float = require("buffer-manage.float")
local Buffer = require("buffer-manage.buffer")
local Mark = require("buffer-manage.mark")

--- @param cmds integer[]
local function del_autocmd(cmds)
  for _, value in ipairs(cmds) do
    vim.api.nvim_del_autocmd(value)
  end
end

--- @class BufferManageOptions
--- @field position "left"|"right"|"top"|"bottom"|"float"

--- @param opts? BufferManageOptions
function M.setup(opts) end

function M.buffer_manage()
  if Float.win and vim.api.nvim_win_is_valid(Float.win) then
    vim.api.nvim_win_close(Float.win, true)
    return
  end

  local current_buf = vim.api.nvim_get_current_buf()
  local current_win = vim.api.nvim_get_current_win()

  Buffer:create()
  Float:create(Buffer.buf)
  Buffer:update(Float.win, current_buf)

  local VimResized = vim.api.nvim_create_autocmd("VimResized", {
    callback = function()
      Float:update()
    end,
  })
  local BufWinEnter = vim.api.nvim_create_autocmd("BufWinEnter", {
    callback = function(ev)
      Buffer:update(Float.win, ev.buf)
    end,
  })
  local WinEnter = vim.api.nvim_create_autocmd("WinEnter", {
    callback = function(ev)
      if ev.buf == Buffer.buf then
        return
      end
      Buffer:update(Float.win, ev.buf)
      current_win = vim.api.nvim_get_current_win()
    end,
  })

  vim.api.nvim_create_autocmd("BufHidden", {
    callback = function(ev)
      del_autocmd({ BufWinEnter, WinEnter, VimResized })
      return true
    end,
    buffer = Buffer.buf,
  })

  vim.api.nvim_create_autocmd("BufWriteCmd", {
    callback = function()
      local lines = vim.api.nvim_buf_get_lines(Buffer.buf, 0, -1, false)
      for bufname, bufnr in pairs(Buffer.bufs.map) do
        if not vim.list_contains(lines, bufname) then
          if bufnr == vim.api.nvim_win_get_buf(current_win) then
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
      Buffer:update(Float.win, vim.api.nvim_win_get_buf(current_win))
    end,
    buffer = Buffer.buf,
  })

  vim.keymap.set("n", "<cr>", function()
    local current_line = vim.api.nvim_get_current_line()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local bufnr = Buffer.bufs.map[current_line]
    if not bufnr then
      return
    end
    vim.api.nvim_win_set_buf(current_win, bufnr)
    Mark:set_mark(Buffer.buf, cursor[1] - 1)
  end, { buffer = Buffer.buf })

  vim.keymap.set("n", "<C-s>", function() end, { buffer = Buffer.buf })
end

return M
