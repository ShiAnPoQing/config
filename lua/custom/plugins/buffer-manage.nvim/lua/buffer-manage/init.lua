local M = {}

local Float = require("buffer-manage.float")
local Buffer = require("buffer-manage.buffer")

--- @class BufferManageOptions

--- @param opts? BufferManageOptions
function M.setup(opts) end

function M.buffers()
  local current_buf = vim.api.nvim_get_current_buf()
  local current_win = vim.api.nvim_get_current_win()
  Buffer:create()
  Float:create(Buffer.buf)
  Buffer:update(Float.win, current_buf)

  local BufWinEnter = vim.api.nvim_create_autocmd("BufWinEnter", {
    callback = function(ev)
      if vim.o.filetype == "neo-tree" or vim.o.filetype == "blink-cmp-menu" then
        return
      end
      Buffer:update(Float.win, ev.buf)
    end,
  })

  local WinEnter = vim.api.nvim_create_autocmd("WinEnter", {
    callback = function(ev)
      if vim.o.filetype == "neo-tree" or vim.o.filetype == "blink-cmp-menu" then
        return
      end
      if ev.buf == Buffer.buf then
        return
      end
      Buffer:update(Float.win, ev.buf)
      current_win = vim.api.nvim_get_current_win()
    end,
  })

  vim.api.nvim_create_autocmd("BufHidden", {
    callback = function(ev)
      vim.api.nvim_del_autocmd(BufWinEnter)
      vim.api.nvim_del_autocmd(WinEnter)
      return true
    end,
    buffer = Buffer.buf,
  })

  vim.api.nvim_create_autocmd("BufWriteCmd", {
    callback = function()
      local lines = vim.api.nvim_buf_get_lines(Buffer.buf, 0, -1, false)
      for bufname, bufnr in pairs(Buffer.bufs.map) do
        if not vim.list_contains(lines, bufname) then
          vim.api.nvim_set_option_value("buflisted", false, {
            buf = bufnr,
          })
          vim.api.nvim_buf_delete(bufnr, { unload = true })
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
    vim.api.nvim_buf_clear_namespace(Buffer.buf, Buffer.sign_id, 0, -1)
    vim.api.nvim_buf_set_extmark(Buffer.buf, Buffer.sign_id, cursor[1] - 1, 0, {
      sign_text = "",
      sign_hl_group = "Type",
    })
  end, { buffer = Buffer.buf })

  vim.keymap.set("n", "<C-s>", function() end, { buffer = Buffer.buf })
end

return M
