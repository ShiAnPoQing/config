--- @class my.env.pro.motion.INSERT
local M = {}

function M._reset_multicursor_to_last_non_blank()
  --- like native: insert mode motion auto follow
  vim.bo.follow = true
  my.motion.NORMAL.last_non_blank()
  vim.bo.follow = false
end

function M._reset_multicursor_to_first_non_blank()
  --- like native: insert mode motion auto follow
  vim.bo.follow = true
  --- ISSUE: if cursor is at line first non blank, feedkey <Esc>, the cursor will not be at the line first non blank
  my.motion.NORMAL._first_non_blank(-1)
  vim.bo.follow = false
end

function M.last_non_blank()
  vim.api.nvim_feedkeys(
    vim.keycode("<Esc><cmd>lua my.motion.INSERT._reset_multicursor_to_last_non_blank()<cr>a"),
    "n",
    false
  )
end

function M.first_non_blank()
  vim.api.nvim_feedkeys(
    vim.keycode("<Esc><cmd>lua my.motion.INSERT._reset_multicursor_to_first_non_blank()<cr>i"),
    "n",
    false
  )
end

function M.backward_word_start()
  vim.api.nvim_feedkeys(vim.keycode("<S-left>"), "n", false)
end

function M.forward_word_start()
  vim.api.nvim_feedkeys(vim.keycode("<S-right>"), "n", false)
end

function M.backward_word_end()
  vim.api.nvim_feedkeys(vim.keycode("<Esc>gea"), "n", false)
end

function M.forward_word_end()
  vim.api.nvim_feedkeys(vim.keycode("<Esc>ea"), "n", false)
end

function M.backward_WORD_start()
  vim.api.nvim_feedkeys(vim.keycode("<Esc>Bi"), "n", false)
end

function M.forward_WORD_start()
  vim.api.nvim_feedkeys(vim.keycode("<C-o>W"), "n", false)
end

function M.backward_WORD_end()
  vim.api.nvim_feedkeys(vim.keycode("<Esc>gEa"), "n", false)
end

function M.forward_WORD_end()
  vim.api.nvim_feedkeys(vim.keycode("<Esc>Ea"), "n", false)
end

return M
