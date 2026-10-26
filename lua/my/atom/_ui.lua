--- @class (private) my.atom._ui
local M = {}
local win

local function install_buffer_maps(buf)
  vim.keymap.set("n", "q", function()
    M.close()
  end, { buf = buf })
  vim.keymap.set("n", "<CR>", function()
    -- local ns = vim.api.nvim_create_namespace("my.atom.repeat")
    -- local a = my.atom[ns].get()
    -- local history = capture.get_history()
    -- capture.set_last_capture(history[vim.fn.line(".")])
    M.close()
  end)
end

--- @param arr any[]
--- @param getter fun(any): string
local function get_string_max_length(arr, getter)
  local max
  for _, item in ipairs(arr) do
    max = math.max(max or 0, #getter(item))
  end
  return max
end

--- @param entries my.atom.data[][]
--- @return vim.event.cmdatom.data[][]
local function normalize_entries(entries)
  local _entries = {}
  for _, entry in ipairs(entries) do
    local _entry = { action = "" }
    if #entry > 1 then
      _entry.type = "custom"
    else
      _entry.type = entry[1].data.type or "unknown"
    end
    for _, item in ipairs(entry) do
      _entry.action = _entry.action .. vim.fn.keytrans(item.data.keys or item.data.lhs or ""):gsub("<Space>", " ")
    end
    table.insert(_entries, _entry)
  end
  return _entries
end

local type_highlights = {
  command = "Statement",
  ex = "Statement",
  insert = "String",
  jump = "Identifier",
  mapping = "Special",
  motion = "Function",
  mouse = "Comment",
  operator = "Operator",
  scroll = "Comment",
  visual = "Type",
}

--- @param str string
--- @param base integer
local function get_special_key_highlights(str, base)
  local highlights = {}
  --- @param s string
  --- @param b integer
  local function search(s, b)
    local start = s:find("<", 1, true)
    if start then
      local end_ = s:find(">", 1, true)
      if end_ then
        table.insert(highlights, { start + b - 1, end_ + b, "Special" })
        search(s:sub(end_ + 1), b + end_)
      end
    end
  end
  search(str, base)
  return highlights
end

--- @param ns_id integer
--- @return my.atom.data[][]
local function get_history(ns_id)
  local captures = my.atom[ns_id].get()
  local history = {}

  for _, capture in ipairs(captures) do
    table.insert(history, capture[2])
  end

  return history
end

--- @param entry table
--- @return string, [integer, integer, string][]
local function format_entry(entry)
  local type = entry.type .. string.rep(" ", entry.type_width - #entry.type)
  local action = entry.action .. string.rep(" ", entry.action_width - #entry.action)
  local line = string.format("  %s  %s", type, action)

  local line_highlights = {
    { 2, #type + 2, type_highlights[entry.type] or "Type" },
    unpack(get_special_key_highlights(entry.action, #type + 4)),
  }
  return line, line_highlights
end

--- @class my.atom._ui.Opts

--- @param ns_id integer
--- @param opts? my.atom._ui.Opts
function M.open(ns_id, opts)
  vim.validate("ns_id", ns_id, "number")
  vim.validate("opts", opts, "table", true)
  opts = opts or {}
  if win and vim.api.nvim_win_is_valid(win) then
    M.close()
    return
  end
  vim.api.nvim_set_hl(0, "MyRepeatBorderUnderline", { underline = true })
  vim.api.nvim_set_hl(0, "MyRepeatBorderOverline", { overline = true })
  local buf = vim.api.nvim_create_buf(false, true)
  win = vim.api.nvim_open_win(buf, true, {
    relative = "laststatus",
    height = 12,
    width = 1000,
    row = -12,
    col = 0,
    style = "minimal",
  })
  vim.api.nvim_set_hl(0, "Winbar", { overline = true })
  local name
  for key, _ns_id in pairs(vim.api.nvim_get_namespaces()) do
    if ns_id == _ns_id then
      name = key
    end
  end
  vim.wo[win].winbar = string.format('my.atom["%s"]', name or "")
  vim.wo[win].winfixbuf = true
  vim.wo[win].number = true

  local history = get_history(ns_id)
  if #history > 0 then
    local entries = normalize_entries(history)
    local type_width = get_string_max_length(entries, function(item)
      return item.type
    end)
    type_width = math.min(type_width, 15)
    local action_width = get_string_max_length(entries, function(item)
      return item.action
    end)
    local lines = {}
    local highlights = {}
    for i, entry in ipairs(entries) do
      entry.type_width = type_width
      entry.action_width = action_width
      lines[i], highlights[i] = format_entry(entry)
    end
    local ns = vim.api.nvim_create_namespace("my.atom.ui")
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    for row, spans in ipairs(highlights) do
      for _, span in ipairs(spans) do
        vim.api.nvim_buf_set_extmark(buf, ns, row - 1, span[1], {
          end_col = span[2],
          hl_group = span[3],
          hl_mode = "combine",
        })
      end
    end
  end
  install_buffer_maps(buf)
  vim.bo[buf].modifiable = false
  vim.fn.winrestview({ lnum = #history })
end

function M.close()
  if win and vim.api.nvim_win_is_valid(win) then
    vim.api.nvim_win_close(win, true)
    win = nil
  end
end

return M
