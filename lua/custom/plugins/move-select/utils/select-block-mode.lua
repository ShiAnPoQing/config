local Select = {}

function Select:init()
  self.texts = vim.split(vim.fn.getreg('"'), "\n")
  self.text_display_width = nil
  self.balance = true
end

function Select:revise_select_start_char(i)
  local text = self.texts[i]
  local real_first_char = vim.fn.getreg('"')
  self.texts[i] = real_first_char .. vim.fn.strcharpart(text, 1)
end

function Select:revise_select_end_char(i)
  local text = self.texts[i]
  local real_end_char = vim.fn.getreg('"')
  local select_text = vim.fn.strcharpart(text, 0, vim.fn.strcharlen(text) - 1) .. real_end_char
  self.texts[i] = select_text
  self:check_balance(select_text)
end

function Select:check_balance(select_text)
  if self.text_display_width ~= nil then
    if self.text_display_width ~= vim.fn.strdisplaywidth(select_text) then
      self.balance = false
    end
  else
    self.text_display_width = vim.fn.strdisplaywidth(select_text)
  end
end

local function move_to_select_text_start_col(callback, start_row, start_col, line_count)
  vim.api.nvim_win_set_cursor(0, { start_row, start_col })
  local poss = {}
  for i = 1, line_count do
    if i > 1 then
      vim.api.nvim_feedkeys("j", "nx", false)
    end
    table.insert(poss, vim.api.nvim_win_get_cursor(0))
  end

  for i = 1, line_count do
    local pos = poss[i]
    vim.api.nvim_win_set_cursor(0, pos)
    vim.api.nvim_feedkeys("vy", "nx", false)
    callback(i, pos[2])
  end
end

local function move_to_select_text_end_col(callback, end_row, end_col, line_count)
  vim.api.nvim_win_set_cursor(0, { end_row, end_col })
  local poss = {}
  for i = 1, line_count do
    if i > 1 then
      vim.api.nvim_feedkeys("k", "nx", false)
    end
    table.insert(poss, 1, vim.api.nvim_win_get_cursor(0))
  end

  for i = 1, line_count do
    local pos = poss[i]
    vim.api.nvim_win_set_cursor(0, pos)
    vim.api.nvim_feedkeys("vy", "nx", false)
    callback(i, pos[2])
  end
end

function Select:select_text_iter(callback1, callback2, start_row, start_col, end_row, end_col)
  local line_count = end_row - start_row + 1
  if start_col <= end_col then
    move_to_select_text_start_col(callback1, start_row, start_col, line_count)
    move_to_select_text_end_col(callback2, end_row, end_col, line_count)
  else
    move_to_select_text_end_col(callback1, end_row, end_col, line_count)
    move_to_select_text_start_col(callback2, start_row, start_col, line_count)
  end
end

return Select
