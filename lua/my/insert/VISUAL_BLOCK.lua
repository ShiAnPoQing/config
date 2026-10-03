--- @class my.insert.VISUAL_BLOCK
local M = {}
local VISUAL_BLOCK = ""

function M.first()
  local count = vim.v.count1
  local extmarks = my.multicursor.get(0, 0, -1, { limit = 1 })
  if #extmarks == 0 then
    vim.cmd("normal! " .. VISUAL_BLOCK)
    local start_row, start_col = unpack(vim.api.nvim_buf_get_mark(0, "<"))
    local end_row = unpack(vim.api.nvim_buf_get_mark(0, ">"))
    for i = start_row, end_row do
      if i == end_row then
        vim.api.nvim_win_set_cursor(0, { i, start_col })
      else
        vim.api.nvim_buf_set_extmark(0, my.multicursor.ns, i - 1, start_col, {})
      end
    end
  end

  vim.api.nvim_feedkeys(count .. "i", "nt", false)
  vim.api.nvim_create_autocmd("CmdAtom", {
    callback = function(ev)
      if ev.data.type == "insert" then
        my.multicursor.clear(0)
        return true
      end
    end,
  })
end

function M.first_non_blank()
  M.first()
end

function M.last_non_blank()
  M.last()
end

function M.last()
  local count = vim.v.count1
  local extmarks = my.multicursor.get(0, 0, -1, { limit = 1 })
  if #extmarks == 0 then
    vim.cmd("normal! " .. VISUAL_BLOCK)
    local start_row = unpack(vim.api.nvim_buf_get_mark(0, "<"))
    local end_row, end_col = unpack(vim.api.nvim_buf_get_mark(0, ">"))
    for i = start_row, end_row do
      if i == end_row then
        vim.api.nvim_win_set_cursor(0, { i, end_col })
      else
        vim.api.nvim_buf_set_extmark(0, my.multicursor.ns, i - 1, end_col, {})
      end
    end
    vim.api.nvim_feedkeys(count .. "a", "nt", false)
    vim.api.nvim_create_autocmd("CmdAtom", {
      callback = function(ev)
        if ev.data.type == "insert" then
          my.multicursor.clear(0)
          return true
        end
      end,
    })
  end
end

return M
