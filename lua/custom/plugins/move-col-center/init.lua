local M = {}

local function get_offset(offset, count)
  for i = 1, count do
    offset = (offset - 1) / 2
    if offset % 1 ~= 0 then
      offset = math.floor(offset)
    end
  end

  return offset
end

local function move_revise(offset, cursor_to_viewport_left_text)
  local move = 0
  local function run(next)
    if vim.fn.strdisplaywidth(vim.fn.strcharpart(cursor_to_viewport_left_text, 0, next)) > offset then
      move = move + 1
      run(next - 1)
    end
  end
  run(offset)
  return move
end

--- @param LR "left"|"right"
function M.move_col_center(LR)
  local count = vim.v.count1
  local line = vim.api.nvim_get_current_line()
  local virtcol = vim.fn.virtcol(".")
  local cursor = vim.api.nvim_win_get_cursor(0)
  local wininfo = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]

  if LR == "left" then
    local viewport_virtcol = virtcol - wininfo.leftcol
    local line_display_width = vim.fn.strdisplaywidth(line)
    local offset = get_offset(viewport_virtcol, count)

    if line_display_width > virtcol then
      vim.api.nvim_feedkeys("g0", "nx", false)
      local cursor_at_screen_left = vim.api.nvim_win_get_cursor(0)
      local cursor_to_viewport_left_text = vim.api.nvim_buf_get_text(0, cursor[1] - 1, cursor_at_screen_left[2],
        cursor[1] - 1,
        cursor[2] + 1, {})[1]
      local move = move_revise(offset, cursor_to_viewport_left_text)

      if move > 0 then
        vim.api.nvim_feedkeys(offset - move .. "l", "nx", false)
      else
        vim.api.nvim_win_set_cursor(0, { cursor[1], cursor_at_screen_left[2] + offset })
      end
    else
      if wininfo.leftcol >= line_display_width then
        vim.api.nvim_feedkeys("g0" .. offset + 1 .. "l", "nx", false)
      else
        vim.api.nvim_feedkeys("g0", "nx", false)
        local cursor_at_screen_left = vim.api.nvim_win_get_cursor(0)
        local cursor_to_viewport_left_text = vim.api.nvim_buf_get_text(0, cursor[1] - 1, cursor_at_screen_left[2],
          cursor[1] - 1,
          cursor[2] + 1, {})[1]

        if offset <= vim.fn.strdisplaywidth(cursor_to_viewport_left_text) then
          local move = move_revise(offset, cursor_to_viewport_left_text)
          if move > 0 then
            vim.api.nvim_feedkeys(offset - move .. "l", "nx", false)
          else
            vim.api.nvim_win_set_cursor(0, { cursor[1], cursor_at_screen_left[2] + offset })
          end
        else
          vim.api.nvim_win_set_cursor(0, { cursor[1], #line })
          local move_count = offset - vim.fn.strdisplaywidth(cursor_to_viewport_left_text) + 1
          vim.api.nvim_feedkeys(move_count .. "l", "nx", false)
        end
      end
    end
  else

  end
end

return M
