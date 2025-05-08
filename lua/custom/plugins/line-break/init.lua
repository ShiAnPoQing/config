local M = {}

local function _line_break(cursor_pos, virtcol)
  return function(type)
    if cursor_pos[2] == 0 then return end
    if type ~= "line" then return end
    local start_mark = vim.api.nvim_buf_get_mark(0, "[")
    local end_mark = vim.api.nvim_buf_get_mark(0, "]")
    local lines = vim.api.nvim_buf_get_lines(0, start_mark[1] - 1, end_mark[1], false)

    local line_break_display_width

    local function line_break(line, cursor)
      if cursor[2] >= #line then
        vim.api.nvim_feedkeys("j", "nx", false)
        return
      end

      local line_left = line:sub(1, cursor[2])
      local line_left_display_width = vim.fn.strdisplaywidth(line_left)
      local line_right = vim.fn.strcharpart(line, vim.fn.strcharlen(line_left))

      if line_break_display_width == nil then
        line_break_display_width = vim.fn.strdisplaywidth(line_left)
      end

      local move;
      if line_left_display_width < line_break_display_width then
        line_left = line_left .. vim.fn.strcharpart(line_right, 0, 1)
        line_right = vim.fn.strcharpart(line_right, 1)
        move = "right"
      elseif line_left_display_width > line_break_display_width then
        line_left = vim.fn.strcharpart(line_left, 0, vim.fn.strcharlen(line_left) - 1)
        line_right = vim.fn.strcharpart(line_left, vim.fn.strcharlen(line_left) - 1) .. line_right
        move = "left"
      end

      vim.api.nvim_buf_set_lines(0, cursor[1] - 1, cursor[1], false, { line_left, line_right })
      vim.api.nvim_win_set_cursor(0, cursor)

      if move == "right" then
        vim.api.nvim_feedkeys("l", "nx", false)
      elseif move == "left" then
        vim.api.nvim_feedkeys("h", "nx", false)
      end

      vim.api.nvim_feedkeys("j", "nx", false)

      line_break(line_right, vim.api.nvim_win_get_cursor(0))
    end

    for index, line in ipairs(lines) do
      if index > 1 then
        line_break(line, vim.api.nvim_win_get_cursor(0))
      else
        line_break(line, cursor_pos)
      end
    end
  end
end

function M.line_break(count)
  local mode = vim.api.nvim_get_mode().mode
  _G.custom_line_break = _line_break(vim.api.nvim_win_get_cursor(0), vim.fn.virtcol("."))
  vim.opt.operatorfunc = "v:lua.custom_line_break"
  vim.api.nvim_feedkeys("g@", "n", false)
end

return M
