local exclude_filetypes = { "blink-cmp-menu", "cmd", "pager", "dialog", "msg", "fzf" }

--- bd 命令的增强版本，支持按文件类型删除缓冲区
vim.api.nvim_create_user_command("Fbd", function(ev)
  local filetypes = ev.fargs
  local buffer_list = vim.api.nvim_list_bufs()
  local deleted_message

  for _, buffer in ipairs(buffer_list) do
    if vim.api.nvim_buf_is_loaded(buffer) then
      local ft = vim.api.nvim_get_option_value("filetype", { buf = buffer, scope = "local" })
      if vim.tbl_contains(filetypes, ft) then
        local name = vim.api.nvim_buf_get_name(buffer)
        vim.api.nvim_buf_delete(buffer, { force = ev.bang })
        deleted_message = deleted_message and deleted_message .. "\nDeleted buffers:" .. name
          or "Deleted buffers:" .. name
      end
    end
  end

  vim.api.nvim_echo({ { deleted_message, "Normal" } }, true, {})
end, {
  nargs = "*",
  bang = true,
  complete = function()
    local completions = {}
    local buffer_list = vim.api.nvim_list_bufs()
    for _, buffer in ipairs(buffer_list) do
      if vim.api.nvim_buf_is_loaded(buffer) then
        local ft = vim.api.nvim_get_option_value("filetype", { buf = buffer, scope = "local" })
        if ft ~= "" and not vim.tbl_contains(completions, ft) and not vim.tbl_contains(exclude_filetypes, ft) then
          table.insert(completions, ft)
        end
      end
    end
    return completions
  end,
})

--- bd 命令的增强版本，支持按文件名模式删除缓冲区
vim.api.nvim_create_user_command("Bd", function(ev)
  local buffer_list = vim.api.nvim_list_bufs()
  local lpegs = {}
  local deleted_message

  for _, pattern in ipairs(ev.fargs) do
    local lpeg = vim.glob.to_lpeg(pattern)
    table.insert(lpegs, lpeg)
  end

  for _, buffer in ipairs(buffer_list) do
    if vim.api.nvim_buf_is_loaded(buffer) then
      local name = vim.api.nvim_buf_get_name(buffer)
      local short_name = vim.fn.fnamemodify(name, ":t")
      for _, lpeg in ipairs(lpegs) do
        if lpeg:match(short_name) then
          vim.api.nvim_buf_delete(buffer, { force = ev.bang })
          deleted_message = deleted_message and deleted_message .. "\nDeleted buffers:" .. name
            or "Deleted buffers:" .. name
        end
      end
    end
  end
  vim.api.nvim_echo({ { deleted_message, "Normal" } }, true, {})
end, {
  nargs = "*",
  bang = true,
})

-- bd 命令的增强版本，支持按文件名正则表达式删除缓冲区
vim.api.nvim_create_user_command("Rbd", function(ev)
  local buffer_list = vim.api.nvim_list_bufs()
  local deleted_message
  --- @type vim.regex[]
  local regexs = {}

  for _, pattern in ipairs(ev.fargs) do
    table.insert(regexs, vim.regex(pattern))
  end

  for _, buffer in ipairs(buffer_list) do
    if vim.api.nvim_buf_is_loaded(buffer) then
      local name = vim.api.nvim_buf_get_name(buffer)
      for _, regex in ipairs(regexs) do
        if not vim.startswith(name, "term://") and regex:match_str(name) then
          vim.api.nvim_buf_delete(buffer, { force = ev.bang })
          deleted_message = deleted_message and deleted_message .. "\nDeleted buffers:" .. name
            or "Deleted buffers:" .. name
        end
      end
    end
  end
  vim.api.nvim_echo({ { deleted_message, "Normal" } }, true, {})
end, {
  nargs = "*",
  bang = true,
})

vim.api.nvim_create_user_command("Fbn", function(ev)
  local filetype = ev.args
  local count = ev.count
  local buffer_list = vim.api.nvim_list_bufs()
  local buf = vim.api.nvim_get_current_buf()

  local ft_bufs = {}
  local index
  for _, buffer in ipairs(buffer_list) do
    if vim.api.nvim_buf_is_loaded(buffer) then
      local ft = vim.api.nvim_get_option_value("filetype", { buf = buffer, scope = "local" })
      if ft == filetype then
        table.insert(ft_bufs, buffer)
      end
      if buffer == buf then
        index = #ft_bufs
      end
    end
  end
  local next_index = (index + count) % #ft_bufs
  next_index = next_index == 0 and #ft_bufs or next_index
  local target_buf = ft_bufs[next_index]
  if target_buf then
    vim.cmd("b " .. target_buf)
  end
end, {
  nargs = 1,
  bang = true,
  count = 1,
  complete = function()
    local completions = {}
    local buffer_list = vim.api.nvim_list_bufs()
    for _, buffer in ipairs(buffer_list) do
      if vim.api.nvim_buf_is_loaded(buffer) then
        local ft = vim.api.nvim_get_option_value("filetype", { buf = buffer, scope = "local" })
        if ft ~= "" and not vim.tbl_contains(completions, ft) and not vim.tbl_contains(exclude_filetypes, ft) then
          table.insert(completions, ft)
        end
      end
    end
    return completions
  end,
})

vim.api.nvim_create_user_command("Fbp", function(ev)
  local filetype = ev.args
  local count = ev.count
  local buffer_list = vim.api.nvim_list_bufs()
  local buf = vim.api.nvim_get_current_buf()

  local ft_bufs = {}
  local index
  for _, buffer in ipairs(buffer_list) do
    if vim.api.nvim_buf_is_loaded(buffer) then
      local ft = vim.api.nvim_get_option_value("filetype", { buf = buffer, scope = "local" })
      if ft == filetype then
        table.insert(ft_bufs, buffer)
      end
      if buffer == buf then
        index = #ft_bufs
      end
    end
  end
  local prev_index = (#ft_bufs - index + count) % #ft_bufs
  prev_index = prev_index == 0 and #ft_bufs or #ft_bufs - prev_index
  local target_buf = ft_bufs[prev_index]
  if target_buf then
    vim.cmd("b " .. target_buf)
  end
end, {
  nargs = 1,
  bang = true,
  count = 1,
  complete = function()
    local completions = {}
    local buffer_list = vim.api.nvim_list_bufs()
    for _, buffer in ipairs(buffer_list) do
      if vim.api.nvim_buf_is_loaded(buffer) then
        local ft = vim.api.nvim_get_option_value("filetype", { buf = buffer, scope = "local" })
        if ft ~= "" and not vim.tbl_contains(completions, ft) and not vim.tbl_contains(exclude_filetypes, ft) then
          table.insert(completions, ft)
        end
      end
    end
    return completions
  end,
})
