--- @class my.motion
local M = vim._defer_require("my.motion", {})

--- secondary cursor 应当 apply primary cursor 的 motion，各自评估
--- 即使 primary cursor 没有移动, secondary cursor 也应评估 motion
--- 不能因为 primary cursor 评估后没移动，所以 secondary cursor 都不移动
--- 所以不能使用 motion + cascade 方式实现
--- 只能通过 reset multicursor 实现

--- 尊重 'follow'
function M.line_last_non_blank()
  --- multicursor and follow mode
  if my.multicursor.active() and vim.bo.follow then
    vim.bo.follow = false
    local extmarks = my.multicursor.get(0, 0, -1)
    my.multicursor.clear(0)
    for _, extmark in ipairs(extmarks) do
      local line = vim.api.nvim_buf_get_lines(0, extmark[2], extmark[2] + 1, false)[1]
      local s = line:reverse():find("%S") or 0
      local col = #line - s
      if extmark[3] + 1 == #line:sub(1, col + 1) then
        my.multicursor.set(0, extmark[2], #line)
      else
        my.multicursor.set(0, extmark[2], col)
      end
    end
    local line = vim.api.nvim_get_current_line()
    local s = line:reverse():find("%S") or 0
    local col = #line - s
    vim.api.nvim_win_set_cursor(0, { vim.fn.line("."), col })
    vim.bo.follow = true
  else
    local line = vim.api.nvim_get_current_line()
    local s = line:reverse():find("%S") or 0
    local col = #line - s
    vim.api.nvim_win_set_cursor(0, { vim.fn.line("."), col })
  end
end

function M.line_first_non_blank() end

--- <End> 测试可行，这是后备方案
function M.line_last()
  --- multicursor and follow mode
  if my.multicursor.active() and vim.bo.follow then
    vim.bo.follow = false
    local extmarks = my.multicursor.get(0, 0, -1)
    my.multicursor.clear(0)
    for _, extmark in ipairs(extmarks) do
      local line = vim.api.nvim_buf_get_lines(0, extmark[2], extmark[2] + 1, false)[1]
      my.multicursor.set(0, extmark[2], #line)
    end
    local line = vim.api.nvim_get_current_line()
    vim.api.nvim_win_set_cursor(0, { vim.fn.line("."), #line })
    vim.bo.follow = true
  else
    local line = vim.api.nvim_get_current_line()
    vim.api.nvim_win_set_cursor(0, { vim.fn.line("."), #line })
  end
end

function M.line_first() end

local function backward_word_start(key)
  local mode = vim.api.nvim_get_mode().mode
  if vim.list_contains({ "n", "v", "V", "" }, mode) then
    vim.cmd("normal! " .. key)
    return
  end

  if mode == "no" then
    if my.cursor.is_word_start() then
      vim.cmd("normal! " .. key)
      return
    end
    vim.cmd("normal! v" .. key)
    return
  end
end

local function backward_word_end(key)
  local mode = vim.api.nvim_get_mode().mode
  if mode == "n" then
    vim.cmd("normal! " .. key)
    return
  end

  if vim.list_contains({ "v", "V", "" }, mode) then
    if vim.fn.col(".") == 1 then
      vim.cmd("normal! " .. key .. "l")
    else
      vim.cmd("normal! " .. "h" .. key .. "l")
    end
    return
  end

  if mode == "no" then
    --- If cursor is at the start of the word,
    --- Do not include the cursor
    if my.cursor.is_word_start() then
      local col1 = vim.fn.col(".")
      --- The motion must be triggered at the cursor position.
      vim.cmd("normal! v" .. key)
      local col2 = vim.fn.col(".")
      --- Exclude the endpoints:
      --- If cursor just move left one character, Do not include the cursor
      if col2 == col1 - 1 then
        vim.cmd("normal! v")
      else
        vim.cmd("normal! loh")
      end
      return
    end
    vim.cmd("normal! v" .. key .. "l")
    return
  end
end

local function forward_word_end(key)
  local mode = vim.api.nvim_get_mode().mode
  if vim.list_contains({ "n", "v", "V", "" }, mode) then
    vim.cmd("normal! " .. key)
    return
  end

  if mode == "no" then
    if my.cursor.is_word_end() then
      vim.cmd("normal! v" .. key .. "ol")
      return
    end
    vim.cmd("normal! v" .. key)
    return
  end
end

local function forward_word_start(key)
  local mode = vim.api.nvim_get_mode().mode

  if mode == "n" then
    vim.cmd("normal! " .. key)
    return
  end

  if vim.list_contains({ "v", "V", "" }, mode) then
    if vim.fn.col(".") == 1 then
      vim.cmd("normal! " .. key .. "h")
    else
      vim.cmd("normal! " .. "l" .. key .. "h")
    end
    return
  end

  if mode == "no" then
    if my.cursor.is_word_end() then
      local col1 = vim.fn.col(".")
      vim.cmd("normal! vw")
      local col2 = vim.fn.col(".")
      if col2 == col1 + 1 then
        vim.cmd("normal! v")
      else
        vim.cmd("normal! hol")
      end
      return
    end
    vim.cmd("normal! w")
    return
  end
end

function M.backward_word_start()
  backward_word_start("b")
end

function M.backward_WORD_start()
  backward_word_start("B")
end

function M.backward_word_end()
  backward_word_end("ge")
end

function M.backward_WORD_end()
  backward_word_end("gE")
end

function M.forward_word_start()
  forward_word_start("w")
end

function M.forward_WORD_start()
  forward_word_start("W")
end

function M.forward_word_end()
  forward_word_end("e")
end

function M.forward_WORD_end()
  forward_word_end("E")
end

return M
