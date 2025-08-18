local M = {}

local function get_mode()
  local mode = vim.api.nvim_get_mode().mode
  if mode == "s" then
    return "Select"
  end
  if mode == "" then
    return "Select"
  end
  if mode == "v" then
    return "Visual"
  end
  if mode == "" then
    return "Visual"
  end
end

local function get_dir(dir)
  if dir == "left" or dir == "right" then
    return "Horizontal"
  elseif dir == "up" or dir == "down" then
    return "Vertical"
  end
end

local Direction = {}
local Horizontal = setmetatable({}, { __index = Direction })
local Vertical = setmetatable({}, { __index = Direction })
local Select = setmetatable({}, { __index = Direction })
local Visual = setmetatable({}, { __index = Direction })
Direction.Horizontal = Horizontal
Direction.Vertical = Vertical
Direction.Select = Select
Direction.Visual = Visual

Horizontal.left = setmetatable({
  get_new_line = function(line_to_start, line_to_end, text)
    local line_to_start_reverse = vim.fn.reverse(line_to_start)
    local line_to_start_part2 = vim.fn.strcharpart(line_to_start_reverse, 0, 1)
    local line_to_start_part1 = vim.fn.reverse(vim.fn.strcharpart(line_to_start_reverse, 1))
    local new_line = line_to_start_part1 .. text .. line_to_start_part2 .. line_to_end
    local col_offset = -#line_to_start_part2
    return new_line, col_offset
  end,
}, { __index = Horizontal })
Horizontal.right = setmetatable({
  get_new_line = function(line_to_start, line_to_end, text)
    local line_to_end_part1 = vim.fn.strcharpart(line_to_end, 0, 1)
    local line_to_end_part2 = vim.fn.strcharpart(line_to_end, 1)
    local new_line = line_to_start .. line_to_end_part1 .. text .. line_to_end_part2
    local col_offset = #line_to_end_part1
    return new_line, col_offset
  end,
}, { __index = Horizontal })
Vertical.up = setmetatable({}, { __index = Vertical })
Vertical.down = setmetatable({}, { __index = Vertical })

function Direction:init(dir)
  self.current_mode = self[get_mode()]
  self.current_dir = self[get_dir(dir)]
  if not self.current_mode or not self.current_dir then
    return
  end
  self.cursor = vim.api.nvim_win_get_cursor(0)
  self.current_mode.prepare()
  self.start_row, self.start_col = unpack(vim.api.nvim_buf_get_mark(0, "<"))
  self.end_row, self.end_col = unpack(vim.api.nvim_buf_get_mark(0, ">"))
  self.text = vim.fn.getreg('"')
end

function Direction:move(dir)
  self:init(dir)
  self.current_dir:main(dir)
  self.current_mode:reselect()
end

function Select.prepare()
  vim.cmd("normal \\<C-g>y")
end

function Select:reselect()
  local key = self.cursor[2] == self.start_col and "o" or ""
  vim.api.nvim_feedkeys("gv" .. key .. vim.api.nvim_replace_termcodes("<c-g>", true, true, true), "n", false)
end

function Visual:prepare()
  vim.cmd("normal y")
end

function Visual:reselect()
  local key = self.cursor[2] == self.start_col and "o" or ""
  vim.api.nvim_feedkeys("gv" .. key, "n", false)
end

function Horizontal:main(dir)
  self.Dir = self[dir]
  if self.end_row == self.start_row then
    self:one_line_move()
  else
    self:more_line_move()
  end
end

function Horizontal:one_line_move()
  local start_row = self.start_row
  local start_col = self.start_col
  local end_row = self.end_row
  local end_col = self.end_col
  local text = self.text
  local Dir = self.Dir

  local line = vim.api.nvim_buf_get_lines(0, start_row - 1, end_row, false)[1]
  local line_to_start = line:sub(1, start_col)
  local line_to_end = line:sub(#line_to_start + vim.fn.strlen(text) + 1)
  local new_line, col_offset = Dir.get_new_line(line_to_start, line_to_end, text)
  vim.api.nvim_buf_set_lines(0, start_row - 1, end_row, false, { new_line })
  vim.api.nvim_buf_set_mark(0, "<", start_row, start_col + col_offset, {})
  vim.api.nvim_buf_set_mark(0, ">", end_row, end_col + col_offset, {})
end

function Horizontal:more_line_move()
  local start_row = self.start_row
  local start_col = self.start_col
  local end_row = self.end_row
  local end_col = self.end_col
  local text = self.text
  local Dir = self.Dir

  local lines = vim.api.nvim_buf_get_lines(0, start_row - 1, end_row, false)
  local texts = vim.fn.split(text, "\n")
  local last_text = texts[#texts]
  local line_to_start = lines[1]:sub(1, start_col)
  local line_to_end = lines[#lines]:sub(vim.fn.strlen(last_text) + 1)
  local new_line, col_offset = Dir.get_new_line(line_to_start, line_to_end, text)
  vim.api.nvim_buf_set_lines(0, start_row - 1, end_row, false, vim.fn.split(new_line, "\n"))
  vim.api.nvim_buf_set_mark(0, "<", start_row, start_col + col_offset, {})
  vim.api.nvim_buf_set_mark(0, ">", end_row, end_col, {})
end

function Vertical:main(dir)
  self.Dir = self[dir]
  if self.end_row == self.start_row then
    self:one_line_move()
  else
    self:more_line_move()
  end
end

function Vertical:one_line_move() end

function Vertical:more_line_move() end

--- @param dir "left"| "right" | "up" | "down"
function M.visual_mode_move(dir)
  Direction:move(dir)
end

return M
