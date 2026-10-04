--- @class my.motion
--- @field INSERT my.motion.INSERT
--- @field COMMAND my.motion.COMMAND
--- @field NORMAL my.motion.NORMAL
--- @field OPERATOR_PENDING my.motion.OPERATOR_PENDING
--- @field ['i'] my.motion.INSERT
--- @field ['c'] my.motion.COMMAND
--- @field ['n'] my.motion.NORMAL
local M = my.util.defer_require("my.motion", {
  INSERT = true,
  COMMAND = true,
  NORMAL = true,
  OPERATOR_PENDING = true,
  ["c"] = "COMMAND",
  ["n"] = "NORMAL",
  ["i"] = "INSERT",
  ["no"] = "OPERATOR_PENDING",
  -- VISUAL = true,
  -- VISUAL_LINE = true,
  -- VISUAL_BLOCK = true,
  -- NORMAL = true,
  -- ["v"] = "VISUAL",
  -- ["V"] = "VISUAL_LINE",
  -- [""] = "VISUAL_BLOCK",
})

--- secondary cursor 应当 apply primary cursor 的 motion，各自评估
--- 即使 primary cursor 没有移动, secondary cursor 也应评估 motion
--- 不能因为 primary cursor 评估后没移动，所以 secondary cursor 都不移动
--- 所以不能使用 motion + cascade 方式实现
--- 只能通过 reset multicursor 实现

-- {motion}:
--    1. move to the last non blank character the line
--    2. fallback to the last character of the line
-- support:
--    1. mode: n, no, v, V, , i
--    2. multicursor
--    3. CmdAtom LHS repeat
function M.last_non_blank()
  local mode = vim.api.nvim_get_mode().mode
  if mode == "no" then
    M[mode].last_non_blank()
  elseif vim.list_contains({ "v", "V", "" }, mode) then
    vim.cmd("normal! g_")
  else
    if mode == "nt" then
      mode = "n"
    end
    if mode == "n" then
      vim.api.nvim_feedkeys(vim.keycode("<cmd>lua my.motion.NORMAL.last_non_blank()<cr>"), "n", true)
      return
    end
    M[mode].last_non_blank()
  end
end

-- {motion}:
--    1. move to the first non blank character the line
--    2. fallback to the first character of the line
-- support:
--    1. mode: n, no, v, V, , i
--    2. multicursor
--    3. CmdAtom LHS repeat
function M.first_non_blank()
  local mode = vim.api.nvim_get_mode().mode
  if mode == "no" then
    M[mode].first_non_blank()
  elseif vim.list_contains({ "v", "V", "" }, mode) then
    vim.cmd("normal! ^")
  else
    if mode == "nt" then
      mode = "n"
    end
    if mode == "n" then
      --- REAL ATOM
      vim.api.nvim_feedkeys(vim.keycode("<cmd>lua my.motion.NORMAL.first_non_blank()<cr>"), "n", true)
      return
    end
    M[mode].first_non_blank()
  end
end

--- <End> 测试可行，这是后备方案
function M.last()
  -- --- multicursor and follow mode
  -- if my.multicursor.active() and vim.bo.follow then
  --   vim.bo.follow = false
  --   local extmarks = my.multicursor.get(0, 0, -1)
  --   my.multicursor.clear(0)
  --   for _, extmark in ipairs(extmarks) do
  --     local line = vim.api.nvim_buf_get_lines(0, extmark[2], extmark[2] + 1, false)[1]
  --     my.multicursor.set(0, extmark[2], #line)
  --   end
  --   local line = vim.api.nvim_get_current_line()
  --   vim.api.nvim_win_set_cursor(0, { vim.fn.line("."), #line })
  --   vim.bo.follow = true
  -- else
  --   local line = vim.api.nvim_get_current_line()
  --   vim.api.nvim_win_set_cursor(0, { vim.fn.line("."), #line })
  -- end
  local mode = vim.api.nvim_get_mode().mode
  if mode == "n" then
    vim.cmd("normal! $")
  elseif mode == "nt" then
    vim.cmd("normal! $")
  elseif vim.list_contains({ "v", "V", "" }, mode) then
    --- :h $
    --- native: In Visual mode the cursor goes to just after the last character in the line
    --- I don't wana this
    vim.cmd("normal! $h")
  elseif mode == "no" then
    M[mode].last()
  end
end

function M.first()
  local mode = vim.api.nvim_get_mode().mode
  if mode == "n" then
    vim.cmd("normal! 0")
  elseif mode == "nt" then
    vim.cmd("normal! 0")
  elseif vim.list_contains({ "v", "V", "" }, mode) then
    vim.cmd("normal! 0")
  elseif mode == "no" then
    M[mode].first()
  end
end

local word_map = {
  ["b"] = "backward_word_start",
  ["B"] = "backward_WORD_start",
  ["e"] = "forward_word_end",
  ["E"] = "forward_WORD_end",
  ["w"] = "forward_word_start",
  ["W"] = "forward_WORD_start",
  ["ge"] = "backward_word_end",
  ["gE"] = "backward_WORD_end",
}

local function backward_word_start(key)
  local mode = vim.api.nvim_get_mode().mode
  if vim.list_contains({ "n", "v", "V", "" }, mode) then
    vim.cmd("normal! " .. vim.v.count1 .. key)
    return
  end

  if mode == "no" then
    M[mode][word_map[key]]()
    return
  end
end

local function backward_word_end(key)
  local mode = vim.api.nvim_get_mode().mode
  if mode == "n" then
    vim.cmd("normal! " .. vim.v.count1 .. key)
    return
  end

  if vim.list_contains({ "v", "V", "" }, mode) then
    if vim.fn.col(".") == 1 then
      vim.cmd("normal! " .. vim.v.count1 .. key .. "l")
    else
      vim.cmd("normal! " .. "h" .. vim.v.count1 .. key .. "l")
    end
    return
  end

  if mode == "no" then
    M[mode][word_map[key]]()
    return
  end
end

local function forward_word_end(key)
  local mode = vim.api.nvim_get_mode().mode
  if vim.list_contains({ "n", "v", "V", "" }, mode) then
    vim.cmd("normal! " .. vim.v.count1 .. key)
    return
  end

  if mode == "no" then
    M[mode][word_map[key]]()
    return
  end
end

local function forward_word_start(key)
  local mode = vim.api.nvim_get_mode().mode

  if mode == "n" then
    vim.cmd("normal! " .. vim.v.count1 .. key)
    return
  end

  if vim.list_contains({ "v", "V", "" }, mode) then
    if vim.fn.col(".") == 1 then
      vim.cmd("normal! " .. vim.v.count1 .. key .. "h")
    else
      vim.cmd("normal! " .. "l" .. vim.v.count1 .. key .. "h")
    end
    return
  end

  if mode == "no" then
    M[mode][word_map[key]]()
  end
end

--- COMPLETE ATOM: you must map `<Cmd>lua my.motion.backward_word_start()<CR>`!!
function M.backward_word_start()
  backward_word_start("b")
end

--- COMPLETE ATOM: you must map `<Cmd>lua my.motion.backward_WORD_start()<CR>`!!
function M.backward_WORD_start()
  backward_word_start("B")
end

--- COMPLETE ATOM: you must map `<Cmd>lua my.motion.backward_word_end()<CR>`!!
function M.backward_word_end()
  backward_word_end("ge")
end

--- COMPLETE ATOM: you must map `<Cmd>lua my.motion.backward_WORD_end()<CR>`!!
function M.backward_WORD_end()
  backward_word_end("gE")
end

--- COMPLETE ATOM: you must map `<Cmd>lua my.motion.forward_word_start()<CR>`!!
function M.forward_word_start()
  forward_word_start("w")
end

--- COMPLETE ATOM: you must map `<Cmd>lua my.motion.forward_WORD_start()<CR>`!!
function M.forward_WORD_start()
  forward_word_start("W")
end

--- COMPLETE ATOM: you must map `<Cmd>lua my.motion.forward_word_end()<CR>`!!
function M.forward_word_end()
  forward_word_end("e")
end

--- COMPLETE ATOM: you must map `<Cmd>lua my.motion.forward_WORD_end()<CR>`!!
function M.forward_WORD_end()
  forward_word_end("E")
end

return M
