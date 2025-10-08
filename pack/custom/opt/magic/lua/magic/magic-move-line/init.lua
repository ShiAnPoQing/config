local M = {}
local api = vim.api
local utils = require("utils.mark")

local Key = require("magic.key")
local Line_hl = require("magic.line-hl")

local Action = {
  up = {
    visual = {},
    normal = {},
  },
  down = {
    visual = {},
    normal = {},
  },
}

local function esc()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, true, true), "nx", false)
end

local function revisual(start_row, end_row, start_col, end_col, row, col, count)
  if row == start_row then
    utils.set_visual_mark(end_row + count, end_col, start_row + count, start_col)
  else
    utils.set_visual_mark(start_row + count, start_col, end_row + count, end_col)
  end
  api.nvim_feedkeys("gv", "nx", false)
  api.nvim_win_set_cursor(0, { row + count, col })
end

local function get_mode()
  local mode = vim.api.nvim_get_mode().mode
  if mode == "V" or mode == "" or mode == "v" then
    return "visual"
  end
  return "normal"
end

function Action.up:main(topline, _)
  local cursor = vim.api.nvim_win_get_cursor(0)
  local mode = get_mode()
  local Mode = self[mode]
  Mode:init({
    cursor = cursor,
  })
  local offset = Mode:get_offset(cursor)
  local startline = topline
  local endline = cursor[1] - 1 + offset
  return startline, endline, function(line_number)
    Mode:move_line(line_number)
  end
end

function Action.down:main(_, botline)
  local cursor = vim.api.nvim_win_get_cursor(0)
  local Mode = self[get_mode()]
  Mode:init({
    cursor = cursor,
  })
  local offset = Mode:get_offset(cursor)
  local startline = cursor[1] + 1 - offset
  local endline = botline

  return startline, endline, function(line_number)
    Mode:move_line(line_number)
  end
end

function Action.up.visual:init(opts)
  esc()
  local start_row, start_col, end_row, end_col = utils.get_visual_mark(true)
  vim.cmd("norm! gv")
  self.start_row = start_row
  self.start_col = start_col
  self.end_row = end_row
  self.end_col = end_col
  self.cursor = opts.cursor
end

function Action.down.visual:init(opts)
  esc()
  local start_row, start_col, end_row, end_col = utils.get_visual_mark(true)
  vim.cmd("norm! gv")
  self.start_row = start_row
  self.start_col = start_col
  self.end_row = end_row
  self.end_col = end_col
  self.cursor = opts.cursor
end

function Action.down.visual:get_offset(cursor)
  local offset = 0
  if cursor[1] < self.end_row then
    offset = -math.abs(self.end_row - self.start_row)
  end
  return offset
end

function Action.down.visual:move_line(line_number)
  esc()
  local row, col = unpack(self.cursor)
  local lines = api.nvim_buf_get_lines(0, row - 1, row, false)
  local line_count = api.nvim_buf_line_count(0)
  local count = line_number - row
  count = math.min(line_count - self.end_row, count)
  api.nvim_buf_set_lines(0, self.end_row + count, self.end_row + count, false, lines)
  api.nvim_buf_set_lines(0, self.start_row - 1, self.end_row, false, {})
  revisual(self.start_row, self.end_row, self.start_col, self.end_col, row, col, count)
end

function Action.up.visual:get_offset(cursor)
  local offset = 0
  if cursor[1] > self.start_row then
    offset = -math.abs(self.end_row - self.start_row)
  end
  return offset
end

function Action.up.visual:move_line(line_number)
  esc()
  local row, col = unpack(self.cursor)
  local lines = api.nvim_buf_get_lines(0, row - 1, row, false)
  local count = row - line_number
  count = -math.min(self.start_row - 1, count)
  api.nvim_buf_set_lines(0, self.start_row - 1, self.end_row, false, {})
  api.nvim_buf_set_lines(0, self.start_row + count - 1, self.start_row + count - 1, false, lines)
  revisual(self.start_row, self.end_row, self.start_col, self.end_col, row, col, count)
end

function Action.up.normal:init(opts)
  self.cursor = opts.cursor
end

function Action.down.normal:init(opts)
  self.cursor = opts.cursor
end

function Action.up.normal:get_offset()
  return 0
end

function Action.down.normal:get_offset()
  return 0
end

function Action.up.normal:move_line(line_number)
  local row, col = unpack(self.cursor)
  local line = vim.api.nvim_get_current_line()
  local count = row - line_number
  count = -math.min(row - 1, count)
  vim.api.nvim_buf_set_lines(0, row - 1, row, false, {})
  vim.api.nvim_buf_set_lines(0, row + count - 1, row + count - 1, false, { line })
  vim.api.nvim_win_set_cursor(0, { row + count, col })
end

function Action.down.normal:move_line(line_number)
  local row, col = unpack(self.cursor)
  local line = vim.api.nvim_get_current_line()
  local line_count = api.nvim_buf_line_count(0)
  local count = line_number - row
  count = math.min(line_count - row, count)
  vim.api.nvim_buf_set_lines(0, row + count, row + count, false, { line })
  vim.api.nvim_buf_set_lines(0, row - 1, row, false, {})
  vim.api.nvim_win_set_cursor(0, { row + count, col })
end

--- @param dir "up" | "down"
function M.magic_move_line(dir)
  local wininfo = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
  local topline = wininfo.topline
  local botline = wininfo.botline
  local virt_col = -wininfo.textoff
  local startline, endline, callback = Action[dir]:main(topline, botline)

  Line_hl:init(startline, endline)
  local key = Key:init()
  key.compute(endline - startline + 1)
  for line = startline, endline do
    key.register({
      callback = function()
        callback(line)
      end,
      one_key = {
        line = line - 1,
        virt_col = virt_col,
      },
      two_key = {
        line = line - 1,
        virt_col = virt_col,
      },
    })
  end
  key.on_key({
    unmatched_callback = function()
      Line_hl:del_hl()
    end,
    matched_callback = function()
      Line_hl:del_hl()
    end,
  })
end

return M
