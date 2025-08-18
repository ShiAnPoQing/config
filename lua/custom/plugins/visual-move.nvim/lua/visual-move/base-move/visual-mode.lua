local M = {}

local Mode = {
  select = {
    prepare = function()
      vim.cmd("normal \\<C-g>y")
    end,
    reselect = function(cursor, start_col)
      local key = cursor[2] == start_col and "o" or ""
      vim.api.nvim_feedkeys("gv" .. key .. vim.api.nvim_replace_termcodes("<c-g>", true, true, true), "n", false)
    end,
  },
  visual = {
    prepare = function()
      vim.cmd("normal y")
    end,
    reselect = function(cursor, start_col)
      local key = cursor[2] == start_col and "o" or ""
      vim.api.nvim_feedkeys("gv" .. key, "n", false)
    end,
  },
}

local Direction = {
  left = {
    get_new_line = function(line_to_start, line_to_end, text)
      local line_to_start_reverse = vim.fn.reverse(line_to_start)
      local line_to_start_part2 = vim.fn.strcharpart(line_to_start_reverse, 0, 1)
      local line_to_start_part1 = vim.fn.reverse(vim.fn.strcharpart(line_to_start_reverse, 1))
      local new_line = line_to_start_part1 .. text .. line_to_start_part2 .. line_to_end
      local col_offset = -#line_to_start_part2
      return new_line, col_offset
    end,
  },
  right = {
    get_new_line = function(line_to_start, line_to_end, text)
      local line_to_end_part1 = vim.fn.strcharpart(line_to_end, 0, 1)
      local line_to_end_part2 = vim.fn.strcharpart(line_to_end, 1)
      local new_line = line_to_start .. line_to_end_part1 .. text .. line_to_end_part2
      local col_offset = #line_to_end_part1
      return new_line, col_offset
    end,
  },
}

local function get_mode()
  local mode = vim.api.nvim_get_mode().mode
  if mode == "s" then
    return "select"
  end
  if mode == "" then
    return "select"
  end
  if mode == "v" then
    return "visual"
  end
  if mode == "" then
    return "visual"
  end
end

local function more_line_move(Md, Dir, text, start_row, start_col, end_row, end_col, cursor)
  local lines = vim.api.nvim_buf_get_lines(0, start_row - 1, end_row, false)
  local texts = vim.fn.split(text, "\n")
  local last_text = texts[#texts]
  local line_to_start = lines[1]:sub(1, start_col)
  local line_to_end = lines[#lines]:sub(vim.fn.strlen(last_text) + 1)
  local new_line, col_offset = Dir.get_new_line(line_to_start, line_to_end, text)
  vim.api.nvim_buf_set_lines(0, start_row - 1, end_row, false, vim.fn.split(new_line, "\n"))
  vim.api.nvim_buf_set_mark(0, "<", start_row, start_col + col_offset, {})
  vim.api.nvim_buf_set_mark(0, ">", end_row, end_col, {})
  Md.reselect(cursor, start_col)
end

local function one_line_move(Md, Dir, text, start_row, start_col, end_row, end_col, cursor)
  local line = vim.api.nvim_buf_get_lines(0, start_row - 1, end_row, false)[1]
  local line_to_start = line:sub(1, start_col)
  local line_to_end = line:sub(#line_to_start + vim.fn.strlen(text) + 1)
  local new_line, col_offset = Dir.get_new_line(line_to_start, line_to_end, text)
  vim.api.nvim_buf_set_lines(0, start_row - 1, end_row, false, { new_line })
  vim.api.nvim_buf_set_mark(0, "<", start_row, start_col + col_offset, {})
  vim.api.nvim_buf_set_mark(0, ">", end_row, end_col + col_offset, {})
  Md.reselect(cursor, start_col)
end

--- @param dir "left"| "right"
function M.visual_mode_move(dir)
  local cursor = vim.api.nvim_win_get_cursor(0)
  local Md = Mode[get_mode()]
  local Dir = Direction[dir]

  if not Md or not Dir then
    return
  end

  Md.prepare()
  local start_row, start_col = unpack(vim.api.nvim_buf_get_mark(0, "<"))
  local end_row, end_col = unpack(vim.api.nvim_buf_get_mark(0, ">"))
  local text = vim.fn.getreg('"')

  if end_row == start_row then
    one_line_move(Md, Dir, text, start_row, start_col, end_row, end_col, cursor)
  else
    more_line_move(Md, Dir, text, start_row, start_col, end_row, end_col, cursor)
  end
end

return M
