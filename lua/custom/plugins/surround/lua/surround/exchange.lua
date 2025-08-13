local Matchs = require("surround.matchs")

local M = {}

local S = {
  line_match_marks = {},
}

local function esc()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, true, true), "nx", false)
end

function S:collect(start_mark, end_mark)
  local function collect(mark, type)
    local row = mark[1]
    local col = mark[2]
    if self.line_match_marks[tostring(row)] ~= nil then
      table.insert(self.line_match_marks[tostring(row)], { type, col })
    else
      self.line_match_marks[tostring(row)] = { { type, col } }
    end
  end

  collect(start_mark, "start")
  collect(end_mark, "end")
end

function S:clean()
  self.line_match_marks = {}
end

function S:exchange(start_match, end_match)
  if start_match == nil then
    S:clean()
    return
  end

  if #start_match > 1 then
    S:line_match_mark_sort()
  end

  for row, line_match_mark in pairs(self.line_match_marks) do
    for _, mark_col_info in ipairs(line_match_mark) do
      local type = mark_col_info[1]
      local col = mark_col_info[2]
      if type == "start" then
        vim.api.nvim_buf_set_text(0, row - 1, col, row - 1, col + 1, { start_match })
      else
        vim.api.nvim_buf_set_text(0, row - 1, col, row - 1, col + 1, { end_match })
      end
    end
  end

  S:clean()
end

function S:line_match_mark_sort()
  for _, line_match_mark in pairs(S.line_match_marks) do
    table.sort(line_match_mark, function(a, b)
      return a[2] > b[2]
    end)
  end
end

function S:get_marks(count, mc, callback)
  local after

  local function get_mark(_count)
    if _count == 0 then
      esc()
      after()
      return
    end
    vim.api.nvim_feedkeys("a" .. mc, "nx", false)
    vim.schedule(function()
      esc()
      callback(vim.api.nvim_buf_get_mark(0, "<"), vim.api.nvim_buf_get_mark(0, ">"))
      vim.api.nvim_feedkeys("gv", "nx", false)
      get_mark(_count - 1)
    end)
  end

  vim.api.nvim_feedkeys("v", "nx", false)
  get_mark(count)

  return {
    after = function(cb)
      after = cb
    end,
  }
end

function M.surround_exchange(mc)
  local pos = vim.api.nvim_win_get_cursor(0)

  S:get_marks(vim.v.count1, mc, function(start_mark, end_mark)
    S:collect(start_mark, end_mark)
  end).after(function()
    local input = vim.fn.input("将匹配的 " .. mc .. " 改成：")
    S:exchange(Matchs.get_match(input))
    vim.api.nvim_win_set_cursor(0, pos)
  end)
end

return M
