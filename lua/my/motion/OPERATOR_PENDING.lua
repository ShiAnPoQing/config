--- @class my.motion.OPERATOR_PENDING
local M = {}

local function backward_word_start(key)
  if my.cursor.is_word_start() then
    vim.cmd("normal! " .. key)
    return
  end
  vim.cmd("normal! v" .. key)
end

function M.backward_word_start()
  backward_word_start("b")
end

function M.backward_WORD_start()
  backward_word_start("B")
end

local function backward_word_end(key)
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
end

--- COMPLETE ATOM: you must map `<Cmd>lua my.motion.OPERATOR_PENDING.backward_word_end()<CR>`!!
function M.backward_word_end()
  backward_word_end("ge")
end

--- COMPLETE ATOM: you must map `<Cmd>lua my.motion.OPERATOR_PENDING.backward_WORD_end()<CR>`!!
function M.backward_WORD_end()
  backward_word_end("gE")
end

local function forward_word_end(key)
  if my.cursor.is_word_end() then
    vim.cmd("normal! v" .. key .. "ol")
    return
  end
  vim.cmd("normal! v" .. key)
end

--- COMPLETE ATOM: you must map `<Cmd>lua my.motion.OPERATOR_PENDING.forward_word_end()<CR>`!!
function M.forward_word_end()
  forward_word_end("e")
end

--- COMPLETE ATOM: you must map `<Cmd>lua my.motion.OPERATOR_PENDING.forward_WORD_end()<CR>`!!
function M.forward_WORD_end()
  forward_word_end("E")
end

local function forward_word_start(key)
  if my.cursor.is_word_end() then
    local col1 = vim.fn.col(".")
    vim.cmd("normal! v" .. key)
    local col2 = vim.fn.col(".")
    if col2 == col1 + 1 then
      vim.cmd("normal! v")
    else
      vim.cmd("normal! hol")
    end
    return
  end
  vim.cmd("normal! w")
end
--- COMPLETE ATOM: you must map `<Cmd>lua my.motion.OPERATOR_PENDING.forward_word_start()<CR>`!!
function M.forward_word_start()
  forward_word_start("w")
end

--- COMPLETE ATOM: you must map `<Cmd>lua my.motion.OPERATOR_PENDING.forward_WORD_start()<CR>`!!
function M.forward_WORD_start()
  forward_word_start("W")
end

function M.last_non_blank()
  vim.cmd("normal! vg_")
end

function M.first_non_blank()
  vim.cmd("normal! ^")
end

function M.last()
  vim.cmd("normal! v$h")
end

function M.first()
  vim.cmd("normal! 0")
end

return M
