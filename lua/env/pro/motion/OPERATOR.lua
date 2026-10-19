-- {operator}{motion}:
--    1. {motion}: a |:map-<expr>| mapping
--    2. {motion}: a Lua function do `normal[!] {motion}`
--    3. {motion}: a Lua function do `normal[!] v{motion}`
--          WARNING: after do `normal[!] v{motion}`, you will not be able to exit visual mode use `normal! v`.
--          vim.cmd(normal! vw)
--          vim.cmd(normal! v) will not exit visual mode.
-- Word motion:
--  1. 'iskeyword' 决定哪些字符属于 keyword。
--  2. 连续的 keyword 字符构成一个 word。
--  3. 连续的非空白、非 keyword 字符也构成一个 word。
--  4. 连续空白不是 word，而是两个 word 之间的分隔区域。
--  5. WORD 则简单得多：连续非空白字符就是一个 WORD。

--- @class my.env.pro.motion.OPERATOR
local M = {}

-- 'selection'='inclusive'
-- 1 0 db
-- 1 0 d:normal! b
-- 1 1 d:normal! vb
-- 'selection'='exclusive'
-- 1 0 db
-- 1 0 d:normal! b
-- 1 0 d:normal! vb
--- @param is_WORD boolean|nil
local function backward_word_start(is_WORD)
  local key = is_WORD and "B" or "b"
  local TYPE = is_WORD and "WORD" or "word"
  --- Builtin behavior: Cursor at the start of the word, exclude the cursor point
  if my.cursor[string.format("at_%s_start", TYPE)]() then
    vim.cmd("normal! " .. vim.v.count1 .. key)
    return
  end
  -- Change builtin behavior: Cursor is not at the start of the word, Include the cursor point(1 0 -> 1 1)
  vim.cmd("normal! v" .. vim.v.count1 .. key)
end

-- 'selection'='inclusive'
-- 1 1 dge
-- 1 1 d:normal! vge
-- 1 0 d:normal! ge
-- 'selection'='exclusive'
-- 1 1 dge
-- 1 0 d:normal! vge          <-
-- 1 0 d:normal! ge
--- @param is_WORD boolean|nil
local function backward_word_end(is_WORD)
  local TYPE = is_WORD and "WORD" or "word"
  local motion = "normal! v" .. vim.v.count1 .. (is_WORD and "gE" or "ge")
  local prev_word = my.cursor[string.format("match_prev_%s", TYPE)]() -- (1, 0) based
  local at_word_start = my.cursor[string.format("at_%s_start", TYPE)]()

  if not at_word_start then
    if prev_word then
      motion = motion .. "l"
    end
  else
    local col = vim.fn.col(".")
    local line = vim.fn.line(".")
    if not prev_word then
      if col == 1 and line == 1 then
        return
      end
    else
      if line == prev_word.line and col == prev_word.end_col + 1 then
        return
      end
      motion = motion .. "l"
    end
  end

  if at_word_start then
    local old_selection = vim.o.selection
    vim.o.selection = "exclusive"
    vim.cmd(motion)
    vim.api.nvim_feedkeys(vim.keycode(string.format("<cmd>set selection=%s<cr>", old_selection)), "ni", true)
    return
  end

  vim.cmd(motion)
end

-- 'selection'='inclusive'
-- 1 1 de
-- 1 1 d:normal! ve
-- 1 0 d:normal! e
-- 'selection'='exclusive'
-- 1 1 de
-- 1 1 d:normal! ve
-- 1 0 d:normal! e

--- @param is_WORD boolean|nil
local function forward_word_end(is_WORD)
  local key = is_WORD and "E" or "e"
  local TYPE = is_WORD and "WORD" or "word"
  --- Change builtin behavior: Cursor at the end of the word: exclude the cursor point(1 1 -> 0 1)
  --- case1: next word exists
  --- case2: next word doesn't exist
  ---        case2.1: forward has no blank
  ---        case2.2: forward has blank
  if my.cursor[string.format("at_%s_end", TYPE)]() then
    local next_word = my.cursor[string.format("match_next_%s", TYPE)]() -- (1, 0) based

    if next_word then
      -- case1:
      vim.cmd("normal! v" .. vim.v.count1 .. key .. "ol")
    else
      -- case2:
      -- -- BUG: I don't know why 'veol' doesn't work.
      vim.cmd("normal! vG$ol")
    end
    return
  end
  -- Builtin behavior: 1 1, Like `de`.
  vim.cmd("normal! v" .. vim.v.count1 .. key)
end

-- 'selection'='inclusive'
-- 1 0 dw
-- 1 0 d:normal! w
-- 1 1 d:normal! vw
-- 'selection'='exclusive'
-- 1 0 dw
-- 1 0 d:normal! w
-- 1 0 d:normal! vw
--- @param is_WORD boolean|nil
local function forward_word_start(is_WORD)
  local key = is_WORD and "W" or "w"
  local TYPE = is_WORD and "WORD" or "word"
  -- Change builtin behavior: 1 0 -> 0 0
  -- case1: next word exists
  -- case2: next word doesn't exist
  --        case2.1. forward has no blank
  --        case2.2. forward has blank
  local function is_forward_no_next_word_and_no_blank(col)
    return col == #vim.api.nvim_get_current_line() and vim.fn.line(".") == vim.fn.line("$")
  end

  if my.cursor[string.format("at_%s_end", TYPE)]() then
    local col = vim.fn.col(".")
    local next_word = my.cursor[string.format("match_next_%s", TYPE)]() -- (1, 0) based
    -- case2:
    if not next_word then
      if not is_forward_no_next_word_and_no_blank(col) then
        -- case2.2:
        local old_selection = vim.o.selection
        vim.o.selection = "exclusive"
        vim.cmd("normal! v" .. vim.v.count1 .. key .. "ol")
        vim.api.nvim_feedkeys(vim.keycode(string.format("<cmd>set selection=%s<cr>", old_selection)), "ni", true)
      else
        -- case2.1: not moved, nothing to do
        -- one case: cursor is at the end of the buffer
      end
      return
    end
    -- case1:
    local line = vim.fn.line(".")
    if line == next_word.line then
      if col ~= next_word.col then
        -- has space between the two words.
        -- like: "Hell|o|    World"
        local old_selection = vim.o.selection
        vim.o.selection = "exclusive"
        vim.cmd("normal! v" .. vim.v.count1 .. key .. "ol")
        vim.api.nvim_feedkeys(vim.keycode(string.format("<cmd>set selection=%s<cr>", old_selection)), "ni", true)
      else
        -- has no space between the two words, nothing to do
        -- like: 'Hell|o|.....'
      end
    else
      local old_selection = vim.o.selection
      vim.o.selection = "exclusive"
      vim.cmd("normal! v" .. vim.v.count1 .. key .. "ol")
      vim.api.nvim_feedkeys(vim.keycode(string.format("<cmd>set selection=%s<cr>", old_selection)), "ni", true)
    end
    return
  end
  -- Builtin behavior: 1 0, Like `dw`.
  vim.cmd("normal! " .. key)
end

function M.backward_word_start()
  backward_word_start()
end

function M.backward_WORD_start()
  backward_word_start(true)
end

--- COMPLETE ATOM: you must map `<Cmd>lua my.motion.OPERATOR_PENDING.backward_word_end()<CR>`!!
function M.backward_word_end()
  backward_word_end()
end

--- COMPLETE ATOM: you must map `<Cmd>lua my.motion.OPERATOR_PENDING.backward_WORD_end()<CR>`!!
function M.backward_WORD_end()
  backward_word_end(true)
end

--- COMPLETE ATOM: you must map `<Cmd>lua my.motion.OPERATOR_PENDING.forward_word_start()<CR>`!!
function M.forward_word_start()
  forward_word_start()
end

--- COMPLETE ATOM: you must map `<Cmd>lua my.motion.OPERATOR_PENDING.forward_WORD_start()<CR>`!!
function M.forward_WORD_start()
  forward_word_start(true)
end

--- COMPLETE ATOM: you must map `<Cmd>lua my.motion.OPERATOR_PENDING.forward_word_end()<CR>`!!
function M.forward_word_end()
  forward_word_end()
end

--- COMPLETE ATOM: you must map `<Cmd>lua my.motion.OPERATOR_PENDING.forward_WORD_end()<CR>`!!
function M.forward_WORD_end()
  forward_word_end(true)
end

-- :h $
-- :h g_
function M.last_non_blank()
  local line = vim.api.nvim_get_current_line()
  local last_non_blank_col = line:reverse():find("%S")
  if not last_non_blank_col then
    vim.cmd("normal! v0")
    return
  end
  last_non_blank_col = #line - last_non_blank_col + 1
  local col = vim.fn.col(".")
  if col == last_non_blank_col then
    if col == #line then
      -- :h 'selection'
      -- past line
      vim.cmd("normal! v$ol")
    else
      vim.cmd("normal! lv$h")
    end
    return
  end
  if my.cursor.at_word_end() then
    vim.cmd("normal! vg_ol")
    return
  end
  if col > last_non_blank_col then
    vim.cmd("normal! vg_l")
    return
  end
  vim.cmd("normal! vg_")
end

function M.first_non_blank()
  local line = vim.api.nvim_get_current_line()
  local first_non_blank_col = line:find("%S")
  if not first_non_blank_col then
    vim.cmd("normal! v0")
    return
  end
  local col = vim.fn.col(".")
  if col == first_non_blank_col then
    if col == 1 then
      --- :h 'selection'
      --- past line
      vim.cmd("normal! v" .. vim.keycode("<bs>") .. "o" .. vim.keycode("<bs>"))
    else
      vim.cmd("normal! 0")
    end
    return
  end
  if my.cursor.at_word_start() then
    vim.cmd("normal! ^")
    return
  end
  if col < first_non_blank_col then
    vim.cmd("normal! v^h")
    return
  end
  vim.cmd("normal! v^")
end

function M.last()
  local line = vim.api.nvim_get_current_line()
  local last_non_blank_col = line:reverse():find("%S")
  if not last_non_blank_col then
    vim.cmd("normal! v0")
    return
  end
  last_non_blank_col = #line - last_non_blank_col + 1
  local col = vim.fn.col(".")
  if col == #line then
    -- :h 'selection'
    -- past line
    vim.cmd("normal! v$ol")
    return
  end
  if col == last_non_blank_col then
    vim.cmd("normal! lv$h")
    return
  end
  if my.cursor.at_word_end() then
    vim.cmd("normal! v$hol")
    return
  end
  vim.cmd("normal! v$h")
end

function M.first()
  local line = vim.api.nvim_get_current_line()
  local first_non_blank_col = line:find("%S")
  if not first_non_blank_col then
    vim.cmd("normal! v0")
    return
  end
  local col = vim.fn.col(".")
  if col == 1 then
    --- :h 'selection'
    --- past line
    vim.cmd("normal! v" .. vim.keycode("<bs>") .. "o" .. vim.keycode("<bs>"))
    return
  end
  if col == first_non_blank_col then
    vim.cmd("normal! 0")
    return
  end
  if my.cursor.at_word_start() then
    vim.cmd("normal! 0")
    return
  end
  vim.cmd("normal! v0")
end

function M.forward_paragraph_end()
  local shared = my.motion._shared --[[@as my.env.pro.motion._shared]]
  local lnum = shared.find_forward_paragraph_end(vim.v.count1)
  if not lnum then
    return
  end
  vim.api.nvim_buf_set_mark(0, "[", vim.fn.line("."), vim.fn.col("."))
  vim.api.nvim_buf_set_mark(0, "]", lnum, vim.fn.col("."))
  vim.cmd("normal! `[V`]")
end

function M.backward_paragraph_start()
  local shared = my.motion._shared --[[@as my.env.pro.motion._shared]]
  local lnum = shared.find_backward_paragraph_start(vim.v.count1)
  if not lnum then
    return
  end
  vim.api.nvim_buf_set_mark(0, "[", vim.fn.line("."), vim.fn.col("."))
  vim.api.nvim_buf_set_mark(0, "]", lnum, vim.fn.col("."))
  vim.cmd("normal! `[V`]")
end

function M.backward_paragraph_end()
  local shared = my.motion._shared --[[@as my.env.pro.motion._shared]]
  local backward_paragraph_start_lnum = shared.find_backward_paragraph_start(1, vim.fn.line(".") + 1)
  local lnum = shared.find_backward_paragraph_end(vim.v.count1)
  if not lnum then
    return
  end
  local start_line = vim.fn.line(".")
  if start_line == backward_paragraph_start_lnum then
    start_line = start_line - 1
  end
  vim.api.nvim_buf_set_mark(0, "[", start_line, vim.fn.col("."))
  vim.api.nvim_buf_set_mark(0, "]", lnum + 1, vim.fn.col("."))
  vim.cmd("normal! `[V`]")
end

function M.forward_paragraph_start()
  local shared = my.motion._shared --[[@as my.env.pro.motion._shared]]
  local forward_paragraph_end_lnum = shared.find_forward_paragraph_end(1, vim.fn.line(".") - 1)
  local lnum = shared.find_forward_paragraph_start(vim.v.count1)
  if not lnum then
    return
  end
  local start_line = vim.fn.line(".")
  if start_line == forward_paragraph_end_lnum then
    start_line = start_line + 1
  end
  vim.api.nvim_buf_set_mark(0, "[", start_line, vim.fn.col("."))
  vim.api.nvim_buf_set_mark(0, "]", lnum - 1, vim.fn.col("."))
  vim.cmd("normal! `[V`]")
end

function M.paragraph_lead_whitespace()
  local shared = my.motion._shared --[[@as my.env.pro.motion._shared]]
  local start_lnum = shared.find_backward_paragraph_end(1)
  local end_lnum = shared.find_backward_paragraph_start(1, vim.fn.line(".") + 1)
  if not end_lnum or not start_lnum then
    return
  end
  vim.api.nvim_buf_set_mark(0, "[", start_lnum + 1, vim.fn.col("."))
  vim.api.nvim_buf_set_mark(0, "]", end_lnum - 1, vim.fn.col("."))
  vim.cmd("normal! `[V`]")
end

function M.paragraph_trail_whitespace()
  local shared = my.motion._shared --[[@as my.env.pro.motion._shared]]
  local start_lnum = shared.find_forward_paragraph_end(1, vim.fn.line(".") - 1)
  local end_lnum = shared.find_forward_paragraph_start(1)
  if not end_lnum or not start_lnum then
    return
  end
  vim.api.nvim_buf_set_mark(0, "[", start_lnum + 1, vim.fn.col("."))
  vim.api.nvim_buf_set_mark(0, "]", end_lnum - 1, vim.fn.col("."))
  vim.cmd("normal! `[V`]")
end

function M.line_lead_whitespace()
  local lnum = vim.fn.line(".")
  local line = vim.api.nvim_get_current_line()
  local col = line:find("%S") or #line + 1
  col = col - 1
  if col <= 0 then
    return
  end
  vim.api.nvim_buf_set_mark(0, "[", lnum, 0)
  vim.api.nvim_buf_set_mark(0, "]", lnum, col - 1)
  vim.cmd("normal! `[v`]")
end

function M.line_trail_whitespace()
  local lnum = vim.fn.line(".")

  local line = vim.api.nvim_get_current_line()
  local col = line:reverse():find("%S")
  if not col then
    col = 0
  else
    col = #line - col + 1
  end
  if col == #line then
    return
  end
  vim.api.nvim_buf_set_mark(0, "[", lnum, col)
  vim.api.nvim_buf_set_mark(0, "]", lnum, #line)
  vim.cmd("normal! `[v`]")
end

return M
