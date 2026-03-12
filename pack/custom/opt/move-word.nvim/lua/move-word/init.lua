local M = {}

function M.move_word(direction)
  local count = vim.v.count1
  local line = vim.api.nvim_get_current_line()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local regex = vim.regex("\\k\\+")

  local cursor_word
  local cursor_word_start
  local word_middle
  local next_word

  local col
  if direction == -1 then
    col = #line - cursor[2]
    line = line:reverse()
  elseif direction == 1 then
    col = cursor[2]
  end

  local function run(l)
    local start, end_ = regex:match_str(l)
    if not start then
      return l
    end

    local base = (#line - #l)

    if not cursor_word then
      if start < col - base and end_ >= col - base then
        cursor_word_start = base + start + 1
        cursor_word = l:sub(start + 1, end_)
      end
      return run(l:sub(end_ + 1))
    end

    if not next_word then
      word_middle = l:sub(1, start)
      next_word = l:sub(start + 1, end_)
    end

    return l:sub(end_ + 1)
  end

  local remain_line = run(line)

  if cursor_word then
    if next_word then
      local new_line = line:sub(1, cursor_word_start - 1) .. next_word .. word_middle .. cursor_word .. remain_line
      local move = #next_word + #word_middle
      if direction == -1 then
        new_line = new_line:reverse()
        move = -move
      end
      vim.api.nvim_set_current_line(new_line)
      vim.api.nvim_win_set_cursor(0, { cursor[1], cursor[2] + move })
    end
  end
end

return M
