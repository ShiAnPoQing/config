--- @class my.profile.pro.motion.VISUAL
local M = {}

function M.first_non_blank()
  vim.cmd("normal! ^")
end

function M.last_non_blank()
  vim.cmd("normal! g_")
end

function M.first()
  vim.cmd("normal! 0")
end

function M.last()
  vim.cmd("normal! $h")
end

function M.backward_word_end()
  if vim.fn.col(".") == 1 then
    vim.cmd("normal! " .. vim.v.count1 .. "ge" .. "l")
  else
    vim.cmd("normal! " .. "h" .. vim.v.count1 .. "ge" .. "l")
  end
end

function M.forward_word_end()
  my.profile.pro.motion.NORMAL.forward_word_end()
end

function M.backward_word_start()
  my.profile.pro.motion.NORMAL.backward_word_start()
end

function M.forward_word_start()
  if vim.fn.col(".") == 1 then
    vim.cmd("normal! " .. vim.v.count1 .. "w" .. "h")
  else
    vim.cmd("normal! " .. "l" .. vim.v.count1 .. "w" .. "h")
  end
end

function M.forward_WORD_start()
  if vim.fn.col(".") == 1 then
    vim.cmd("normal! " .. vim.v.count1 .. "W" .. "h")
  else
    vim.cmd("normal! " .. "l" .. vim.v.count1 .. "W" .. "h")
  end
end

function M.backward_WORD_end()
  if vim.fn.col(".") == 1 then
    vim.cmd("normal! " .. vim.v.count1 .. "gE" .. "l")
  else
    vim.cmd("normal! " .. "h" .. vim.v.count1 .. "gE" .. "l")
  end
end

function M.forward_WORD_end()
  my.profile.pro.motion.NORMAL.forward_WORD_end()
end

function M.backward_WORD_start()
  my.profile.pro.motion.NORMAL.backward_WORD_start()
end

return M
