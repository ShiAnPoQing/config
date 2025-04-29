local M = {}

local WordMoveAction = {
  ["left"] = {
    is_outer_boundary = function(line_to_start, line_to_end)
      if line_to_start:match("^%s*$") then
        vim.api.nvim_exec2([[execute "normal! Pgv\<C-G>"]], {})
        return true
      end
      return false
    end,
    get_new_line = function(line_to_start, line_to_end, select)
      local mark_offset
      local new_line_to_start = line_to_start:gsub("(%S+)(%s*)$", function(match, space)
        mark_offset = - #space - #match
        return select .. space .. match
      end)
      local line = new_line_to_start .. line_to_end
      return line, mark_offset
    end
  },
  ["right"] = {
    is_outer_boundary = function(line_to_start, line_to_end)
      if line_to_end:match("^%s*$") then
        vim.api.nvim_exec2([[execute "normal! Pgv\<C-G>"]], {})
        return true
      end
      return false
    end,
    get_new_line = function(line_to_start, line_to_end, select)
      local mark_offset
      local new_line_to_end = line_to_end:gsub("^(%s*)(%S+)", function(space, match)
        mark_offset = #space + #match
        return match .. space .. select
      end)
      local line = line_to_start .. new_line_to_end
      return line, mark_offset
    end
  }
}

local function select_mode_move(dir)
  local Action = WordMoveAction[dir]

  vim.api.nvim_exec2([[execute "normal! \<C-G>d"]], {})
  local select = vim.fn.getreg('"')
  local start_row, start_col = unpack(vim.api.nvim_buf_get_mark(0, "<"))

  local line = vim.api.nvim_get_current_line()
  local line_to_start = line:sub(1, start_col)
  local line_to_end = line:sub(start_col + 1)

  if Action.is_outer_boundary(line_to_start, line_to_end) then
    return
  end

  local new_line, mark_offset = Action.get_new_line(line_to_start, line_to_end, select)

  vim.api.nvim_buf_set_lines(0, start_row - 1, start_row, false, { new_line })
  vim.api.nvim_buf_set_mark(0, "<", start_row, start_col + mark_offset, {})
  vim.api.nvim_buf_set_mark(0, ">", start_row, start_col + mark_offset + #select - 1, {})

  vim.api.nvim_exec2([[execute "normal! gv\<C-G>"]], {})
end

local function select_block_mode_move(dir)

end

--- @param dir "left"| "right"
function M.select_word_move(dir)
  local mode = vim.api.nvim_get_mode().mode

  if mode == "s" then
    select_mode_move(dir)
  elseif mode == "" then
    select_block_mode_move(dir)
  end
end

return M
