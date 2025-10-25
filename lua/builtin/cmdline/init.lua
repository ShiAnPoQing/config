local M = {}

local function get_cmd_line_and_pos()
  local cmd = vim.fn.getcmdline()
  local pos = vim.fn.getcmdpos()
  return cmd, pos
end

local function get_prev_word_start(callback)
  local cmd, pos = get_cmd_line_and_pos()
  local base = cmd:find("%w")

  if not base then
    return
  end

  base = base - 1
  local new_pos = pos

  for value in cmd:gmatch("%w+%s*") do
    base = base + #value

    if base >= pos - 1 then
      new_pos = base - #value + 1
      break
    end
  end

  if not new_pos then
    return
  end

  callback({
    cmd = cmd,
    pos = pos,
    new_pos = new_pos,
  })
end

local function get_next_word_end(callback)
  local cmd, pos = get_cmd_line_and_pos()
  local base = 0
  local new_pos = pos
  for value in cmd:gmatch("%s*%w+") do
    base = base + #value

    if base >= pos then
      new_pos = base + 1
      break
    end
  end

  if not new_pos then
    return
  end

  callback({
    cmd = cmd,
    pos = pos,
    new_pos = new_pos,
  })
end

local function get_next_word_start(callback)
  local cmd, pos = get_cmd_line_and_pos()
  local base = cmd:find("%w")

  if not base then
    return
  end

  base = base - 1

  local new_pos = pos
  for value in cmd:gmatch("%w+%s*") do
    base = base + #value

    if base >= pos then
      new_pos = base + 1
      break
    end
  end

  if not new_pos then
    return
  end

  callback({
    cmd = cmd,
    pos = pos,
    new_pos = new_pos,
  })
end

local function get_prev_word_end(callback)
  local cmd, pos = get_cmd_line_and_pos()
  local base = 0
  local new_pos = pos
  for value in cmd:gmatch("%s*%w+") do
    base = base + #value

    if base >= pos - 1 then
      new_pos = base - #value + 1
      break
    end
  end

  if not new_pos then
    return
  end

  callback({
    cmd = cmd,
    pos = pos,
    new_pos = new_pos,
  })
end

function M.word_start_forward()
  get_next_word_start(function(data)
    vim.fn.setcmdline(data.cmd, data.new_pos)
  end)
end

function M.word_end_forward()
  get_next_word_end(function(data)
    vim.fn.setcmdline(data.cmd, data.new_pos)
  end)
end

function M.word_start_backward()
  get_prev_word_start(function(data)
    vim.fn.setcmdline(data.cmd, data.new_pos)
  end)
end

function M.word_end_backward()
  get_prev_word_end(function(data)
    vim.fn.setcmdline(data.cmd, data.new_pos)
  end)
end

function M.delete_to_word_start_forward()
  get_next_word_start(function(data)
    vim.fn.setcmdline(data.cmd:sub(0, data.pos - 1) .. data.cmd:sub(data.new_pos), data.pos)
  end)
end

function M.delete_to_word_end_forward()
  get_next_word_end(function(data)
    vim.fn.setcmdline(data.cmd:sub(1, data.pos - 1) .. data.cmd:sub(data.new_pos), data.pos)
  end)
end

function M.delete_to_word_end_backward()
  get_prev_word_end(function(data)
    vim.fn.setcmdline(data.cmd:sub(0, data.new_pos - 1) .. data.cmd:sub(data.pos), data.new_pos)
  end)
end

function M.delete_current_word_before()
  local cmd = vim.fn.getcmdline()
  local pos = vim.fn.getcmdpos()

  local base = 0
  local del_start
  local del_end

  for value1, value2 in cmd:gmatch("(%s*)(%w*)") do
    base = base + #value1

    if base >= pos - 1 then
      del_start = base - #value1
      del_end = base
      break
    end

    base = base + #value2

    if base >= pos - 1 then
      del_start = base - #value2
      del_end = base
      break
    end
  end

  if not del_start then
    return
  end

  local new_cmd = cmd:sub(1, del_start) .. cmd:sub(del_end + 1)
  vim.fn.setcmdline(new_cmd, del_start + 1)
end

function M.delete_current_word_after()
  local cmd = vim.fn.getcmdline()
  local pos = vim.fn.getcmdpos()

  local base = 0
  local del_start
  local del_end

  for value1, value2 in cmd:gmatch("(%s*)(%w*)") do
    base = base + #value1

    if base >= pos then
      del_start = base - #value1
      del_end = base
      break
    end

    base = base + #value2

    if base >= pos then
      del_start = base - #value2
      del_end = base
      break
    end
  end

  if not del_start then
    return
  end

  local new_cmd = cmd:sub(1, del_start) .. cmd:sub(del_end + 1)
  vim.fn.setcmdline(new_cmd, del_start + 1)
end

function M.first_non_blank_character()
  local cmd = vim.fn.getcmdline()
  local _, new_pos = cmd:find("^%s*[^%s]")

  if not new_pos then
    return
  end

  local pos = vim.fn.getcmdpos()
  vim.fn.setcmdline(cmd, new_pos == pos and 1 or new_pos)
end

function M.last_non_blank_character()
  local cmd = vim.fn.getcmdline()
  local new_pos = cmd:find("[^%s]%s*$")

  if not new_pos then
    return
  end

  local pos = vim.fn.getcmdpos()

  if new_pos + 1 == pos then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<End>", true, false, true), "n", true)
  else
    vim.fn.setcmdline(cmd, new_pos + 1)
  end
end

return M
