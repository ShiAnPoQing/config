-- [lhs] = {rhs, mode, key=vlaue},
-- [lhs] = {rhs, {mode1, mode2}, key=value},
-- [lhs] = {rhs, {mode1, mode2, key=value}, key=value},
-- [lhs] = {rhs, {mode1, {mode2, key=value} key=value}, key=value}
-- [lhs] = {rhs, {mode1, {mode2, mode3, key=value} key=value}, key=value}
-- ["lhs"] = {
--   {rhs, mode, key=value},
--   {rhs, {mode1, mode2}, key=value},
--   key=value
-- }

local M = {
  keymaps = {},
  filetypes = {},
  events = {},
  delete_keymaps = {},
}

local KeymapOptsMap = {
  noremap = true,
  nowait = true,
  silent = true,
  script = true,
  expr = true,
  unique = true,
  callback = true,
  desc = true,
  replace_keycodes = true,
  buffer = true,
  remap = true,
}

local DeleteKeymapOptsMap = {
  buffer = true,
}

--- @param rhs any
--- @return boolean
local function is_rhs(rhs)
  return type(rhs) == "string" or type(rhs) == "function"
end

local function get_keymap_opts(opts)
  local keymap_opts = {}
  for key, value in pairs(opts) do
    if KeymapOptsMap[key] then
      keymap_opts[key] = value
    end
  end
  return keymap_opts
end

local function get_delete_keymap_opts(opts)
  local keymap_opts = {}
  for key, value in pairs(opts) do
    if DeleteKeymapOptsMap[key] then
      keymap_opts[key] = value
    end
  end
  return keymap_opts
end

local function get_file_path(base, path)
  if vim.endswith(path, "/") then
    path = base .. path .. "*.lua"
  else
    path = base .. path .. ".lua"
  end
  return path
end

local function collect_filetype_keymap(filetype, callback)
  if type(filetype) == "string" then
    M.filetypes[filetype] = M.filetypes[filetype] or {}
    table.insert(M.filetypes[filetype], function()
      callback()
    end)
    return
  end

  if type(filetype) == "table" then
    for _, ft in ipairs(filetype) do
      collect_filetype_keymap(ft, callback)
    end
  end
end

local function collect_event_keymap(event, callback)
  if type(event) == "string" then
    M.events[event] = M.events[event] or {}
    table.insert(M.events[event], callback)
    return
  end

  if type(event) == "table" then
    for _, e in ipairs(event) do
      collect_event_keymap(e, callback)
    end
  end
end

local function set_keymap(lhs, rhs, mode, opts)
  if not is_rhs(rhs) then
    vim.notify("simple-keymap: rhs must be string or function")
    return
  end

  if type(mode) ~= "string" then
    vim.notify("simple-keymap: mode must be string or table<string>")
    return
  end

  if not M.keymaps[lhs] then
    M.keymaps[lhs] = {
      [mode] = {
        rhs = rhs,
      },
    }
  else
    M.keymaps[lhs][mode] = {
      rhs = rhs,
    }
  end

  local keymap_mode = vim.tbl_extend("force", M.keymaps[lhs][mode], opts)
  M.keymaps[lhs][mode] = keymap_mode
  local keymap_opts = get_keymap_opts(opts)

  if opts.filetype then
    collect_filetype_keymap(opts.filetype, function()
      pcall(vim.keymap.set, mode, lhs, rhs, keymap_opts)
    end)
    return
  end

  if opts.event then
    collect_event_keymap(opts.event, function()
      pcall(vim.keymap.set, mode, lhs, rhs, keymap_opts)
    end)
    return
  end

  if keymap_mode.context == true and type(rhs) == "function" then
    pcall(vim.keymap.set, mode, lhs, function()
      rhs(keymap_mode)
    end, keymap_opts)
  else
    pcall(vim.keymap.set, mode, lhs, rhs, keymap_opts)
  end
end

local function get_opts(data)
  local opts = {}
  for key, value in pairs(data) do
    if type(key) == "string" then
      opts[key] = value
    end
  end

  return opts
end

local function parse_mode(lhs, rhs, modes, parent_opts)
  local opts = vim.tbl_extend("force", parent_opts, get_opts(modes))
  for _, mode in ipairs(modes) do
    if type(mode) == "string" then
      set_keymap(lhs, rhs, mode, opts)
    elseif type(mode) == "table" then
      parse_mode(lhs, rhs, mode, opts)
    end
  end
end

local function parse_one_rhs(lhs, data, parent_opts)
  local rhs = data[1]
  local mode = data[2]
  local opts = vim.tbl_extend("force", parent_opts, get_opts(data))

  if not mode then
    vim.notify(
      'simple-keymap: ["' .. lhs .. '"] the mode must be provided in the second position!',
      vim.log.levels.WARN
    )
    return
  end

  if type(mode) == "string" then
    set_keymap(lhs, rhs, mode, opts)
  elseif type(mode) == "table" then
    parse_mode(lhs, rhs, mode, opts)
  end
end

local function parse_more_rhs(lhs, data, parent_opts)
  local opts = vim.tbl_extend("force", parent_opts, get_opts(data))
  for _, value in ipairs(data) do
    parse_one_rhs(lhs, value, opts)
  end
end

local function del_keymap(lhs, mode, opts)
  M.delete_keymaps[lhs] = M.delete_keymaps[lhs] or {}
  M.delete_keymaps[lhs][mode] = opts
  local keymap_opts = get_delete_keymap_opts(opts)
  pcall(vim.keymap.del, mode, lhs, keymap_opts)
end

local function parse_delete_keymap(lhs, data)
  local opts = get_opts(data)

  for _, mode in ipairs(data) do
    if type(mode) == "string" then
      collect_event_keymap("BufReadPre", function()
        del_keymap(lhs, mode, opts)
      end)
    elseif type(mode) == "table" then
      parse_delete_keymap(lhs, vim.tbl_extend("force", opts, mode))
    end
  end
end

local function parse_add_keymap(lhs, data)
  if type(data) ~= "table" then
    vim.notify("simple-keymap: rhs value must be table")
    return
  end

  local opts = get_opts(data)

  if type(data[1]) == "table" then
    parse_more_rhs(lhs, data, opts)
  elseif is_rhs(data[1]) then
    parse_one_rhs(lhs, data, opts)
  end
end

local function parse_path(path, callback)
  local base = vim.fn.stdpath("config") .. "/lua/"
  path = get_file_path(base, path)
  local files = vim.fn.glob(path, true, true)
  for _, file in ipairs(files) do
    local module_path = file:gsub(base, ""):gsub("%.lua$", "")
    local success, v = pcall(require, module_path)
    if success and type(v) == "table" then
      callback(v)
    end
  end
end

function M.add(source)
  if type(source) ~= "table" then
    return
  end

  for lhs, data in pairs(source) do
    if type(lhs) == "number" then
      parse_path(data, function(s)
        M.add(s)
      end)
    else
      parse_add_keymap(lhs, data)
    end
  end
end

function M.del(source)
  if type(source) ~= "table" then
    return
  end

  for lhs, data in pairs(source) do
    if type(lhs) == "number" then
      parse_path(data, function(s)
        M.del(s)
      end)
    else
      parse_delete_keymap(lhs, data)
    end
  end
end

function M.get(lhs)
  return M.keymaps[lhs]
end

function M.get_keymaps()
  return M.keymaps
end

function M.filetype_load()
  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("simple-keymap-filetype", {}),
    pattern = vim.tbl_keys(M.filetypes),
    callback = function()
      local callbacks = M.filetypes[vim.bo.filetype] or {}
      for _, cb in ipairs(callbacks) do
        cb()
      end
    end,
  })
end

function M.event_load()
  for event, callbacks in pairs(M.events) do
    vim.api.nvim_create_autocmd(event, {
      group = vim.api.nvim_create_augroup("simple-keymap-event", {}),
      callback = function()
        for _, cb in ipairs(callbacks) do
          cb()
        end
      end,
    })
  end
end

--- @param opts? SimpleKeymapOpts
function M.load(opts)
  opts = opts or {}
  M.add(opts.add or {})
  M.del(opts.del or {})
  M.filetype_load()
  M.event_load()
end

return M
