local function ripairs(t)
  local function iter(t, i)
    i = i - 1
    local v = t[i]
    if v ~= nil then
      return i, v
    end
  end
  return iter, t, #t + 1
end

local function get_current_line_word_matches(line)
  local matches = {}

  line:gsub("()(%S+)(%s*)()", function(start_pos, match, space, end_pos)
    table.insert(matches, {
      text = match,
      space = space,
      start = start_pos,
      end_ = end_pos - 1
    })
  end)

  return matches
end

local function is_current_word_match(match, col)
  if match.space == "" then
    return match.start <= col + 1 and match.end_ >= col
  end

  return match.start <= col + 1 and match.end_ >= col + 1
end

local function is_word_outer_end(match, col, line_len)
  if col + 1 > line_len then
    return true
  end

  return match and is_current_word_match(match, col)
end

local function is_word_outer_start(match, col)
  return match and is_current_word_match(match, col)
end

local function modify_base_col(match, col)
  if vim.api.nvim_get_mode().mode == "n" then
    return math.min(match.start + #match.text - 2, col)
  else
    return math.min(match.start + #match.text - 1, col)
  end
end

local function is_current_word_pre_word(current_word_match, index)
  return current_word_match and index == current_word_match.index - 1
end

local function is_current_word_next_word(current_word_match, index)
  return current_word_match and index == current_word_match.index + 1
end


local function get_cursor_row_col()
  local pos = vim.api.nvim_win_get_cursor(0)
  local row = pos[1]
  local col = pos[2]

  return row, col
end

local function ctrl_left_move_word()
  local line = vim.api.nvim_get_current_line()
  local row, col = get_cursor_row_col()
  local matches = get_current_line_word_matches(line)

  if is_word_outer_start(matches[1], col) then
    return
  end

  local current_word_match;
  local new_col
  local new_line = ""

  for index, match in ripairs(matches) do
    if is_current_word_match(match, col) then
      current_word_match = match
      current_word_match.index = index
      col = modify_base_col(current_word_match, col)
    else
      if is_current_word_pre_word(current_word_match, index) then
        new_line = current_word_match.text .. match.space .. match.text .. current_word_match.space .. new_line
        new_col = col - #match.text - #match.space
      else
        new_line = match.text .. match.space .. new_line
      end
    end
  end

  vim.api.nvim_buf_set_lines(0, row - 1, row, false, { new_line })
  vim.api.nvim_win_set_cursor(0, { row, new_col })
end

local function ctrl_right_move_word()
  local line = vim.api.nvim_get_current_line()
  local row, col = get_cursor_row_col()
  local matches = get_current_line_word_matches(line)

  if is_word_outer_end(matches[#matches], col, #line) then
    return
  end

  local current_word_match;
  local new_col
  local new_line = ""

  for index, match in ipairs(matches) do
    if is_current_word_match(match, col) then
      current_word_match = match
      current_word_match.index = index
      col = modify_base_col(current_word_match, col)
    else
      if is_current_word_next_word(current_word_match, index) then
        new_line = new_line .. match.text .. current_word_match.space .. current_word_match.text .. match.space
        new_col = col + #match.text + #current_word_match.space
      else
        new_line = new_line .. match.text .. match.space
      end
    end
  end

  vim.api.nvim_buf_set_lines(0, row - 1, row, false, { new_line })
  vim.api.nvim_win_set_cursor(0, { row, new_col })
end


return {
  ["<C-right>"] = {
    ctrl_right_move_word,
    { "i", "n" }
  },
  ["<C-left>"] = {
    ctrl_left_move_word,
    { "i", "n" }
  }
}
