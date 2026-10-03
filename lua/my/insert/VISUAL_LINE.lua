--- @class my.insert.VISUAL_LINE
local M = {}

local VISUAL_LINE = "V"

function M.first()
  local count = vim.v.count1
  local extmarks = my.multicursor.get(0, 0, -1, { limit = 1 })
  if #extmarks == 0 then
    vim.cmd("normal! " .. VISUAL_LINE)
    local start_row = vim.api.nvim_buf_get_mark(0, "<")[1]
    local end_row = vim.api.nvim_buf_get_mark(0, ">")[1]
    for i = start_row, end_row do
      if i == end_row then
        vim.api.nvim_win_set_cursor(0, { i, 0 })
      else
        vim.api.nvim_buf_set_extmark(0, my.multicursor.ns, i - 1, 0, {})
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

function M.last()
  local count = vim.v.count1
  local extmarks = my.multicursor.get(0, 0, -1, { limit = 1 })
  if #extmarks == 0 then
    vim.cmd("normal! " .. VISUAL_LINE)
    local start_row = vim.api.nvim_buf_get_mark(0, "<")[1]
    local end_row = vim.api.nvim_buf_get_mark(0, ">")[1]
    for i = start_row, end_row do
      local line = vim.api.nvim_buf_get_lines(0, i - 1, i, true)[1]
      if i == end_row then
        vim.api.nvim_win_set_cursor(0, { i, #line })
      else
        vim.api.nvim_buf_set_extmark(0, my.multicursor.ns, i - 1, #line, {})
      end
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

function M.last_non_blank()
  local count = vim.v.count1
  local extmarks = my.multicursor.get(0, 0, -1, { limit = 1 })
  if #extmarks == 0 then
    vim.cmd("normal! " .. VISUAL_LINE)
    local start_row = vim.api.nvim_buf_get_mark(0, "<")[1]
    local end_row = vim.api.nvim_buf_get_mark(0, ">")[1]
    for i = start_row, end_row do
      local line = vim.api.nvim_buf_get_lines(0, i - 1, i, true)[1]
      local col = line:reverse():find("%S") or 0
      col = #line - col + 1
      if i == end_row then
        vim.api.nvim_win_set_cursor(0, { i, col - 1 })
      else
        vim.api.nvim_buf_set_extmark(0, my.multicursor.ns, i - 1, col - 1, {})
      end
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

function M.first_non_blank()
  local count = vim.v.count1
  local extmarks = my.multicursor.get(0, 0, -1, { limit = 1 })
  if #extmarks == 0 then
    vim.cmd("normal! " .. VISUAL_LINE)
    local start_row = vim.api.nvim_buf_get_mark(0, "<")[1]
    local end_row = vim.api.nvim_buf_get_mark(0, ">")[1]
    for i = start_row, end_row do
      local line = vim.api.nvim_buf_get_lines(0, i - 1, i, true)[1]
      local col = line:find("%S") or 1
      col = col - 1
      if i == end_row then
        vim.api.nvim_win_set_cursor(0, { i, col })
      else
        vim.api.nvim_buf_set_extmark(0, my.multicursor.ns, i - 1, col, {})
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

return M
