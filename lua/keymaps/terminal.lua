local term_requests = {}
local word_regex = vim.regex("\\k\\+\\|[^[:keyword:][:space:]]\\+")
local WORD_regex = vim.regex("\\S\\+")
local cword_regex = vim.regex("\\k\\+\\|[^[:keyword:][:space:]]\\+\\|\\s\\+")
local CWORD_regex = vim.regex("\\S\\+\\|\\s\\+")

local GET_PROMPT_STATE = "\x00"

local function send_chan(key)
  local shell_job = vim.b.terminal_job_id
  if shell_job then
    vim.api.nvim_chan_send(shell_job, key)
    return true
  end
end

local function move(offset)
  if offset == 0 then
    return
  end
  local dir = offset > 0 and "<right>" or "<left>"
  dir = dir:rep(math.abs(offset))
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(dir, true, false, true), "n", false)
  return true
end

local function delete(offset)
  if offset == 0 then
    return
  end
  local key = offset > 0 and "<bs>" or "<C-d>"
  key = key:rep(math.abs(offset))
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, false, true), "n", false)
end

local function match(regex, str, callback)
  local function run(s)
    local start, _end = regex:match_str(s)
    if start == nil then
      return
    end
    if callback(#str - #s + start, #str - #s + _end) then
      return
    end
    run(s:sub(_end + 1))
  end

  run(str)
end

local function get_new_cmdpos(regex, cmdline, callback)
  local new_cmdpos
  match(regex, cmdline, function(start, _end)
    local may_new_cmdpos, is_finished = callback(start + 1, _end)
    if type(may_new_cmdpos) == "number" then
      new_cmdpos = may_new_cmdpos
    end
    return is_finished
  end)
  return new_cmdpos
end

local term_respones = {
  ["test"] = function(text, pos)
    vim.print("get: " .. text .. ";" .. pos)
    vim.fn.writefile({ vim.json.encode({ buffer = "你好", cursor = 1 }) }, "/tmp/zsh-command")
    send_chan("[27~")
  end,
  ["last-non-blank-char"] = function(cmd, cursor)
    local target = cmd:find("%S%s*$")
    if not target then
      return
    end
    if not move(target - cursor) then
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-e>", true, false, true), "n", false)
    end
  end,
  ["first-non-blank-char"] = function(cmd, cursor)
    local target = cmd:find("%S")
    if not target then
      return
    end
    if not move(target - cursor - 1) then
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-a>", true, false, true), "n", false)
    end
  end,
  ["prev-word-start"] = nil,
  ["prev-word-end"] = function(cmd, cursor)
    cursor = cursor + 1
    local new_cmdpos = get_new_cmdpos(word_regex, cmd, function(_, _end)
      if cursor > _end + 1 then
        return _end + 1
      end
    end)
    if not new_cmdpos then
      new_cmdpos = 1
    end
    move(new_cmdpos - cursor)
  end,
  ["next-word-start"] = nil,
  ["next-word-end"] = function(cmd, cursor)
    cursor = cursor + 1
    local new_cmdpos = get_new_cmdpos(word_regex, cmd, function(_, _end)
      if cursor <= _end then
        return _end + 1, true
      end
    end)
    if not new_cmdpos then
      new_cmdpos = #cmd + 1
    end
    move(new_cmdpos - cursor)
  end,
  ["prev-WORD-start"] = function(cmd, cursor)
    cursor = cursor + 1
    local new_cmdpos = get_new_cmdpos(WORD_regex, cmd, function(start, _)
      if cursor > start then
        return start
      end
    end)
    if not new_cmdpos then
      new_cmdpos = 1
    end
    move(new_cmdpos - cursor)
  end,
  ["prev-WORD-end"] = function(cmd, cursor)
    cursor = cursor + 1
    local new_cmdpos = get_new_cmdpos(WORD_regex, cmd, function(_, _end)
      if cursor > _end + 1 then
        return _end + 1
      end
    end)
    if not new_cmdpos then
      new_cmdpos = 1
    end
    move(new_cmdpos - cursor)
  end,
  ["next-WORD-start"] = function(cmd, cursor)
    cursor = cursor + 1
    local new_cmdpos = get_new_cmdpos(WORD_regex, cmd, function(start, _)
      if cursor < start then
        return start, true
      end
    end)
    if not new_cmdpos then
      new_cmdpos = #cmd + 1
    end
    move(new_cmdpos - cursor)
  end,
  ["next-WORD-end"] = function(cmd, cursor)
    cursor = cursor + 1
    local new_cmdpos = get_new_cmdpos(WORD_regex, cmd, function(_, _end)
      if cursor <= _end then
        return _end + 1, true
      end
    end)
    if not new_cmdpos then
      new_cmdpos = #cmd + 1
    end
    move(new_cmdpos - cursor)
  end,
  ["delete-to-prev-word-start"] = function(cmdline, cmdpos)
    cmdpos = cmdpos + 1
    local new_cmdpos = get_new_cmdpos(word_regex, cmdline, function(start, _)
      if cmdpos > start then
        return start
      end
    end)
    if not new_cmdpos then
      new_cmdpos = 1
    end
    local offset = new_cmdpos - cmdpos
    local key = "<bs>"
    key = key:rep(math.abs(offset))
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, false, true), "n", false)
  end,
  ["delete-to-prev-word-end"] = function(cmdline, cmdpos)
    cmdpos = cmdpos + 1
    local new_cmdpos = get_new_cmdpos(word_regex, cmdline, function(_, _end)
      if cmdpos > _end + 1 then
        return _end + 1
      end
    end)
    if not new_cmdpos then
      new_cmdpos = 1
    end
    delete(new_cmdpos - cmdpos)
  end,
  ["delete-to-prev-WORD-end"] = function(cmdline, cmdpos)
    cmdpos = cmdpos + 1
    local new_cmdpos = get_new_cmdpos(WORD_regex, cmdline, function(_, _end)
      if cmdpos > _end + 1 then
        return _end + 1
      end
    end)
    if not new_cmdpos then
      new_cmdpos = 1
    end
    delete(new_cmdpos - cmdpos)
  end,
  ["delete-to-next-word-end"] = function(cmdline, cmdpos)
    cmdpos = cmdpos + 1
    local new_cmdpos = get_new_cmdpos(word_regex, cmdline, function(_, _end)
      if cmdpos <= _end then
        return _end + 1, true
      end
    end)
    if not new_cmdpos then
      new_cmdpos = #cmdline
    end
    delete(new_cmdpos - cmdpos)
  end,
  ["delete-to-next-word-start"] = function(cmdline, cmdpos)
    cmdpos = cmdpos + 1
    local new_cmdpos = get_new_cmdpos(word_regex, cmdline, function(start, _)
      if cmdpos < start then
        return start, true
      end
    end)
    if not new_cmdpos then
      new_cmdpos = #cmdline
    end
    delete(new_cmdpos - cmdpos)
  end,
  ["delete-to-next-WORD-start"] = function(cmdline, cmdpos)
    cmdpos = cmdpos + 1
    local new_cmdpos = get_new_cmdpos(WORD_regex, cmdline, function(start, _)
      if cmdpos < start then
        return start, true
      end
    end)
    if not new_cmdpos then
      new_cmdpos = #cmdline
    end
    delete(new_cmdpos - cmdpos)
  end,
}

--- @param request string
local function request_shell(request)
  table.insert(term_requests, request)
  local shell_job = vim.b.terminal_job_id
  if shell_job then
    vim.api.nvim_chan_send(shell_job, "\x00")
  end
end

-- vim.api.nvim_create_autocmd("TermRequest", {
--   callback = function(ev)
--     local cmd, cursor = ev.data.sequence:match("]777;cmd=(.*);cursor=(%d+)$")
--     if cmd then
--       local request = term_requests[1]
--       table.remove(term_requests, 1)
--       if term_respones[request] then
--         term_respones[request](cmd, tonumber(cursor))
--       end
--     end
--   end,
-- })

return {
  ["<M-I>"] = {
    function()
      request_shell("prev-WORD-start")
    end,
    "t",
    desc = "Move to prev-WORD-start",
  },
  ["<M-O>"] = {
    function()
      request_shell("next-WORD-end")
    end,
    "t",
    desc = "Move to next-WORD-end",
  },
  ["<M-space><M-i>"] = {
    function()
      request_shell("prev-word-end")
    end,
    "t",
    desc = "Move to prev-word-end",
  },
  ["<M-space><M-o>"] = { "<M-f>", "t", desc = "Move to next-word-start" },
  ["<M-space><M-I>"] = {
    function()
      request_shell("prev-WORD-end")
    end,
    "t",
    desc = "Move to prev-WORD-end",
  },
  ["<M-S-space><M-I>"] = {
    function()
      request_shell("prev-WORD-end")
    end,
    "t",
    desc = "Move to prev-WORD-end",
  },
  ["<M-space><M-O>"] = {
    function()
      request_shell("next-WORD-start")
    end,
    "t",
    desc = "Move to next-WORD-start",
  },
  ["<M-S-space><M-O>"] = {
    function()
      request_shell("next-WORD-start")
    end,
    "t",
    desc = "Move to next-WORD-start",
  },

  ["<C-space><C-v>"] = {
    '<C-\\><C-N>"api',
    "t",
    silent = false,
    noremap = true,
  },
  ["<C-space><C-space><C-v>"] = {
    '<C-\\><C-N>"+pi',
    "t",
    silent = false,
    noremap = true,
  },
  ["<M-`><M-h>"] = { "<home>", "t" },
  ["<M-`><M-l>"] = { "<end>", "t" },
  ["<Esc>"] = {
    "<C-\\><C-N>",
    "t",
  },
}
