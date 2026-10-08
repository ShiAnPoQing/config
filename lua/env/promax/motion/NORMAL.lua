--- @class my.env.promax.motion.NORMAL
local M = {}

function M.first()
  vim.cmd("normal! 0")
end

function M.last()
  local line = vim.api.nvim_get_current_line()
  vim.api.nvim_win_set_cursor(0, { vim.fn.line("."), #line })
end

function M.first_non_blank()
  vim.cmd("normal! ^")
end

function M.last_non_blank()
  local line = vim.api.nvim_get_current_line()
  local col = line:reverse():find("%S") or 0
  col = #line - col + 1
  vim.api.nvim_win_set_cursor(0, { vim.fn.line("."), col })
end

function M.backward_word_start()
  vim.cmd("normal! b")
end

function M.backward_word_end()
  vim.cmd("normal! " .. vim.keycode("<bs>") .. "gel")
end

function M.forward_word_start()
  vim.cmd("normal! w")
end

function M.forward_word_end()
  vim.cmd("normal! el")
end

function M.backward_WORD_start()
  vim.cmd("normal! B")
end

function M.backward_WORD_end()
  vim.cmd("normal! " .. vim.keycode("<bs>") .. "gEl")
end

function M.forward_WORD_start()
  vim.cmd("normal! W")
end

function M.forward_WORD_end()
  vim.cmd("normal! El")
end

return M
