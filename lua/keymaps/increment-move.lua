local function right_move()
  local line = vim.api.nvim_get_current_line()
  local pos = vim.api.nvim_win_get_cursor(0)
  local col = pos[2]
  local virtcol = vim.fn.virtcol(".")
  local line_displaywidth = vim.fn.strdisplaywidth(line)

  local line_to_end_without_space_count = #line:match('(.-)%s*$')
  local start_space_count = #line:match("^%s*")

  local win = vim.api.nvim_get_current_win()
  local win_info = vim.fn.getwininfo(win)[1]
  local leftcol = win_info.leftcol
  local screen_width = win_info.width - win_info.textoff
  local rightcol = line_displaywidth - leftcol - screen_width

  if col < start_space_count then
    vim.api.nvim_feedkeys("^", "n", true)
    return
  end


  if rightcol > 0 then
    local before_pos = vim.api.nvim_win_get_cursor(0)
    vim.api.nvim_feedkeys("g$", "n", true)
    vim.schedule(function()
      local after_pos = vim.api.nvim_win_get_cursor(0)
      if after_pos[2] == before_pos[2] then
        vim.api.nvim_feedkeys("zs", "n", true)
      end
    end)
    return
  end

  if col + 1 >= start_space_count and col + 1 < line_to_end_without_space_count then
    vim.api.nvim_feedkeys("g_", "n", true)
    return
  end


  if col + 1 >= line_to_end_without_space_count and col + 1 < #line then
    vim.api.nvim_feedkeys("$", "n", true)
    return
  end

  if col + 1 == #line or virtcol > line_displaywidth then
    vim.api.nvim_feedkeys("g$", "n", true)
    return
  end
end
local MoveAction = {
  ["left"] = {
    move = function()
      local line = vim.api.nvim_get_current_line()
      local pos = vim.api.nvim_win_get_cursor(0)
      local col = pos[2]
      local virtcol = vim.fn.virtcol(".")
      local line_displaywidth = vim.fn.strdisplaywidth(line)

      local line_to_end_without_space_count = #line:match('(.-)%s*$')
      local start_space_count = #line:match("^%s*")

      if virtcol > line_displaywidth then
        vim.api.nvim_feedkeys("$", "n", true)
        return
      end

      if col + 1 > line_to_end_without_space_count and col + 1 <= #line then
        vim.api.nvim_feedkeys("g_", "n", true)
        return
      end

      if col <= start_space_count then
        vim.api.nvim_feedkeys("0", "n", true)
        return
      end


      local win = vim.api.nvim_get_current_win()
      local win_info = vim.fn.getwininfo(win)[1]
      local leftcol = win_info.leftcol

      if leftcol > 0 then
        local before_pos = vim.api.nvim_win_get_cursor(0)
        vim.api.nvim_feedkeys("g0", "n", true)
        vim.schedule(function()
          local after_pos = vim.api.nvim_win_get_cursor(0)
          if before_pos[2] == after_pos[2] then
            vim.api.nvim_feedkeys("ze", "n", true)
          end
        end)
        return
      end

      if col + 1 > start_space_count and col + 1 <= line_to_end_without_space_count then
        vim.api.nvim_feedkeys("^", "n", true)
        return
      end
    end
  },
  ["right"] = {
    move = right_move
  }
}
--- @param action "left"|"right"
local function increment_move(action)
  MoveAction[action].move()
end

return {
  ["sl"] = {
    function()
      increment_move("right")
      require("repeat").Record(function()
        increment_move("right")
      end)
    end,
    "n"
  },
  ["sh"] = {
    function()
      increment_move("left")
      require("repeat").Record(function()
        increment_move("left")
      end)
    end,
    "n"
  }
}

-- local line = vim.api.nvim_get_current_line()
-- local pos = vim.api.nvim_win_get_cursor(0)
-- local col = pos[2]
--
-- if s_l_state == nil then
--   pcall(vim.api.nvim_del_autocmd, cursor_moved_id)
--   vim.api.nvim_feedkeys("g_", "n", true)
--   vim.schedule(function()
--     cursor_moved_id = vim.api.nvim_create_autocmd("CursorMoved", {
--       callback = function(ev)
--         print("1 CursorMoved")
--         s_l_state = nil
--         vim.api.nvim_del_autocmd(ev.id)
--       end
--     })
--   end)
--   s_l_state = 1
--   return
-- end
--
-- if s_l_state == 1 then
--   print('2')
--   vim.api.nvim_del_autocmd(cursor_moved_id)
--   cursor_moved_id = nil
--   vim.api.nvim_feedkeys("$", "n", true)
--   vim.schedule(function()
--     cursor_moved_id = vim.api.nvim_create_autocmd("CursorMoved", {
--       callback = function(ev)
--         s_l_state = nil
--         vim.api.nvim_del_autocmd(ev.id)
--       end
--     })
--   end)
--   s_l_state = 2
--   return
-- end
--
-- if s_l_state == 2 then
--   print('3')
--   vim.api.nvim_del_autocmd(cursor_moved_id)
--   cursor_moved_id = nil
--   vim.api.nvim_feedkeys("g$", "n", true)
--   vim.schedule(function()
--     cursor_moved_id = vim.api.nvim_create_autocmd("CursorMoved", {
--       callback = function(ev)
--         s_l_state = nil
--         vim.api.nvim_del_autocmd(ev.id)
--       end
--     })
--   end)
--   s_l_state = nil
--   return
-- end

-- move = function()
--   local line = vim.api.nvim_get_current_line()
--   local pos = vim.api.nvim_win_get_cursor(0)
--   local col = pos[2]
--   local virtcol = vim.fn.virtcol(".")
--   local line_displaywidth = vim.fn.strdisplaywidth(line)
--
--   local line_to_end_without_space_count = #line:match('(.-)%s*$')
--   local start_space_count = #line:match("^%s*")
--
--   local win = vim.api.nvim_get_current_win()
--   local win_info = vim.fn.getwininfo(win)[1]
--   local textoff = win_info.textoff
--   local screen_displaywidth = win_info.width - win_info.textoff
--   local screen_cursor_displaywidth = vim.fn.screencol() - textoff
--   local cursor_to_screen_displaywidth = screen_displaywidth - screen_cursor_displaywidth
--   local line_start_to_screen_right_displaywidth = virtcol + cursor_to_screen_displaywidth
--
--   if virtcol < line_start_to_screen_right_displaywidth and line_start_to_screen_right_displaywidth < line_displaywidth then
--     vim.api.nvim_feedkeys("g$", "n", true)
--     return
--   end
--
--   if col < start_space_count then
--     vim.api.nvim_feedkeys("^", "n", true)
--     return
--   end
--
--   if col + 1 >= start_space_count and col + 1 < line_to_end_without_space_count then
--     vim.api.nvim_feedkeys("g_", "n", true)
--     return
--   end
--
--   if col + 1 >= line_to_end_without_space_count and col + 1 < #line then
--     vim.api.nvim_feedkeys("$", "n", true)
--     return
--   end
--
--   if col + 1 == #line or virtcol > line_displaywidth then
--     vim.api.nvim_feedkeys("g$", "n", true)
--     return
--   end
-- end
