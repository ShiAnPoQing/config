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
}

local function get_keymap_opts(opts)
  local keymap_opts = {}
  for key, value in pairs(opts) do
    if KeymapOptsMap[key] then
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

local function set_keymap(lhs, rhs, mode, opts)
  if not (type(rhs) == "string" or type(rhs) == "function") then
    vim.notify("simple-keymap: rhs must be string or function")
    return
  end

  if type(mode) ~= "string" then
    vim.notify("simple-keymap: mode must be string or table<string>")
    return
  end

  local keymap_opts = get_keymap_opts(opts)

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

  M.keymaps[lhs][mode] = vim.tbl_extend("force", M.keymaps[lhs][mode], opts)

  if opts.filetype then
    M.filetypes[opts.filetype] = M.filetypes[opts.filetype] or {}
    table.insert(M.filetypes[opts.filetype], function()
      pcall(vim.keymap.set, mode, lhs, rhs, keymap_opts)
    end)
  end

  pcall(vim.keymap.set, mode, lhs, rhs, keymap_opts)
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

local function parse(lhs, data)
  if type(data) ~= "table" then
    vim.notify("simple-keymap: lhs = value must be table")
    return
  end

  local opts = get_opts(data)

  if type(data[1]) == "table" then
    parse_more_rhs(lhs, data, opts)
  elseif type(data[1]) == "string" then
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
      parse(lhs, data)
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
      parse(lhs, data)
    end
  end
end

function M.filetype_load()
  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("simple-keymap-filetype", {}),
    pattern = vim.tbl_keys(M.filetypes),
    callback = function()
      local callbacks = M.filetypes[vim.bo.filetype]
      if not callbacks then
        return
      end
      for _, cb in ipairs(callbacks) do
        cb()
      end
    end,
  })
end

--- @param opts? SimpleKeymapOpts
function M.load(opts)
  opts = opts or {}
  M.add(opts.add or {})
  M.del(opts.del or {})
  M.filetype_load()
end

return M
