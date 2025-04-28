local M = {}

local function set_mark(start_pos, end_pos)
  vim.api.nvim_buf_set_mark(0, "<", start_pos[1], start_pos[2], {})
  vim.api.nvim_buf_set_mark(0, ">", end_pos[1], end_pos[2], {})
end

local MoveAction = {
  ["left"] = {
    is_outer_boundary = function(line_to_start, line_to_end)
      return line_to_start == ""
    end,
    get_new_line = function(select, line_to_start, line_to_end)
      local line_to_start_end_char = vim.fn.strcharpart(line_to_start, vim.fn.strchars(line_to_start) - 1, 1)
      local line_to_start_without_end_char = line_to_start:sub(1,
        vim.str_byteindex(line_to_start, vim.fn.strchars(line_to_start) - 1))

      local line = line_to_start_without_end_char .. select .. line_to_start_end_char .. line_to_end
      local mark_offset = - #line_to_start_end_char

      return line, mark_offset
    end
  },
  ["right"] = {
    is_outer_boundary = function(line_to_start, line_to_end)
      return line_to_end == ""
    end,
    get_new_line = function(select, line_to_start, line_to_end)
      local line_to_end_start_char = line_to_end:sub(1, vim.str_byteindex(line_to_end, 1))
      local line_to_end_without_start_char = line_to_end:sub(vim.str_byteindex(line_to_end, 1) + 1)

      local line = line_to_start .. line_to_end_start_char .. select .. line_to_end_without_start_char
      local mark_offset = vim.str_byteindex(line_to_end, 1)

      return line, mark_offset
    end
  }
}


local function select_mode_move(action)
  vim.api.nvim_exec2([[  execute "normal! \<Esc>gvy"  ]], {})
  local Action = MoveAction[action]
  local select = vim.fn.getreg('"')
  local start_row, start_col = unpack(vim.api.nvim_buf_get_mark(0, "<"))
  local _, end_col = unpack(vim.api.nvim_buf_get_mark(0, ">"))

  local line = vim.api.nvim_get_current_line()
  local line_to_start = line:sub(1, start_col)
  local line_to_end = line:sub(start_col + #select + 1)

  if Action.is_outer_boundary(line_to_start, line_to_end) then
    vim.api.nvim_exec2([[  execute "normal! gv\<C-g>"  ]], {})
    return
  end

  local new_line, mark_offset = Action.get_new_line(select, line_to_start, line_to_end)
  vim.api.nvim_buf_set_lines(0, start_row - 1, start_row, false, { new_line })
  set_mark({ start_row, start_col + mark_offset }, { start_row, end_col + mark_offset })

  vim.api.nvim_exec2([[  execute "normal! gv\<C-g>"  ]], {})
end

local function select_block_mode_move(action)
  vim.api.nvim_exec2([[  execute "normal! \<C-g>y"  ]], {})
  local visual_texts = vim.split(vim.fn.getreg('"'), "\n")

  local start_row, start_col = unpack(vim.api.nvim_buf_get_mark(0, "<"))
  local end_row, end_col = unpack(vim.api.nvim_buf_get_mark(0, ">"))

  local lines = vim.api.nvim_buf_get_lines(0, start_row - 1, end_row, false)

  local new_lines = {}
  local first_col_offset
  local last_col_offset

  vim.api.nvim_win_set_cursor(0, { start_row, start_col })

  for i, line in ipairs(lines) do
    local _start_col;
    if i == 1 then
      _start_col = start_col
    else
      vim.api.nvim_feedkeys("j", "nx", false)
      local pos = vim.api.nvim_win_get_cursor(0)
      _start_col = pos[2]
    end

    local line_to_start = line:sub(1, _start_col)
    local text = visual_texts[i]
    local real_end_col = #line_to_start + vim.fn.strlen(text)
    local line_to_end = line:sub(real_end_col + 1)

    if action == "right" then
      local line_to_end_first_char = vim.fn.strcharpart(line_to_end, 0, 1)
      local line_to_end_without_first_char = vim.fn.strcharpart(line_to_end, 1)

      table.insert(new_lines, line_to_start .. line_to_end_first_char .. text .. line_to_end_without_first_char)

      if i == 1 then
        first_col_offset = #line_to_end_first_char
      end

      if i == #lines then
        last_col_offset = #line_to_end_first_char
      end
    else
      local line_to_start_last_char = vim.fn.strcharpart(vim.fn.reverse(line_to_start), 0, 1)
      local line_to_start_without_end_char = vim.fn.reverse(vim.fn.strcharpart(vim.fn.reverse(line_to_start), 1))
      table.insert(new_lines, line_to_start_without_end_char .. text .. line_to_start_last_char .. line_to_end)

      if i == 1 then
        first_col_offset = - #line_to_start_last_char
      end

      if i == #lines then
        last_col_offset = - #line_to_start_last_char
      end
    end
  end

  vim.api.nvim_buf_set_lines(0, start_row - 1, end_row, false, new_lines)
  vim.api.nvim_buf_set_mark(0, "<", start_row, start_col + first_col_offset, {})
  vim.api.nvim_buf_set_mark(0, ">", end_row, end_col + last_col_offset, {})
  vim.api.nvim_feedkeys("gv" .. vim.api.nvim_replace_termcodes("<c-g>", true, true, true), "nx", false)
end

--- @param action "left"|"right"
function M.select_move(action)
  local mode = vim.api.nvim_get_mode().mode
  if mode == "s" then
    select_mode_move(action)
  elseif mode == "" then
    select_block_mode_move(action)
  end
end

return M

-- vim.api.nvim_exec2([[  execute "normal! \<C-g>"  ]], {})
--
-- local count = end_row - start_row + 1
-- for i = 1, count do
--   vim.api.nvim_buf_set_mark(0, "<", start_row + i - 1, start_col, {})
--   vim.api.nvim_buf_set_mark(0, ">", start_row + i - 1, end_col, {})
--   vim.api.nvim_feedkeys("gvdp", "nx", false)
-- end
-- vim.api.nvim_feedkeys("gv" .. vim.api.nvim_replace_termcodes("<Esc>", true, true, true), "nx", false)
-- local last_start_row, last_start_col = unpack(vim.api.nvim_buf_get_mark(0, "<"))
-- local last_end_row, last_end_col = unpack(vim.api.nvim_buf_get_mark(0, ">"))
-- print(last_start_row, last_start_col)
--
-- -- vim.api.nvim_buf_set_mark(0, "<", last_start_row - count - 1, last_start_col, {})
-- -- vim.api.nvim_buf_set_mark(0, ">", last_end_row, end_col, {})
-- --
-- -- vim.api.nvim_feedkeys("gv", "nx", false)

-- vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, true, true), "nx", false)
