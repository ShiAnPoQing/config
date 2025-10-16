local M = {}
local api = vim.api

local Direction = {}
local Horizontal = setmetatable({}, { __index = Direction })
local Vertical = setmetatable({}, { __index = Direction })
local Select = setmetatable({}, { __index = Direction })
local Visual = setmetatable({}, { __index = Direction })
Direction.Horizontal = Horizontal
Direction.Vertical = Vertical
Direction.Select = Select
Direction.Visual = Visual
Horizontal.left = setmetatable({}, { __index = Horizontal })
Horizontal.right = setmetatable({}, { __index = Horizontal })
Vertical.up = setmetatable({}, { __index = Vertical })
Vertical.down = setmetatable({}, { __index = Vertical })

local function get_mode()
  local mode = api.nvim_get_mode().mode
  if mode == "" or mode == "s" then
    return Direction.Select
  end
  if mode == "v" or mode == "" then
    return Direction.Visual
  end
end

local function get_dir(dir)
  if dir == "left" or dir == "right" then
    return Direction.Horizontal
  elseif dir == "up" or dir == "down" then
    return Direction.Vertical
  end
end

local function set_visual_mark(start_row, start_col, end_row, end_col)
  api.nvim_buf_set_mark(0, "<", start_row, start_col, {})
  api.nvim_buf_set_mark(0, ">", end_row, end_col, {})
end

local function get_new_lines(lines_data)
  local new_lines = {}
  for _, data in ipairs(lines_data) do
    table.insert(new_lines, data.line_to_start .. data.text .. data.line_to_end)
  end
  return new_lines
end

local function create_lines_data(lines, texts, start_col)
  local lines_data = {}
  local first_line = lines[1]
  local last_line = lines[#lines]
  for index, v in ipairs(texts) do
    local data = {
      text = v,
      line_to_start = "",
      line_to_end = "",
    }
    if index == 1 then
      data.line_to_start = first_line:sub(1, start_col)
    end
    if index == #texts then
      data.line_to_end = last_line:sub(#data.line_to_start + vim.fn.strlen(data.text) + 1)
    end
    table.insert(lines_data, data)
  end
  return lines_data
end

function Direction:init(dir)
  self.count = vim.v.count1
  self.current_mode = get_mode()
  self.current_dir = get_dir(dir)
  if not self.current_mode or not self.current_dir then
    return
  end
  self.cursor = api.nvim_win_get_cursor(0)
  self.current_mode.prepare()
  self.start_row, self.start_col = unpack(api.nvim_buf_get_mark(0, "<"))
  self.end_row, self.end_col = unpack(api.nvim_buf_get_mark(0, ">"))
  self.text = vim.fn.getreg('"')
end

function Direction:move(dir)
  self:init(dir)
  self.current_dir:main(dir)
  self.current_mode:reselect()
end

function Select.prepare()
  vim.api.nvim_exec2([[execute "normal! \<C-g>y"]], {})
end

function Select:reselect()
  local cursor_col = self.cursor[2]
  local cursor_row = self.cursor[1]

  local key = ""
  if cursor_row == self.start_row and cursor_col == self.start_col then
    key = "o"
  end
  api.nvim_feedkeys("gv" .. key .. api.nvim_replace_termcodes("<c-g>", true, true, true), "n", false)
end

function Visual:prepare()
  vim.cmd("normal! y")
end

function Visual:reselect()
  local cursor_col = self.cursor[2]
  local cursor_row = self.cursor[1]

  local key = ""
  if cursor_row == self.start_row and cursor_col == self.start_col then
    key = "o"
  end
  api.nvim_feedkeys("gv" .. key, "n", false)
end

function Horizontal:main(dir)
  local start_row = self.start_row
  local start_col = self.start_col
  local end_row = self.end_row

  local lines_data = create_lines_data(
    api.nvim_buf_get_lines(0, start_row - 1, end_row, false),
    vim.fn.split(self.text, "\n"),
    start_col
  )
  local col_offset = self[dir]:process_lines(lines_data)
  local visual_cols = self:get_visual_cols(col_offset)
  api.nvim_buf_set_lines(0, start_row - 1, end_row, false, get_new_lines(lines_data))
  set_visual_mark(start_row, visual_cols.start_col, end_row, visual_cols.end_col)
end

function Horizontal.left:process_lines(lines_data)
  local first = lines_data[1]
  local last = lines_data[#lines_data]
  local line_to_start_reverse = vim.fn.reverse(first.line_to_start)
  local chars = vim.fn.reverse(vim.fn.strcharpart(line_to_start_reverse, 0, self.count))
  first.line_to_start = vim.fn.reverse(vim.fn.strcharpart(line_to_start_reverse, self.count))
  last.line_to_end = chars .. last.line_to_end
  return -#chars
end

function Horizontal.right:process_lines(lines_data)
  local first = lines_data[1]
  local last = lines_data[#lines_data]
  local chars = vim.fn.strcharpart(last.line_to_end, 0, self.count)
  first.line_to_start = first.line_to_start .. chars
  last.line_to_end = vim.fn.strcharpart(last.line_to_end, self.count)
  return #chars
end

function Horizontal:get_visual_cols(offset)
  if self.start_row == self.end_row then
    return {
      start_col = self.start_col + offset,
      end_col = self.end_col + offset,
    }
  end
  return {
    start_col = self.start_col + offset,
    end_col = self.end_col,
  }
end

function Horizontal.left:get_target_count()
  return -self.count
end

function Horizontal.right:get_target_count()
  return self.count
end

function Vertical:main(dir)
  self.Dir = self[dir]
  if self.end_row == self.start_row then
    self:one_line_move()
  else
    self:more_line_move()
  end
end

function Vertical:one_line_move()
  local Dir = self.Dir
  local text = self.text
  local end_row = self.end_row
  local start_col = self.start_col
  local start_row = self.start_row
  local count = Dir:get_target_count()

  if count == nil then
    return
  end

  local current_line = api.nvim_buf_get_lines(0, start_row - 1, end_row, false)[1]
  local target_line = api.nvim_buf_get_lines(0, start_row - 1 + count, end_row + count, false)[1]

  local line_to_start = current_line:sub(1, start_col)
  local line_to_end = current_line:sub(#line_to_start + vim.fn.strlen(text) + 1)
  local new_line = (line_to_start .. line_to_end):gsub("%s+$", "")

  if #target_line < start_col then
    local blank = " "
    target_line = target_line .. blank:rep(start_col - #target_line + 1)
  end

  api.nvim_buf_set_lines(0, start_row - 1 + count, start_row + count, false, { target_line })
  Dir:cursor_to_target_line()

  local _, target_start_col = unpack(api.nvim_win_get_cursor(0))
  local target_line_start = target_line:sub(1, target_start_col)
  local target_line_end = target_line:sub(target_start_col + 1)
  local new_target_line = target_line_start .. text .. target_line_end

  api.nvim_buf_set_lines(0, start_row - 1, end_row, false, { new_line })
  api.nvim_buf_set_lines(0, start_row - 1 + count, end_row + count, false, { new_target_line })
  set_visual_mark(start_row + count, #target_line_start, end_row + count, #target_line_start + #text - 1)
end

function Vertical:more_line_move()
  local start_row = self.start_row
  local start_col = self.start_col
  local end_row = self.end_row
  local end_col = self.end_col
  local text = self.text
  local Dir = self.Dir
end

function Vertical.up:get_target_count()
  if self.start_row == 1 then
    return nil
  end

  if self.start_row - self.count < 0 then
    return -self.start_row + 1
  end

  return -self.count
end

function Vertical.up:cursor_to_target_line()
  vim.cmd("normal! " .. self.count .. "k")
end

function Vertical.down:get_target_count()
  local line_count = api.nvim_buf_line_count(0)

  if self.start_row == line_count then
    return nil
  end

  if self.start_row + self.count > line_count then
    return line_count - self.start_row
  end

  return self.count
end

function Vertical.down:cursor_to_target_line()
  vim.cmd("normal! " .. self.count .. "j")
end

--- @param dir "left"| "right" | "up" | "down"
function M.visual_mode_move(dir)
  Direction:move(dir)
end

return M
