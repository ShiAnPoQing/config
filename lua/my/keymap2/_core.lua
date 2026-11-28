local M = {
  keymaps = {},
  del_keymaps = {},
  filetypes = {},
  exclude_filetypes = {},
  --- @type table<string, fun()[]>
  events = {
    FileType = {},
  },
  --- @type table<string, integer>
  autcmds = {},
}
local EVENT_GROUP_NAME = "my.keymap2"
local IGNORE_FILETYPES = { "blink-cmp-menu", "fzf" }

-- stylua: ignore
local KEYMAP_SET_OPTS = { noremap = true, nowait = true, silent = true, script = true, expr = true, unique = true, callback = true, desc = true, replace_keycodes = true, buf = true, remap = true, }
-- stylua: ignore
local KEYMAP_DEL_OPTS = { buf = true, }

--- @param where table
--- @param lhs any
local function validate_set_lhs(where, lhs)
  if type(lhs) ~= "string" then
    vim.notify(
      string.format("my.keymap2.set: lhs expected string, but got %s\nsource: %s\n", type(lhs), vim.inspect(where)),
      vim.log.levels.ERROR
    )
  end
end

--- @param where table
--- @param rhs any
local function validate_set_rhs(where, rhs)
  if type(rhs) ~= "string" and type(rhs) ~= "function" then
    vim.notify(
      string.format("my.keymap2.set: rhs expected string, but got %s\nsource: %s\n", type(rhs), vim.inspect(where)),
      vim.log.levels.ERROR
    )
  end
end

--- @param where table
--- @param lhs any
local function validate_del_lhs(where, lhs)
  if type(lhs) ~= "string" then
    vim.notify(
      string.format("my.keymap2.del: lhs expected string, but got %s\nsource: %s\n", type(lhs), vim.inspect(where)),
      vim.log.levels.ERROR
    )
  end
end

--- @param where table
--- @param config any
local function validate_set_spec(where, config)
  if type(config) ~= "table" then
    vim.notify(
      string.format("my.keymap2.set: spec expected table, but got %s\nsource: %s\n", type(config), vim.inspect(where)),
      vim.log.levels.ERROR
    )
  end
end

--- @param where table
--- @param config any
local function validate_del_spec(where, config)
  if type(config) ~= "table" and type(config) ~= "string" then
    vim.notify(
      string.format(
        "my.keymap2.del: spec expected string|table, but got %s\nsource: %s\n",
        type(config),
        vim.inspect(where)
      ),
      vim.log.levels.ERROR
    )
  end
end

--- @param where table
--- @param mode any
local function validate_del_mode(where, mode)
  if type(mode) ~= "string" then
    vim.notify(
      string.format("my.keymap2.del: mode expected string, but got %s\nsource: %s\n", type(mode), vim.inspect(where)),
      vim.log.levels.ERROR
    )
  end
end

--- @param lhs string
--- @param rhs string|fun()
--- @param mode string
--- @param extra my.keymap2.set.Opts
local function collect_keymap(lhs, rhs, mode, extra)
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
  M.keymaps[lhs][mode] = vim.tbl_extend("force", M.keymaps[lhs][mode], extra)
end

local function normalize_ft(where, field, ft)
  if ft == nil then
    return {}
  end
  local filetypes = type(ft) == "table" and ft or { ft }
  for _, f in ipairs(filetypes) do
    if type(f) ~= "string" then
      vim.api.nvim_echo({
        {
          "my.keymap2.set: keymaps[lhs]." .. field .. " expected string, but got " .. type(f) .. "\n",
          "ErrorMsg",
        },
        {
          "source: " .. vim.inspect(where) .. "\n",
        },
      }, true)
    end
  end
  return filetypes
end

--- @param where table
--- @param extra my.keymap2.set.Opts
--- @param callback fun(buf: integer, any)
local function collect_filetype_keymap(where, extra, callback)
  local _fts = normalize_ft(where, "ft", extra.ft)
  local _exclude_fts = normalize_ft(where, "exclude_ft", extra.exclude_ft)
  local fts = {}
  local exclude_fts = {}
  local conflict_fts = {}
  for _, ft in ipairs(_fts) do
    if vim.tbl_contains(_exclude_fts, ft) then
      conflict_fts[ft] = true
      vim.schedule(function()
        vim.api.nvim_echo({
          {
            "my.keymap2.set: keymaps[lhs].ft and keymaps[lhs].exclude_ft specified the same ft: "
              .. ft
              .. ", this ft will be ignored!"
              .. "\n",
            "ErrorMsg",
          },
          {
            "source: " .. vim.inspect(where) .. "\n",
          },
        }, true)
      end)
    else
      table.insert(fts, ft)
    end
  end
  for _, ft in ipairs(_exclude_fts) do
    if not conflict_fts[ft] then
      table.insert(exclude_fts, ft)
    end
  end
  for _, ft in ipairs(fts) do
    M.filetypes[ft] = M.filetypes[ft] or {}
    table.insert(M.filetypes[ft], callback)
  end
  if #exclude_fts > 0 then
    table.insert(M.exclude_filetypes, { callback = callback, filetypes = exclude_fts })
  end
end

--- @param where table
--- @param event any
--- @param callback fun()
local function collect_event_keymap(where, event, callback)
  if event == nil then
    return
  end

  if type(event) ~= "table" then
    event = { event }
  end

  for _, e in ipairs(event) do
    if type(e) == "string" then
      M.events[e] = M.events[e] or {}
      table.insert(M.events[e], callback)
    else
      vim.api.nvim_echo({
        {
          "my.keymap2.set: keymaps[lhs].event expected string, but got " .. type(e) .. "\n",
          "ErrorMsg",
        },
        {
          "source: " .. vim.inspect(where) .. "\n",
          "ErrorMsg",
        },
      }, true)
    end
  end
end

--- @param opts table
--- @param parent_opts table|nil
--- @return table
local function filter_opts(opts, parent_opts)
  local final_opts = {}
  for key, value in pairs(opts) do
    if type(key) == "string" then
      final_opts[key] = value
    end
  end
  final_opts = vim.tbl_extend("force", parent_opts or {}, final_opts)
  return final_opts
end

--- @param map table
--- @param opts my.keymap2.set.Opts
--- @return vim.keymap.set.Opts| vim.keymap.del.Opts
local function filter_keymap_options(map, opts)
  local keymap_opts = {}
  for key, value in pairs(opts) do
    if map[key] then
      keymap_opts[key] = value
    end
  end
  return keymap_opts
end

--- @param rhs any
--- @return boolean
local function is_rhs(rhs)
  return type(rhs) == "string" or type(rhs) == "function"
end

local function _set(mode, lhs, rhs, opts, extra)
  local _rhs = rhs
  if not opts.expr and type(rhs) == "function" then
    rhs = function()
      _rhs(extra)
    end
  end
  local trans = extra.trans ~= false
  local setfunc = trans and my.keymap.set or vim.keymap.set
  local ok, err = pcall(setfunc, mode, lhs, rhs, opts)
  if not ok then
    vim.api.nvim_echo({ { "my.keymap2.set: vim.keymap.set: " .. vim.inspect(err), "ErrorMsg" } }, true)
  end
end

--- @param where table
--- @param lhs string
--- @param rhs string|fun()
--- @param mode string
--- @param opts vim.keymap.set.Opts
--- @param extra my.keymap2.set.Opts
--- @param set? fun()
local function set_keymap(where, lhs, rhs, mode, opts, extra, set)
  set = set or _set
  collect_keymap(lhs, rhs, mode, extra)
  if not extra.ft and not extra.event and not extra.exclude_ft then
    set(mode, lhs, rhs, opts, extra)
    return
  end
  collect_filetype_keymap(where, extra, function(buf)
    set(mode, lhs, rhs, vim.tbl_extend("force", opts, { buf = buf }), extra)
  end)
  collect_event_keymap(where, extra.event, function()
    set(mode, lhs, rhs, opts, extra)
  end)
end

--- @param where table
--- @param lhs string
--- @param rhs my.keymap2.set.Rhs
--- @param mode my.keymap2.set.Mode
--- @param opts my.keymap2.set.Opts
--- @param set? fun()
local function set_mode_keymap(where, lhs, rhs, mode, opts, set)
  if type(mode) == "string" then
    set_keymap(
      where,
      lhs,
      rhs,
      mode,
      filter_keymap_options(KEYMAP_SET_OPTS, opts) --[[@as vim.keymap.set.Opts]],
      opts,
      set
    )
  elseif type(mode) == "table" then
    local modes = mode --[[@as my.keymap2.set.Modes]]
    for _, md in ipairs(modes) do
      set_mode_keymap(where, lhs, rhs, md, filter_opts(modes, opts), set)
    end
  else
    vim.notify(
      string.format("my.keymap2.set: mode expected string, but got %s\nsource: %s\n", type(mode), vim.inspect(where)),
      vim.log.levels.ERROR
    )
  end
end

--- @param where table
--- @param lhs string
--- @param config my.keymap2.set.Spec
--- @param parent_opts my.keymap2.set.Opts
--- @param set? fun()
local function parse_one_rhs(where, lhs, config, parent_opts, set)
  local rhs = config[1]
  local mode = config[2]
  set_mode_keymap(where, lhs, rhs, mode, filter_opts(config, parent_opts), set)
end

--- @param where table
--- @param lhs string
--- @param config my.keymap2.set.Specs
--- @param parent_opts my.keymap2.set.Opts
--- @param set? fun()
local function parse_more_rhs(where, lhs, config, parent_opts, set)
  for _, cfg in ipairs(config) do
    parse_one_rhs(where, lhs, cfg, filter_opts(config, parent_opts), set)
  end
end

--- @param where table
--- @param lhs string
--- @param config my.keymap2.set._Spec
--- @param set? fun()
local function parse_set_spec(where, lhs, config, set)
  local opts = filter_opts(config) --[[@as my.keymap2.set.Opts]]

  if is_rhs(config[1]) then
    parse_one_rhs(where, lhs, config --[[@as my.keymap2.set.Spec]], opts, set)
  elseif type(config[1]) == "table" then
    parse_more_rhs(where, lhs, config --[[@as my.keymap2.set.Specs]], opts, set)
  else
    validate_set_rhs(where, config[1])
  end
end

local function create_hook()
  local group = vim.api.nvim_create_augroup(EVENT_GROUP_NAME, { clear = false })
  for event, callbacks in pairs(M.events) do
    if not M.autcmds[event] then
      local opts = {
        group = group,
      }
      if event == "FileType" then
        opts.pattern = "*"
        opts.callback = function(ev)
          local filetype = vim.bo.filetype
          for _, data in ipairs(M.exclude_filetypes) do
            if not vim.tbl_contains(data.filetypes, filetype) and not vim.tbl_contains(IGNORE_FILETYPES, filetype) then
              data.callback(ev.buf)
            end
          end
          for _, cb in ipairs(M.filetypes[filetype] or {}) do
            cb(ev.buf)
          end
        end
      else
        opts.callback = function()
          for _, cb in ipairs(callbacks) do
            cb()
          end
        end
      end
      M.autcmds[event] = vim.api.nvim_create_autocmd(event, opts)
    end
  end
end

--- @param lhs string
--- @param mode string
--- @param opts table
local function del_keymap(lhs, mode, opts)
  M.del_keymaps[lhs] = M.del_keymaps[lhs] or {}
  M.del_keymaps[lhs][mode] = opts
  return pcall(vim.keymap.del, mode, lhs, filter_keymap_options(KEYMAP_DEL_OPTS, opts) --[[@as vim.keymap.del.Opts]])
end

--- @param where table
--- @param lhs string
--- @param mode any
--- @param opts table
local function pending_del_keymap(where, lhs, mode, opts)
  local ok = del_keymap(lhs, mode, opts)
  if not ok then
    collect_event_keymap(where, "BufReadPre", function()
      del_keymap(lhs, mode, opts)
    end)
  end
end

--- @param where table
--- @param lhs string
--- @param config my.keymap2.del._Spec
local function parse_del_spec(where, lhs, config)
  if type(config) ~= "table" then
    config = { config }
  end

  local opts = filter_opts(config --[[@as my.keymap2.del.Specs]])
  for _, mode in ipairs(config) do
    if type(mode) ~= "table" then
      validate_del_mode(where, mode)
      pending_del_keymap(where, lhs, mode, opts)
    else
      parse_del_spec(where, lhs, vim.tbl_extend("force", opts, mode))
    end
  end
end

--- @param keymaps table<string, my.keymap2.set._Spec>
--- @param set? fun()
function M.set(keymaps, set)
  for lhs, config in pairs(keymaps) do
    local where = { [lhs] = config }
    validate_set_lhs(where, lhs)
    validate_set_spec(where, config)
    parse_set_spec(where, lhs, config, set)
  end
  create_hook()
end

--- @param keymaps table<string, my.keymap2.del._Spec>
function M.del(keymaps)
  for lhs, config in pairs(keymaps) do
    local where = { [lhs] = config }
    validate_del_lhs(where, lhs)
    validate_del_spec(where, config)
    parse_del_spec(where, lhs, config)
  end
  create_hook()
end

--- @param lhs string|nil
function M.get(lhs)
  return M.keymaps[lhs] or M.keymaps
end

return M
