local M = {}

local function feedkeys(key)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, false, true), "nx", true)
end

local function expand_select_word(expand_key, contract_key)
  feedkeys("<Esc>")
  local cursor = vim.api.nvim_win_get_cursor(0)
  local start_row, start_col = unpack(vim.api.nvim_buf_get_mark(0, "<"))

  if start_row == cursor[1] and start_col == cursor[2] then
    feedkeys("gv" .. expand_key .. "<C-g>")
  else
    feedkeys("gv" .. contract_key .. "<C-g>")
  end
end

function M.expand_select_left_word()
  expand_select_word("b", "ge")
end

function M.expand_select_right_word()
  expand_select_word("w", "e")
end

function M.expand_select_left_word_with_blank()
  expand_select_word("hgel", "bh")
end

function M.expand_select_right_word_with_blank()
  expand_select_word("el", "lwh")
end

return M
