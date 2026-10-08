--- @class my.env.promax.motion.OPERATOR
local M = {}

function M.backward_word_start()
  vim.cmd("normal! b")
end

function M.backward_word_end()
  vim.cmd("normal! vhgel")
end

function M.forward_word_start()
  my.motion.NORMAL.forward_word_start()
end

function M.forward_word_end()
  vim.cmd("normal! ve")
end

function M.first()
  my.motion.NORMAL.first()
end

function M.last()
  my.motion.NORMAL.last()
end

function M.first_non_blank()
  my.motion.NORMAL.first_non_blank()
end

function M.last_non_blank()
  my.motion.NORMAL.last_non_blank()
end

return M
