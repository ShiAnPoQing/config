local M = {}

local function echoMessage(data)
  if data.type == "up" then
    vim.api.nvim_echo({
      { "向上移动选中行 ", "Msg" },
      { tostring(data.count), "ErrorMsg" },
      { " 行", "Msg" },
    }, true, {})
    return
  end

  if data.type == "upTop" then
    vim.api.nvim_echo({
      { "向上移动选中行 ", "Msg" },
      { tostring(data.count), "ErrorMsg" },
      { " 行到行首", "Msg" },
    }, true, {})
    return
  end

  if data.type == "down" then
    vim.api.nvim_echo({
      { "向下移动选中行 ", "Msg" },
      { tostring(data.count), "ErrorMsg" },
      { " 行", "Msg" },
    }, true, {})
    return
  end

  if data.type == "downEnd" then
    vim.api.nvim_echo({
      { "向下移动选中行 ", "Msg" },
      { tostring(data.count), "ErrorMsg" },
      { " 行到行尾", "Msg" },
    }, true, {})
    return
  end
end

--- @param count integer
--- @param dir "up"|"down"
function M.moveLineVisualMode(count, dir)
  vim.api.nvim_exec2([[execute "normal!" . "\<Esc>"]], {})

  local start_pos = vim.api.nvim_buf_get_mark(0, "<")
  local end_pos = vim.api.nvim_buf_get_mark(0, ">")

  local startLine = start_pos[1]
  local endLine = end_pos[1]
  local selectLines = vim.api.nvim_buf_get_lines(0, startLine - 1, endLine, false)

  if dir == "up" then
    if start_pos[1] == 1 then
      echoMessage({
        type = "upTop",
        count = 0,
      })
    else
      local toColumn = math.max(start_pos[1] - count, 1)
      local exchangeLines = vim.api.nvim_buf_get_lines(0, toColumn - 1, start_pos[1] - 1, false)

      vim.api.nvim_buf_set_lines(0, toColumn + #selectLines, end_pos[1], false, exchangeLines)
      vim.api.nvim_buf_set_lines(0, toColumn - 1, toColumn + #selectLines, false, selectLines)

      vim.api.nvim_buf_set_mark(0, "<", toColumn, start_pos[2], {})
      vim.api.nvim_buf_set_mark(0, ">", toColumn + #selectLines - 1, end_pos[2], {})

      -- if toColumn == 1 then
      --   echoMessage({
      --     type = "upTop",
      --     count = start_pos[1] - toColumn,
      --   })
      -- else
      --   echoMessage({
      --     type = "up",
      --     count = count,
      --   })
      -- end
    end

    vim.api.nvim_exec2([[execute "normal! gv"]], {})
    return
  end

  if dir == "down" then
    local bufLineCount = vim.api.nvim_buf_line_count(0)
    local toColumn = math.min(end_pos[1] + count, bufLineCount)
    local exchangeLines = vim.api.nvim_buf_get_lines(0, end_pos[1], toColumn, false)

    vim.api.nvim_buf_set_lines(0, start_pos[1] - 1, toColumn - #selectLines, false, exchangeLines)
    vim.api.nvim_buf_set_lines(0, toColumn - #selectLines, toColumn, false, selectLines)

    vim.api.nvim_buf_set_mark(0, "<", toColumn - #selectLines + 1, start_pos[2], {})
    vim.api.nvim_buf_set_mark(0, ">", toColumn, end_pos[2], {})

    vim.api.nvim_exec2([[execute "normal! gv"]], {})

    -- if toColumn == bufLineCount then
    --   echoMessage({
    --     type = "downEnd",
    --     count = toColumn - end_pos[1],
    --   })
    -- else
    --   echoMessage({
    --     type = "down",
    --     count = count,
    --   })
    -- end
  end
end

function M.moveLine(count, dir)
  local pos = vim.api.nvim_win_get_cursor(0)
  local row = pos[1]
  local col = pos[2]

  if dir == "down" then
    local buf_line_count = vim.api.nvim_buf_line_count(0)
    local torow = math.min(row + count, buf_line_count)

    local lines = vim.api.nvim_buf_get_lines(0, row - 1, torow, false)
    local cursor_line = { lines[1] }
    local remainingLines = {}
    table.move(lines, 2, #lines, 1, remainingLines)

    vim.api.nvim_buf_set_lines(0, torow - 1, torow, false, cursor_line)
    vim.api.nvim_buf_set_lines(0, row - 1, torow - 1, false, remainingLines)
    vim.api.nvim_win_set_cursor(0, { torow, col })

    -- if torow == buf_line_count then
    --   echoMessage({
    --     type = "downEnd",
    --     count = torow - row,
    --   })
    -- else
    --   echoMessage({
    --     type = "down",
    --     count = count,
    --   })
    -- end

    return
  end

  local torow = math.max(row - count, 1)
  local lines = vim.api.nvim_buf_get_lines(0, torow - 1, row, false)
  local cursor_line = { lines[#lines] }
  local remainingLines = {}

  table.move(lines, 1, #lines - 1, 1, remainingLines)

  vim.api.nvim_buf_set_lines(0, torow - 1, torow, false, cursor_line)
  vim.api.nvim_buf_set_lines(0, torow, row, false, remainingLines)

  -- if torow == 1 then
  --   echoMessage({
  --     type = "upTop",
  --     count = row - torow,
  --   })
  -- else
  --   echoMessage({
  --     type = "up",
  --     count = count,
  --   })
  -- end

  vim.api.nvim_win_set_cursor(0, { torow, col })
end

return M
