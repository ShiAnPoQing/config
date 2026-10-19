--- @class my.env.pro.motion._shared
local M = {}

--- @param start_line integer
local function find_backward_paragraph_end(start_line)
  if start_line == 1 then
    return
  end
  local line = vim.api.nvim_buf_get_lines(0, start_line - 2, start_line - 1, true)[1]
  local lnum = start_line - 1
  if line:match("%S") then
    while true do
      if lnum < 1 then
        lnum = lnum + 1
        break
      end
      if not vim.api.nvim_buf_get_lines(0, lnum - 1, lnum, true)[1]:match("%S") then
        break
      end
      lnum = lnum - 1
    end
  end

  while true do
    if lnum < 1 then
      lnum = lnum + 1
      break
    end
    if vim.api.nvim_buf_get_lines(0, lnum - 1, lnum, true)[1]:match("%S") then
      break
    end
    lnum = lnum - 1
  end
  return lnum
end

--- @param count integer|nil
function M.find_backward_paragraph_end(count, start_line)
  count = count or 1
  start_line = start_line or vim.fn.line(".")
  local _start_line = start_line
  for _ = 1, count do
    local lnum = find_backward_paragraph_end(start_line)
    if not lnum then
      break
    end
    start_line = lnum
  end
  return start_line ~= _start_line and start_line or nil
end

--- @param start_line integer
local function find_forward_paragraph_end(start_line)
  local buf_line_count = vim.api.nvim_buf_line_count(0)
  if start_line == buf_line_count then
    return
  end
  local line = vim.api.nvim_buf_get_lines(0, start_line, start_line + 1, true)[1]
  local lnum = start_line + 1
  if not line:match("%S") then
    while true do
      if lnum > buf_line_count then
        break
      end
      if vim.api.nvim_buf_get_lines(0, lnum - 1, lnum, true)[1]:match("%S") then
        break
      end
      lnum = lnum + 1
    end
  end
  while true do
    if lnum > buf_line_count then
      break
    end
    if not vim.api.nvim_buf_get_lines(0, lnum - 1, lnum, true)[1]:match("%S") then
      break
    end
    lnum = lnum + 1
  end
  return lnum - 1
end

--- @param count integer|nil
function M.find_forward_paragraph_end(count, start_line)
  count = count or 1
  start_line =  start_line or vim.fn.line(".")
  local _start_line = start_line
  for _ = 1, count do
    local lnum = find_forward_paragraph_end(start_line)
    if not lnum then
      break
    end
    start_line = lnum
  end
  return start_line ~= _start_line and start_line or nil
end

--- @param start_line integer
local function find_backward_paragraph_start(start_line)
  if start_line == 1 then
    return
  end
  local line = vim.api.nvim_buf_get_lines(0, start_line - 2, start_line - 1, true)[1]
  local lnum = start_line - 1
  if not line:match("%S") then
    while true do
      if lnum < 1 then
        break
      end
      if vim.api.nvim_buf_get_lines(0, lnum - 1, lnum, true)[1]:match("%S") then
        break
      end
      lnum = lnum - 1
    end
  end
  while true do
    if lnum < 1 then
      break
    end
    if not vim.api.nvim_buf_get_lines(0, lnum - 1, lnum, true)[1]:match("%S") then
      break
    end
    lnum = lnum - 1
  end
  return lnum + 1
end

--- @param count integer|nil
function M.find_backward_paragraph_start(count, start_line)
  count = count or 1
  start_line = start_line or vim.fn.line(".")
  local _start_line = start_line
  for _ = 1, count do
    local lnum = find_backward_paragraph_start(start_line)
    if not lnum then
      break
    end
    start_line = lnum
  end
  return start_line ~= _start_line and start_line or nil
end

--- @param start_line integer
local function find_forward_paragraph_start(start_line)
  local buf_line_count = vim.api.nvim_buf_line_count(0)
  if start_line == buf_line_count then
    return
  end
  local line = vim.api.nvim_buf_get_lines(0, start_line, start_line + 1, true)[1]
  local lnum = start_line + 1
  if line:match("%S") then
    while true do
      if lnum > buf_line_count then
        lnum = lnum - 1
        break
      end
      if not vim.api.nvim_buf_get_lines(0, lnum - 1, lnum, true)[1]:match("%S") then
        break
      end
      lnum = lnum + 1
    end
  end
  while true do
    if lnum > buf_line_count then
      lnum = lnum - 1
      break
    end
    if vim.api.nvim_buf_get_lines(0, lnum - 1, lnum, true)[1]:match("%S") then
      break
    end
    lnum = lnum + 1
  end
  return lnum
end

--- @param count integer|nil
function M.find_forward_paragraph_start(count)
  count = count or 1
  local start_line = vim.fn.line(".")
  local _start_line = start_line
  for _ = 1, count do
    local lnum = find_forward_paragraph_start(start_line)
    if not lnum then
      break
    end
    start_line = lnum
  end
  return start_line ~= _start_line and start_line or nil
end

return M
