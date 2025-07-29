local M = {}

local function get_blank_lines(count)
  local blank_lines = {}
  for i = 1, count do
    table.insert(blank_lines, "")
  end
  return blank_lines
end

local PosAction = {
  up = {
    set_lines = function(count, row)
      vim.api.nvim_buf_set_lines(0, row - 1, row - 1, false, get_blank_lines(count))
    end,
    set_cursor = function(row, col, count, disable_cursor_follow)
      if not disable_cursor_follow then
        vim.api.nvim_win_set_cursor(0, { row, col })
      end
    end,
  },
  down = {
    set_lines = function(count, row)
      vim.api.nvim_buf_set_lines(0, row, row, false, get_blank_lines(count))
    end,
    set_cursor = function(row, col, count, disable_cursor_follow)
      if not disable_cursor_follow then
        vim.api.nvim_win_set_cursor(0, { row + count, col })
      end
    end,
  },
}
PosAction.all = {
  set_lines = function(count, row)
    PosAction.down.set_lines(count, row)
    PosAction.up.set_lines(count, row)
  end,
  set_cursor = function() end,
}

local ModeAction = {
  ["n"] = {
    get_indent = function() end,
  },
  ["i"] = {
    get_indent = function()
      local line = vim.api.nvim_get_current_line()
      -- local indent = line:gsub()
    end,
  },
}

--- @class Options
--- @field count number|nil
--- @field disable_cursor_follow boolean|nil

--- @param dir "up"|"down"|"all"
--- @param opt Options
function M.add_new_line(dir, opt)
  local mode = vim.api.nvim_get_mode().mode
  local ModeAC = ModeAction[mode]
  local PosAC = PosAction[dir]
  local count = opt.count and opt.count or vim.v.count1
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  PosAC.set_lines(count, row)
  PosAC.set_cursor(row, col, count, opt.disable_cursor_follow and true or false)
end

return M
