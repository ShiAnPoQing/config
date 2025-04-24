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

function M.moveLineVisualMode(count, upOrDown)
  vim.api.nvim_exec2(
    [[
  execute "normal!" . "\<Esc>"
  ]],
    {}
  )

  local startPos = vim.api.nvim_buf_get_mark(0, "<")
  local endPos = vim.api.nvim_buf_get_mark(0, ">")

  local startLine = startPos[1]
  local endLine = endPos[1]
  local selectLines = vim.api.nvim_buf_get_lines(0, startLine - 1, endLine, false)

  if upOrDown == "up" then
    if startPos[1] == 1 then
      echoMessage({
        type = "upTop",
        count = 0,
      })
    else
      local toColumn = math.max(startPos[1] - count, 1)
      local exchangeLines = vim.api.nvim_buf_get_lines(0, toColumn - 1, startPos[1] - 1, false)

      vim.api.nvim_buf_set_lines(0, toColumn + #selectLines, endPos[1], false, exchangeLines)
      vim.api.nvim_buf_set_lines(0, toColumn - 1, toColumn + #selectLines, false, selectLines)

      vim.api.nvim_buf_set_mark(0, "<", toColumn, startPos[2], {})
      vim.api.nvim_buf_set_mark(0, ">", toColumn + #selectLines - 1, endPos[2], {})

      if toColumn == 1 then
        echoMessage({
          type = "upTop",
          count = startPos[1] - toColumn,
        })
      else
        echoMessage({
          type = "up",
          count = count,
        })
      end
    end

    vim.api.nvim_exec2(
      [[
    execute "normal! gv"
    ]],
      {}
    )

    return
  end

  if upOrDown == "down" then
    local bufLineCount = vim.api.nvim_buf_line_count(0)
    local toColumn = math.min(endPos[1] + count, bufLineCount)
    local exchangeLines = vim.api.nvim_buf_get_lines(0, endPos[1], toColumn, false)

    vim.api.nvim_buf_set_lines(0, startPos[1] - 1, toColumn - #selectLines, false, exchangeLines)
    vim.api.nvim_buf_set_lines(0, toColumn - #selectLines, toColumn, false, selectLines)

    vim.api.nvim_buf_set_mark(0, "<", toColumn - #selectLines + 1, startPos[2], {})
    vim.api.nvim_buf_set_mark(0, ">", toColumn, endPos[2], {})

    vim.api.nvim_exec2(
      [[
    execute "normal! gv"
    ]],
      {}
    )

    if toColumn == bufLineCount then
      echoMessage({
        type = "downEnd",
        count = toColumn - endPos[1],
      })
    else
      echoMessage({
        type = "down",
        count = count,
      })
    end
  end
end

function M.moveLine(count, upOrDown)
  local pos = vim.api.nvim_win_get_cursor(0)
  local column = pos[1]
  local col = pos[2]

  if upOrDown == "down" then
    local bufLineCount = vim.api.nvim_buf_line_count(0)
    local toColumn = math.min(column + count, bufLineCount)

    local lines = vim.api.nvim_buf_get_lines(0, column - 1, toColumn, false)
    local currentLine = { lines[1] }
    local remainingLines = {}
    table.move(lines, 2, #lines, 1, remainingLines)

    vim.api.nvim_buf_set_lines(0, toColumn - 1, toColumn, false, currentLine)
    vim.api.nvim_buf_set_lines(0, column - 1, toColumn - 1, false, remainingLines)

    vim.api.nvim_win_set_cursor(0, { toColumn, col })

    if toColumn == bufLineCount then
      echoMessage({
        type = "downEnd",
        count = toColumn - column,
      })
    else
      echoMessage({
        type = "down",
        count = count,
      })
    end

    return
  end

  local toColumn = math.max(column - count, 1)
  local lines = vim.api.nvim_buf_get_lines(0, toColumn - 1, column, false)
  local currentLine = { lines[#lines] }
  local remainingLines = {}

  table.move(lines, 1, #lines - 1, 1, remainingLines)

  vim.api.nvim_buf_set_lines(0, toColumn - 1, toColumn, false, currentLine)
  vim.api.nvim_buf_set_lines(0, toColumn, column, false, remainingLines)

  if toColumn == 1 then
    echoMessage({
      type = "upTop",
      count = column - toColumn,
    })
  else
    echoMessage({
      type = "up",
      count = count,
    })
  end
  vim.api.nvim_win_set_cursor(0, { toColumn, col })
end

return M
