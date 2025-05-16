local M = {}

local jump_keys = "abcdefghijklmnopqrstuvwxyz"

local function get_jump_key(used_keys)
  if used_keys.count == 26 then
    return nil
  end

  local random = math.random(26)
  local key = jump_keys:sub(random, random)

  if used_keys[key] == nil then
    used_keys[key] = true
    used_keys.count = used_keys.count + 1
    return key
  else
    return get_jump_key(used_keys)
  end
end

local function set_extmark(LR, cursor, count)
  local ns_id = vim.api.nvim_create_namespace("custom-start-end-move-extmark")
  local col = 0

  if LR == "right" then
    local win = vim.api.nvim_get_current_win()
    local wininfo = vim.fn.getwininfo(win)[1]
    local viewport_width = wininfo.width - wininfo.textoff
    col = viewport_width - 1
  end
  vim.api.nvim_buf_set_extmark(0, ns_id, cursor[1] - count - 1, 0, {
    virt_text = { { "k", "HopNextKey" } },
    virt_text_win_col = col
  })
  vim.api.nvim_buf_set_extmark(0, ns_id, cursor[1] + count - 1, 0, {
    virt_text = { { "j", "HopNextKey" } },
    virt_text_win_col = col
  })

  return function()
    vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)
  end
end

--- @param LR "left"|"right"
function M.start_end_move(LR)
  local count = vim.v.count1

  if LR == "left" then
    if count == 1 then
      local cursor1 = vim.api.nvim_win_get_cursor(0)
      vim.api.nvim_feedkeys("^", "nx", false)
      local cursor2 = vim.api.nvim_win_get_cursor(0)
      if cursor1[2] == cursor2[2] then
        vim.api.nvim_feedkeys("0", "nx", false)
      end
    else
      local cursor = vim.api.nvim_win_get_cursor(0)
      local clear_namespace = set_extmark(LR, cursor, count)
      vim.schedule(function()
        local char = vim.fn.nr2char(vim.fn.getchar())
        if char == "j" then
          vim.api.nvim_feedkeys(count .. "+", "n", false)
        elseif char == "k" then
          vim.api.nvim_feedkeys(count .. "-", "n", false)
        end
        clear_namespace()
      end)
    end
  else
    if count == 1 then
      local cursor1 = vim.api.nvim_win_get_cursor(0)
      vim.api.nvim_feedkeys(count .. "g_", "nx", false)
      local cursor2 = vim.api.nvim_win_get_cursor(0)
      if cursor1[2] == cursor2[2] then
        vim.api.nvim_feedkeys("$", "nx", false)
      end
    else
      local cursor = vim.api.nvim_win_get_cursor(0)
      local clear_namespace = set_extmark(LR, cursor, count)
      vim.schedule(function()
        local char = vim.fn.nr2char(vim.fn.getchar())
        if char == "j" then
          vim.api.nvim_feedkeys(count + 1 .. "g_", "n", false)
        elseif char == "k" then
          local up = vim.api.nvim_replace_termcodes("<up>", true, true, true)
          vim.api.nvim_feedkeys(count .. up .. "g_", "n", false)
        end
        clear_namespace()
      end)
    end
  end
end

--- @param LR "left"|"right"
function M.start_end_move_general(LR)
  local ns_id = vim.api.nvim_create_namespace("test")
  local used_keys = { count = 0 }
  local wininfo = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
  local topline = wininfo.topline
  local botline = wininfo.botline

  local cursor = vim.api.nvim_win_get_cursor(0)
  local cursor_row = cursor[1]

  local line_count = botline - topline + 1

  local a = 0
  if line_count > 26 then
    a = math.ceil((line_count - 26) / 26)
  end
  local test = {}

  for i = 1, a do
    local key = get_jump_key(used_keys)
    table.insert(test, key)
  end
  print(vim.inspect(test))

  local count = 0
  while true do
    if cursor_row - count > topline - 1 then
      local key = get_jump_key(used_keys)
      if key == nil then break end
      vim.api.nvim_buf_set_extmark(0, ns_id, cursor_row - 1 - count, 0, {
        virt_text = { { key, "HopNextKey" } },
        virt_text_win_col = 0
      })
    else
      break
    end

    if cursor_row + count < botline then
      local key = get_jump_key(used_keys)
      if key == nil then break end
      vim.api.nvim_buf_set_extmark(0, ns_id, cursor_row + count, 0, {
        virt_text = { { key, "HopNextKey" } },
        virt_text_win_col = 0
      })
    else
      break
    end
    count = count + 1
  end



  vim.api.nvim_buf_set_extmark(0, ns_id, topline - 1, 0, {
    end_row = botline,
    hl_group = "HopUnmatched"
  })
end

return M



-- local ns_id = vim.api.nvim_create_namespace("test")
-- local used_keys = { count = 0 }
-- local wininfo = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
-- local topline = wininfo.topline
-- local botline = wininfo.botline
--
-- local cursor = vim.api.nvim_win_get_cursor(0)
-- local cursor_row = cursor[1]
--
-- local line_count = botline - topline + 1
--
-- if line_count > 26 then
--   local key_count = math.ceil((line_count - 26) / 26)
--   local w = cursor_row - 13 - topline
--   local e = botline - cursor_row - 12
--   if w > 0 and e <= 0 then
--     local left_line_count = botline - 26
--     print("上方剩余: ", left_line_count)
--     for i = botline - 26 + 1, botline do
--       vim.api.nvim_buf_set_extmark(0, ns_id, i - 1, 0, {
--         virt_text = { { get_jump_key(used_keys), "HopNextKey" } },
--         virt_text_win_col = 0
--       })
--     end
--   elseif w <= 0 and e > 0 then
--     local left_line_count = botline - 26
--     print("下方剩余： ", left_line_count)
--     for i = topline, topline + 26 - 1 do
--       vim.api.nvim_buf_set_extmark(0, ns_id, i - 1, 0, {
--         virt_text = { { get_jump_key(used_keys), "HopNextKey" } },
--         virt_text_win_col = 0
--       })
--     end
--   elseif w > 0 and e > 0 then
--     local left_line_count = botline - 26
--     print("上下均有剩余： ", left_line_count)
--   end
-- else
--   for i = topline, botline do
--     vim.api.nvim_buf_set_extmark(0, ns_id, i - 1, 0, {
--       virt_text = { { get_jump_key(used_keys), "HopNextKey" } },
--       virt_text_win_col = 0
--     })
--   end
-- end
--
-- --
-- -- -- if line_count > 26 then
-- -- local a = 0
-- -- local b = 0
-- -- local w = cursor_row - 13 - topline
-- -- local e = botline - cursor_row - 12
-- --
-- -- if w > 0 and e > 0 then
-- --   print("上方剩余，下方剩余")
-- --   for i = topline + w, topline + w + 26 - 1 do
-- --     vim.api.nvim_buf_set_extmark(0, ns_id, i - 1, 0, {
-- --       virt_text = { { get_jump_key(used_keys), "HopNextKey" } },
-- --       virt_text_win_col = 0
-- --     })
-- --   end
-- -- elseif w > 0 and e <= 0 then
-- --   print("上方剩余，下方不够")
-- --   for i = botline - 26 + 1, botline do
-- --     vim.api.nvim_buf_set_extmark(0, ns_id, i - 1, 0, {
-- --       virt_text = { { get_jump_key(used_keys), "HopNextKey" } },
-- --       virt_text_win_col = 0
-- --     })
-- --   end
-- -- elseif w <= 0 and e > 0 then
-- --   print("上方不够，下方剩余")
-- --   for i = topline, topline + 26 - 1 do
-- --     vim.api.nvim_buf_set_extmark(0, ns_id, i - 1, 0, {
-- --       virt_text = { { get_jump_key(used_keys), "HopNextKey" } },
-- --       virt_text_win_col = 0
-- --     })
-- --   end
-- -- elseif w <= 0 and e <= 0 then
-- --   print("上方不够，下方不够")
-- --   for i = topline, botline do
-- --     vim.api.nvim_buf_set_extmark(0, ns_id, i - 1, 0, {
-- --       virt_text = { { get_jump_key(used_keys), "HopNextKey" } },
-- --       virt_text_win_col = 0
-- --     })
-- --   end
-- -- end
