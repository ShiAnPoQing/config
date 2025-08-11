local M = {}
local utils = require("utils.mark")
local api = vim.api

--- @class MoveLine
--- @field dir "up" | "down"
--- @field line_number? number

--- @param opts MoveLine
function M.move_line(opts)
  local dir = opts.dir
  local line_number = opts.line_number

  local mode = api.nvim_get_mode().mode
  local line_count = api.nvim_buf_line_count(0)
  local row, col = unpack(api.nvim_win_get_cursor(0))

  local count = vim.v.count1
  if line_number ~= nil then
    count = math.abs(line_number - row)
  end

  if mode == "n" or mode == "i" then
    local lines = api.nvim_buf_get_lines(0, row - 1, row, false)

    if dir == "up" then
      count = -math.min(row - 1, count)
      api.nvim_buf_set_lines(0, row - 1, row, false, {})
      api.nvim_buf_set_lines(0, row + count - 1, row + count - 1, false, lines)
    else
      count = math.min(line_count - row, count)
      api.nvim_buf_set_lines(0, row + count, row + count, false, lines)
      api.nvim_buf_set_lines(0, row - 1, row, false, {})
    end
  end

  if mode == "V" or mode == "" or mode == "v" then
    api.nvim_feedkeys(api.nvim_replace_termcodes("<Esc>", true, true, true), "nx", false)
    local start_row, start_col, end_row, end_col = utils.get_visual_mark(true)
    local lines = api.nvim_buf_get_lines(0, start_row - 1, end_row, false)

    if dir == "up" then
      count = -math.min(start_row - 1, count)
      api.nvim_buf_set_lines(0, start_row - 1, end_row, false, {})
      api.nvim_buf_set_lines(0, start_row + count - 1, start_row + count - 1, false, lines)
    else
      if end_row > row then
        count = count - #lines
      end
      count = math.min(line_count - end_row, count)
      api.nvim_buf_set_lines(0, end_row + count, end_row + count, false, lines)
      api.nvim_buf_set_lines(0, start_row - 1, end_row, false, {})
    end

    if row == start_row then
      utils.set_visual_mark(end_row + count, end_col, start_row + count, start_col)
    else
      utils.set_visual_mark(start_row + count, start_col, end_row + count, end_col)
    end

    api.nvim_feedkeys("gv", "nx", false)
  end

  api.nvim_win_set_cursor(0, { row + count, col })
end

return M
