local M = {}

--- @type table<string, CommandProxy.Proxy>
local PROXYS = {}

M.command = {
  ["enable"] = function(cmds)
    M.enable(cmds, true)
  end,
  ["disable"] = function(cmds)
    M.enable(cmds, false)
  end,
  ["buf_enable"] = function() end,
  ["win_enable"] = function() end,
}

setmetatable(M.command, {
  __index = function(t, key)
    local command = rawget(t, key)
    if not command then
      return function()
        vim.schedule(function()
          vim.api.nvim_echo({
            {
              "command-proxy.nvim: Error: no such command '" .. key .. "'",
              "ErrorMsg",
            },
          }, true)
        end)
      end
    end
    return command
  end,
})

--- @alias CommandProxy.Cmd string|fun(cmd_info: vim.api.keyset.cmd):string|nil|boolean

--- @class CommandProxy.Proxy
--- @field buf_proxys table<string, CommandProxy.LocalProxy>
--- @field win_proxys table<string, CommandProxy.LocalProxy>
--- @field buf_win_proxys table<string, CommandProxy.LocalProxy>
--- @field cmd? CommandProxy.Cmd
--- @field enable? boolean

--- @class CommandProxy.Config
--- @field proxy table<string, CommandProxy.Cmd>

--- @class CommandProxy.LocalProxy
--- @field cmd CommandProxy.Cmd
--- @field buf? integer
--- @field win? integer
--- @field enable? boolean

--- @return vim.api.keyset.cmd|nil
local function get_cmd_info()
  local cmdline = vim.fn.getcmdline()
  cmdline = vim.fn.getcmdtype() .. cmdline
  if cmdline == "" then
    return
  end
  local _, info = pcall(vim.api.nvim_parse_cmd, cmdline, {})
  return info
end

--- @param cmd string
--- @return any
local function search_proxy(cmd)
  local proxy = PROXYS[cmd]
  local buf = tostring(vim.api.nvim_get_current_buf())
  local win = tostring(vim.api.nvim_get_current_win())
  local target_proxy = proxy
    and (proxy.buf_win_proxys[buf .. "-" .. win] or proxy.buf_proxys[buf] or proxy.win_proxys[win] or proxy)
  if target_proxy and (target_proxy.enable or target_proxy.enable == nil) then
    return target_proxy
  end
end

--- @param proxy CommandProxy.Cmd
--- @return boolean|nil
local function exec_cmd(cmd_info, proxy)
  local cmd = type(proxy) == "function" and proxy(cmd_info) or proxy
  cmd_info = vim.tbl_deep_extend("force", cmd_info, {})
  if cmd == true then
    return true
  end

  if type(cmd) == "string" then
    cmd_info.cmd = cmd
    vim.schedule(function()
      vim.api.nvim_cmd(cmd_info)
    end)
    return true
  end
end

--- @param config? CommandProxy.Config
function M.setup(config)
  config = config or {}
  for key, cmd in pairs(config.proxy or {}) do
    M.proxy(key, cmd)
  end
  local ns_id = vim.api.nvim_create_namespace("command-proxy")
  local function callback()
    vim.on_key(function(key)
      local input = vim.fn.keytrans(key)
      if input == "<CR>" then
        local cmd_info = get_cmd_info()
        if not cmd_info then
          return
        end
        local proxy = search_proxy(cmd_info.cmd or "")
        if not proxy then
          return
        end
        if exec_cmd(vim.tbl_deep_extend("force", cmd_info, {}), proxy.cmd) then
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, false, true), "t", true)
          return ""
        end
      end
    end, ns_id)
  end
  vim.api.nvim_create_autocmd("CmdlineEnter", {
    callback = callback,
  })
  vim.api.nvim_create_autocmd("CmdlineLeave", {
    callback = function()
      vim.on_key(nil, ns_id)
    end,
  })
  if vim.fn.mode() == "c" then
    callback()
  end
end

--- @class CommandProxy.Options
--- @field buf? integer
--- @field win? integer

--- @param cmd string
--- @param proxy_cmd string|fun(cmd_info: vim.api.keyset.cmd):string|nil|boolean
--- @param opts? table
function M.proxy(cmd, proxy_cmd, opts)
  opts = opts or {}
  vim.validate("cmd", cmd, "string")
  vim.validate("opts", opts, "table")

  if not PROXYS[cmd] then
    PROXYS[cmd] = { buf_proxys = {}, win_proxys = {}, buf_win_proxys = {} }
  end
  local proxy = PROXYS[cmd]

  --- @type CommandProxy.LocalProxy
  local local_proxy = { cmd = proxy_cmd }
  if not opts.win and not opts.buf then
    proxy.cmd = proxy_cmd
  elseif opts.buf and opts.win then
    local buf = opts.buf == 0 and vim.api.nvim_get_current_buf() or opts.buf
    local win = opts.win == 0 and vim.api.nvim_get_current_win() or opts.win
    local_proxy.buf = buf
    local_proxy.win = win
    proxy.buf_win_proxys[tostring(buf) .. "-" .. tostring(win)] = local_proxy
  elseif opts.buf then
    local buf = opts.buf == 0 and vim.api.nvim_get_current_buf() or opts.buf
    local_proxy.buf = buf
    -- if had win proxy, this buf proxy will cause a conflict, preventing overwriting.
    for _, win_proxy in pairs(proxy.win_proxys) do
      if win_proxy.cmd == local_proxy.cmd then
        return
      end
    end
    proxy.buf_proxys[tostring(buf)] = local_proxy
  elseif opts.win then
    local win = opts.win == 0 and vim.api.nvim_get_current_win() or opts.win
    local_proxy.win = win
    -- if had buf proxy, this win proxy will cause a conflict, preventing overwriting.
    for _, buf_proxy in pairs(proxy.buf_proxys) do
      if buf_proxy.cmd == local_proxy.cmd then
        return
      end
    end
    proxy.win_proxys[tostring(win)] = local_proxy
  end
end

--- @param cmds string[]
--- @param enable? boolean
function M.enable(cmds, enable)
  for _, cmd in ipairs(cmds) do
    if PROXYS[cmd] then
      if enable == nil then
        PROXYS[cmd].enable = not PROXYS[cmd].enable
      else
        PROXYS[cmd].enable = enable ~= false
      end
    end
  end
end

function M.get_proxy_cmds()
  return vim.tbl_keys(PROXYS)
end

return M
