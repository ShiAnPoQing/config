--- @class my.profile.promax.motion.OPERATOR
local M = {}

function M.backward_word_start()
  vim.cmd("normal! b")
end

function M.backward_word_end()
  vim.cmd("normal! vhgel")
end

function M.forward_word_start()
  my.profile.promax.motion.NORMAL.forward_word_start()
end

function M.forward_word_end()
  vim.cmd("normal! e")
end

function M.first()
  my.profile.promax.motion.NORMAL.first()
end

function M.last()
  my.profile.promax.motion.NORMAL.last()
end

function M.first_non_blank()
  my.profile.promax.motion.NORMAL.first_non_blank()
end

function M.last_non_blank()
  my.profile.promax.motion.NORMAL.last_non_blank()
end

return M
