local M = {}

local snippets = {
  ["name"] = {
    text = {
      "nihao",
      "jiayou",
    },
    jump = {
      pos1 = { 1, 3 },
      pos2 = { 1, 4 },
    },
  },
}

function M.expand()
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local key =
      vim.api.nvim_buf_get_text(0, cursor_pos[1] - 1, 0, cursor_pos[1] - 1, cursor_pos[2], {})[1]:match("%w+$")

  if snippets[key] ~= nil then
    local data = snippets[key]
    vim.api.nvim_buf_set_text(
      0,
      cursor_pos[1] - 1,
      cursor_pos[2] - #key,
      cursor_pos[1] - 1,
      cursor_pos[2],
      data.text
    )
  end
end

function M.OmodeWordLeftMove(count)
  local key = "v" .. count .. "b"
  vim.api.nvim_feedkeys(key, "nx", true)
end

function M.EnterInertMode(mode, left_right)
  if mode == "n" then
    local not_empty = string.find(vim.api.nvim_get_current_line(), "%S")
    if left_right == "left" then
      if not_empty then
        vim.api.nvim_feedkeys("I", "nx!", true)
      else
        local escapekey = vim.api.nvim_replace_termcodes("<C-F>", true, true, true)
        vim.api.nvim_feedkeys("I" .. escapekey, "nx!", true)
      end
    else
      if not_empty then
        vim.api.nvim_feedkeys("A", "nx!", true)
      else
        local escapekey = vim.api.nvim_replace_termcodes("<C-F>", true, true, true)
        vim.api.nvim_feedkeys("A" .. escapekey, "nx!", true)
      end
    end
  elseif mode == "v" then
    local modeinfo = vim.api.nvim_get_mode()
    local mode = modeinfo["mode"]
    if mode == "" then
      if left_right == "left" then
        vim.api.nvim_feedkeys("I", "nx!", true)
      else
        vim.api.nvim_feedkeys("A", "nx!", true)
      end
    elseif mode ~= "" then
      local escapekey = vim.api.nvim_replace_termcodes("<C-v>", true, true, true)
      if left_right == "left" then
        vim.api.nvim_feedkeys(escapekey .. "I", "nx!", true)
      else
        vim.api.nvim_feedkeys(escapekey .. "A", "nx!", true)
      end
    end
  elseif mode == "s" then
    local escapekey = vim.api.nvim_replace_termcodes("<C-g><C-v>", true, true, true)
    if left_right == "left" then
      vim.api.nvim_feedkeys(escapekey .. "I", "nx!", true)
    else
      vim.api.nvim_feedkeys(escapekey .. "A", "nx!", true)
    end
  end
end

function M.FilpLeftAndRight(LR, count)
  local col_1 = vim.api.nvim_win_get_cursor(0)[2]

  if LR == "right" then
    vim.cmd([[
    norm! g0
    ]])

    local col_2 = vim.api.nvim_win_get_cursor(0)[2]
    local move = col_1 - col_2

    vim.cmd("norm! " .. count .. "zLg0")

    if move ~= 0 then
      vim.api.nvim_exec("norm! " .. move .. "l", false)
    end
  elseif LR == "left" then
    vim.cmd([[
    norm! g0
    ]])

    local col_2 = vim.api.nvim_win_get_cursor(0)[2]
    local move = col_1 - col_2

    vim.cmd("norm! " .. count .. "zHg0")

    if move ~= 0 then
      vim.api.nvim_exec("norm! " .. move .. "l", false)
    end
  end
end

function M.JumpToMiddle(count, left_right_up_down)
  local i = count
  while true do
    if left_right_up_down == "left" then
      local pos = vim.api.nvim_win_get_cursor(0)
      local col = pos[2]

      if col == 1 then
        break
      end

      local get_col = math.ceil(col / 2)
      vim.api.nvim_win_set_cursor(0, { pos[1], get_col })
    elseif left_right_up_down == "right" then
      local pos = vim.api.nvim_win_get_cursor(0)
      vim.cmd([[norm! $]])
      local current_line_end_pos = vim.api.nvim_win_get_cursor(0)

      if pos[2] == current_line_end_pos[2] then
        break
      end

      local result = (current_line_end_pos[2] - pos[2]) / 2 + pos[2]
      local get_col = math.ceil(result)
      vim.api.nvim_win_set_cursor(0, { pos[1], get_col })
    elseif left_right_up_down == "up" then
      local scrolloff = vim.opt.scrolloff:get()
      local pos = vim.api.nvim_win_get_cursor(0)
      vim.cmd([[norm! H]])
      local scroll_first_pos = vim.api.nvim_win_get_cursor(0)

      if pos[2] == scroll_first_pos[2] then
        break
      end

      local row_count
      local get_row
      if scroll_first_pos[1] == 1 then
        row_count = pos[1] - scroll_first_pos[1] + 1
        get_row = math.ceil(row_count / 2) + scroll_first_pos[1] - 1
      else
        row_count = pos[1] - scroll_first_pos[1] + scrolloff + 1
        get_row = math.ceil(row_count / 2) + scroll_first_pos[1] - scrolloff - 1
      end
      vim.api.nvim_win_set_cursor(0, { get_row, pos[2] })
    elseif left_right_up_down == "down" then
      local scrolloff = vim.opt.scrolloff:get()
      local pos = vim.api.nvim_win_get_cursor(0)
      vim.cmd([[norm! L]])
      local scroll_last_pos = vim.api.nvim_win_get_cursor(0)

      if pos[2] == scroll_last_pos[2] then
        break
      end

      local row_count
      local get_row
      if scroll_last_pos[1] == vim.api.nvim_buf_line_count(0) then
        row_count = scroll_last_pos[1] - pos[1] + 1
        get_row = math.ceil(row_count / 2) + pos[1] - 1
      else
        row_count = scroll_last_pos[1] + scrolloff - pos[1] + 1
        get_row = math.ceil(row_count / 2) + pos[1] - 1
      end
      vim.api.nvim_win_set_cursor(0, { get_row, pos[2] })
    end

    i = i - 1
    if i == 0 then
      break
    end
  end
end

local function getCount(count)
  if count == 0 then
    count = count + 1
  end

  return count
end

function M.cursorLeftMove(count, multiple)
  count = getCount(count)
  vim.api.nvim_feedkeys(count * multiple .. "h", "nt", true)
end

function M.cursorRightMove(count, multiple)
  count = getCount(count)
  vim.api.nvim_feedkeys(count * multiple .. "l", "nt", true)
end

function M.cursorUpMove(count, multiple)
  count = getCount(count)
  vim.api.nvim_feedkeys(count * multiple .. "gk", "nt", true)
end

function M.cursorDownMove(count, multiple)
  count = getCount(count)
  vim.api.nvim_feedkeys(count * multiple .. "gj", "nt", true)
end

function M.normalModeWordLeftMove(count)
  if count > 0 then
    vim.api.nvim_feedkeys(count .. "b", "n", true)
    return
  end
  vim.api.nvim_feedkeys("b", "n", true)
end

function M.normalModeWordRightMove(count)
  if count > 0 then
    vim.api.nvim_feedkeys(count .. "e", "n", true)
    return
  end
  vim.api.nvim_feedkeys("e", "n", true)
end

function M.normalModeWORDRightMove(count)
  if count > 0 then
    vim.api.nvim_feedkeys(count .. "E", "n", true)
    return
  end
  vim.api.nvim_feedkeys("E", "n", true)
end

function M.normalModeWORDLeftMove(count)
  if count > 0 then
    vim.api.nvim_feedkeys(count .. "B", "n", true)
    return
  end
  vim.api.nvim_feedkeys("B", "n", true)
end

function M.rightEnterInsertMode()
  vim.api.nvim_feedkeys("a", "n", true)
end

function M.leftEnterInsertMode()
  vim.api.nvim_feedkeys("i", "n", true)
end

return M
