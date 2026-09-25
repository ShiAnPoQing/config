local exclude_filetypes =
  { "blink-cmp-menu", "cmd", "pager", "dialog", "msg", "fzf", "blink-cmp-documentation", "blink-cmp-dot-repeat" }

local function get_filetype_completion()
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
end

--- bd 命令的增强版本，支持按文件类型删除缓冲区
my.command.define("FILETYPE_BDELETE", "Fbd", function(ev)
  local filetypes = ev.fargs
  local buffer_list = vim.api.nvim_list_bufs()
  local deleted_message

  for _, buffer in ipairs(buffer_list) do
    if vim.api.nvim_buf_is_loaded(buffer) then
      local ft = vim.api.nvim_get_option_value("filetype", { buf = buffer, scope = "local" })
      if vim.tbl_contains(filetypes, ft) then
        local name = vim.api.nvim_buf_get_name(buffer)
        vim.api.nvim_buf_delete(buffer, { force = ev.bang })
        deleted_message = deleted_message and deleted_message .. "\nDeleted buffer:" .. name
          or "Deleted buffer:" .. name
      end
    end
  end

  vim.api.nvim_echo({ { deleted_message, "Normal" } }, true, {})
end, {
  nargs = "*",
  bang = true,
  complete = get_filetype_completion,
})

--- bd 命令的增强版本，支持按文件名模式删除缓冲区
my.command.define("GLOB_BDELETE", "Gbd", function(ev)
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
          deleted_message = deleted_message and deleted_message .. "\nDeleted buffer:" .. name
            or "Deleted buffer:" .. name
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
my.command.define("REGEX_BDELETE", "Rbd", function(ev)
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
          deleted_message = deleted_message and deleted_message .. "\nDeleted buffer:" .. name
            or "Deleted buffer:" .. name
        end
      end
    end
  end
  vim.api.nvim_echo({ { deleted_message, "Normal" } }, true, {})
end, {
  nargs = "*",
  bang = true,
})

my.command.define("FILETYPE_BNEXT", "Fbn", function(ev)
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
  complete = get_filetype_completion,
})

my.command.define("FILETYPE_BPREVIOUS", "Fbp", function(ev)
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
  complete = get_filetype_completion,
})

--- :ls filter by filetype
--- :Fls
--- :Fls {filetype1} {filetype2} ...

my.command.define("FILETYPE_LS", "Fls", function(ev)
  local bang = ev.bang
  local cmd = "ls" .. (bang and "!" or "")

  local filetypes = ev.fargs
  if #filetypes == 0 then
    vim.cmd(cmd)
    return
  end

  local messages = {}
  local bufs = vim.api.nvim_list_bufs()
  local output_lines = vim.split(vim.api.nvim_exec2(cmd, { output = true }).output, "\n")

  local function get_match_output(buf)
    for _, line in ipairs(output_lines) do
      local match = vim.split(line, " ", { trimempty = true })
      if tonumber(match[1]) == buf then
        return line
      end
    end
  end
  for _, buffer in ipairs(bufs) do
    if bang or vim.bo[buffer].buflisted then
      local ft = vim.api.nvim_get_option_value("filetype", { buf = buffer, scope = "local" })
      if vim.tbl_contains(filetypes, ft) then
        local output = get_match_output(buffer)
        if output then
          table.insert(messages, output)
        end
      end
    end
  end
  if #messages == 0 then
    return
  end
  vim.api.nvim_echo({ { table.concat(messages, "\n"), "Normal" } }, true)
end, {
  nargs = "*",
  bang = true,
  complete = get_filetype_completion,
})

my.command.define("REGEX_LS", "Rls", function(ev)
  local bang = ev.bang
  local cmd = "ls" .. (bang and "!" or "")
  --- @type vim.regex[]
  local regexs = {}

  for _, pattern in ipairs(ev.fargs) do
    table.insert(regexs, vim.regex(pattern))
  end
  if #regexs == 0 then
    vim.cmd(cmd)
    return
  end

  local messages = {}
  local bufs = vim.api.nvim_list_bufs()
  local outputs = vim.split(vim.api.nvim_exec2(cmd, { output = true }).output, "\n")

  local function get_match_output(buf)
    for _, output in ipairs(outputs) do
      local segments = vim.split(output, " ", { trimempty = true })
      if tonumber(segments[1]) == buf then
        return output
      end
    end
  end

  local function is_regex_match(buf)
    for _, regex in ipairs(regexs) do
      if regex:match_str(vim.api.nvim_buf_get_name(buf)) then
        return true
      end
    end
  end

  for _, buf in ipairs(bufs) do
    if bang or vim.bo[buf].buflisted then
      if is_regex_match(buf) then
        local output = get_match_output(buf)
        if output then
          table.insert(messages, output)
        end
      end
    end
  end
  if #messages == 0 then
    return
  end
  vim.api.nvim_echo({ { table.concat(messages, "\n"), "Normal" } }, true)
end, {
  nargs = "*",
  bang = true,
})

my.command.define("GLOB_LS", "Gls", function(ev)
  local bang = ev.bang
  local cmd = "ls" .. (bang and "!" or "")
  local lpegs = {}
  for _, pattern in ipairs(ev.fargs) do
    local lpeg = vim.glob.to_lpeg(pattern)
    table.insert(lpegs, lpeg)
  end
  if #lpegs == 0 then
    vim.cmd(cmd)
    return
  end

  local messages = {}
  local bufs = vim.api.nvim_list_bufs()
  local outputs = vim.split(vim.api.nvim_exec2(cmd, { output = true }).output, "\n")

  local function get_match_output(buf)
    for _, output in ipairs(outputs) do
      local segments = vim.split(output, " ", { trimempty = true })
      if tonumber(segments[1]) == buf then
        return output
      end
    end
  end

  local function is_lpeg_match(buf)
    for _, lpeg in ipairs(lpegs) do
      local name = vim.api.nvim_buf_get_name(buf)
      local short_name = vim.fn.fnamemodify(name, ":t")
      if lpeg:match(short_name) then
        return true
      end
    end
  end

  for _, buf in ipairs(bufs) do
    if bang or vim.bo[buf].buflisted then
      if is_lpeg_match(buf) then
        local output = get_match_output(buf)
        if output then
          table.insert(messages, output)
        end
      end
    end
  end
  if #messages == 0 then
    return
  end
  vim.api.nvim_echo({ { table.concat(messages, "\n"), "Normal" } }, true)
end, {
  nargs = "*",
  bang = true,
})
