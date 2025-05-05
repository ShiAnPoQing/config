local M = {}

local comment_data = {
  lua = {
    pattern = "%-%-",
    comment = "-- ",
  },
  typescript = {
    pattern = "//",
    comment = "// ",
  },
  javascript = {
    pattern = "//",
    comment = "// ",
  },
}

local function addComment(line, comment)
  if line == "" then
    return ""
  else
    local space, content = line:match("(%s*)(.*)$")
    return space .. comment .. content
  end
end

local function removeComment(space, content)
  if space ~= nil then
    return space .. content
  else
    return content
  end
end

local function useTask(start_row, comment)
  local pattern = "^(%s*)" .. comment.pattern .. "%s*(.*)$"

  local task = {
    begin_row = 0,
    no_comment_lines = {},
    comment_lines = {},
    state = false,
  }

  task.setLines = function(find)
    vim.api.nvim_buf_set_lines(
      0,
      start_row + task.begin_row,
      start_row + task.begin_row + #task[find],
      false,
      task[find]
    )
  end

  task.clean = function(line)
    local space, content = line:match(pattern)

    if content ~= nil then
      if task.state == true then
        task.state = false
        task.setLines("comment_lines")
        task.begin_row = task.begin_row + #task.comment_lines
        task.comment_lines = {}
      end
      table.insert(task.no_comment_lines, removeComment(space, content))
    else
      if task.state == false then
        task.state = true
        task.setLines("no_comment_lines")
        task.begin_row = task.begin_row + #task.no_comment_lines
        task.no_comment_lines = {}
      end

      table.insert(task.comment_lines, addComment(line, comment.comment))
    end
  end

  task.finalClean = function()
    if #task.no_comment_lines ~= 0 then
      task.setLines("no_comment_lines")
      return
    end

    if #task.comment_lines ~= 0 then
      task.setLines("comment_lines")
      return
    end
  end

  return task
end

local function getLines(mode, line_count)
  if mode == "n" then
    local start_row = vim.api.nvim_win_get_cursor(0)[1] - 1
    local end_row = math.min(start_row + line_count, vim.api.nvim_buf_line_count(0))
    local lines = vim.api.nvim_buf_get_lines(0, start_row, end_row, false)
    return lines, start_row, nil
  elseif mode == "v" then
    vim.api.nvim_exec2(
      [[
    execute "normal!" . "\<Esc>"
    ]],
      {}
    )

    local start_pos = vim.api.nvim_buf_get_mark(0, "<")
    local end_pos = vim.api.nvim_buf_get_mark(0, ">")

    local select_lines = vim.api.nvim_buf_get_lines(0, start_pos[1] - 1, end_pos[1], false)
    local recover_visual = function()
      vim.api.nvim_buf_set_mark(0, "<", start_pos[1], start_pos[2], {})
      vim.api.nvim_buf_set_mark(0, ">", end_pos[1], end_pos[2], {})

      vim.api.nvim_exec2(
        [[
      execute "normal! gv"
      ]],
        {}
      )
    end

    return select_lines, start_pos[1] - 1, recover_visual
  end
end

function M.toggleComment(mode, line_count)
  local lines, start_row, recover_visual = getLines(mode, line_count)
  local task = useTask(start_row, comment_data[vim.bo.filetype])

  for _, line in pairs(lines) do
    task.clean(line)
  end

  task.finalClean()

  if recover_visual then
    recover_visual()
  end
end

return M
