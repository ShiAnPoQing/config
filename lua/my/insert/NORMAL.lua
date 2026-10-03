--- @class my.insert.NORMAL
local M = {}

local function is_blank_line()
  local line = vim.api.nvim_get_current_line()
  return line:find("^%s*$") and true or nil
end

-- :h 0
function M.first()
  if is_blank_line() and not my.multicursor.active() then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(vim.v.count1 .. "A<C-f>", true, false, true), "n", false)
  else
    vim.api.nvim_feedkeys("0" .. vim.v.count1 .. "i", "n", false)
    -- Fallback:
    --[[
       -- First Atom: <Cmd>lua my.insert.NORMAL._reset_multicursor_to_line_first_character()<CR>
       vim.api.nvim_feedkeys(
         vim.keycode("<Cmd>lua my.insert.NORMAL._reset_multicursor_to_line_first_character()<CR>"),
         "nt",
         false
       )
       -- Second Atom: insert session
       vim.api.nvim_feedkeys(vim.v.count1 .. "i", "n", false)
    --]]
  end
end

function M._reset_multicursor_to_line_first_character()
  my.multicursor.transform(0, function(_, extmark)
    return { extmark[1], 0 }
  end)
  vim.api.nvim_win_set_cursor(0, { vim.fn.line("."), 0 })
end

function M._reset_multicursor_to_line_last_character()
  my.multicursor.transform(0, function(_, extmark)
    return { extmark[1], #vim.api.nvim_buf_get_lines(0, extmark[1], extmark[1] + 1, true)[1] }
  end)
  vim.api.nvim_win_set_cursor(0, { vim.fn.line("."), #vim.api.nvim_get_current_line() })
end

--- `my.insert.NORMAL.last()` is a function that provides atoms.
--- You cannot map `<Cmd>lua my.insert.NORMAL.last()<CR>`
--- You can map:
---  function()
---     my.insert.NORMAL.last()
---  end
function M.last()
  if is_blank_line() and not my.multicursor.active() then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(vim.v.count1 .. "A<C-f>", true, false, true), "n", false)
    return
  end
  vim.api.nvim_feedkeys("$" .. vim.v.count1 .. "a", "n", false)
  -- Fallback:
  --[[
  -- First Atom: <Cmd>lua my.insert.NORMAL._reset_multicursor_to_line_last_character()<CR>
  --             Why not use `multicursor follow to move`?
  --             Because when primary cursor is at a blank line, multicursor will not follow it.
  --             So I use `reset multicursor`.
  vim.api.nvim_feedkeys(
    vim.keycode("<Cmd>lua my.insert.NORMAL._reset_multicursor_to_line_last_character()<CR>"),
    "nt",
    false
  )
  -- Second Atom: insert session
  vim.api.nvim_feedkeys(vim.v.count1 .. "a", "n", false)
  --]]
end

function M.first_non_blank()
  if is_blank_line() and not my.multicursor.active() then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(vim.v.count1 .. "I<C-f>", true, false, true), "n", false)
  else
    vim.api.nvim_feedkeys(vim.v.count1 .. "I", "n", false)
  end
end

-- :h g_
function M.last_non_blank()
  if is_blank_line() and not my.multicursor.active() then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(vim.v.count1 .. "A<C-f>", true, false, true), "n", false)
  else
    vim.api.nvim_feedkeys("g_" .. vim.v.count1 .. "a", "n", false)
  end
end

return M
