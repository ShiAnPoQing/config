--- @class my.profile.pro.motion.NORMAL
local M = {}

function M.last_non_blank()
  --- multicursor and follow mode
  if my.multicursor.active() and vim.bo.follow then
    vim.bo.follow = false
    local extmarks = my.multicursor.get(0, 0, -1)
    table.insert(extmarks, 1, { 0, vim.fn.line(".") - 1, vim.fn.col(".") - 1 })
    local should_fallback = true
    local new_cursor_cols = {}
    local fallback_cols = {}
    for _, extmark in ipairs(extmarks) do
      local line = vim.api.nvim_buf_get_lines(0, extmark[2], extmark[2] + 1, false)[1]
      local s = line:reverse():find("%S") or 0
      local col = #line - s
      if extmark[3] + 1 ~= #line:sub(1, col + 1) then
        should_fallback = false
      end
      new_cursor_cols[tostring(extmark[1])] = col
      fallback_cols[tostring(extmark[1])] = #line - 1
    end
    -- Update multicursors
    my.multicursor.transform(0, function(id, extmark)
      return { extmark[1], should_fallback and fallback_cols[tostring(id)] or new_cursor_cols[tostring(id)] }
    end)
    vim.api.nvim_win_set_cursor(
      0,
      { extmarks[1][2] + 1, should_fallback and fallback_cols[tostring(0)] or new_cursor_cols[tostring(0)] }
    )
    vim.bo.follow = true
  else
    local line = vim.api.nvim_get_current_line()
    local s = line:reverse():find("%S") or 0
    local col = #line - s
    vim.api.nvim_win_set_cursor(0, { vim.fn.line("."), col })
  end
end

function M._first_non_blank(offset_col)
  offset_col = offset_col or 0
  -- Update multicursors
  vim.bo.follow = false
  local extmarks = my.multicursor.get(0, 0, -1)
  table.insert(extmarks, 1, { 0, vim.fn.line(".") - 1, vim.fn.col(".") - 1 })
  local new_cursor_cols = {}
  local should_fallback = true
  -- Compute the new cursor positions
  for _, extmark in ipairs(extmarks) do
    local line = vim.api.nvim_buf_get_lines(0, extmark[2], extmark[2] + 1, false)[1]
    local col = line:find("%S") or 1
    col = col - 1
    if col ~= extmark[3] - offset_col then
      should_fallback = false
    end
    new_cursor_cols[tostring(extmark[1])] = col
  end

  -- Update multicursors
  my.multicursor.transform(0, function(id, extmark)
    return { extmark[1], should_fallback and 0 or new_cursor_cols[tostring(id)] }
  end)
  vim.api.nvim_win_set_cursor(0, { extmarks[1][2] + 1, should_fallback and 0 or new_cursor_cols[tostring(0)] })
  vim.bo.follow = true
end

-- move to the first non-blank character of the line
-- otherwise move to the first character of the line
function M.first_non_blank()
  if my.multicursor.active() and vim.bo.follow then
    M._first_non_blank(0)
  else
    local col1 = vim.fn.col(".")
    vim.cmd("normal! ^")
    local col2 = vim.fn.col(".")
    if col1 == col2 then
      vim.cmd("normal! 0")
    end
  end
end

function M.last()
  vim.cmd("normal! $")
end

function M.first()
  vim.cmd("normal! 0")
end

function M.backward_word_end()
  vim.cmd("normal! " .. vim.v.count1 .. "ge")
end

function M.forward_word_end()
  vim.cmd("normal! " .. vim.v.count1 .. "e")
end

function M.backward_word_start()
  vim.cmd("normal! " .. vim.v.count1 .. "b")
end

function M.forward_word_start()
  vim.cmd("normal! " .. vim.v.count1 .. "w")
end

function M.backward_WORD_end()
  vim.cmd("normal! " .. vim.v.count1 .. "gE")
end

function M.forward_WORD_end()
  vim.cmd("normal! " .. vim.v.count1 .. "E")
end

function M.backward_WORD_start()
  vim.cmd("normal! " .. vim.v.count1 .. "B")
end

function M.forward_WORD_start()
  vim.cmd("normal! " .. vim.v.count1 .. "W")
end

return M
