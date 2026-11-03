--- @class (private) my._atom._menu
local M = {}

--- @type my._atom._menu.window|nil
local Win
--- @type my._atom._menu.buffer|nil
local Buf

local function install_buffer_maps(buf)
  vim.keymap.set("n", "<esc>", function()
    M.close()
  end, { buf = buf })
  vim.keymap.set("n", "q", function()
    M.close()
  end, { buf = buf })
  vim.keymap.set("n", "<CR>", function()
    M.close()
  end, { buf = buf })
end

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
--- @return my.Atom[]
local function get_items(ns_id)
  local atoms = my._atom.get(ns_id)
  --- @type my.Atom[]
  local items = {}

  for _, atom in ipairs(atoms or {}) do
    table.insert(items, atom[2])
  end

  return items
end

--- @param ns_id integer
--- @return string|nil
local function get_ns_name(ns_id)
  local name
  for key, _ns_id in pairs(vim.api.nvim_get_namespaces()) do
    if ns_id == _ns_id then
      name = key
    end
  end
  return name
end

--- @param ns_id integer
--- @param opts? my._atom._menu.Opts
function M.open(ns_id, opts)
  vim.validate("ns_id", ns_id, "number")
  vim.validate("opts", opts, "table", true)
  if Win then
    return
  end
  opts = require("my._atom._menu.config").merge(opts or {})
  Buf = require("my._atom._menu.buffer"):new({
    name = "my.atom.menu",
  })
  Win = require("my._atom._menu.window"):new({
    border = "none",
    height = opts.window.height,
    option = {
      ["winfixbuf"] = true,
      ["number"] = true,
      ["winbar"] = string.format("%%=my.atom: %s%%=", get_ns_name(ns_id) or ""),
    },
  })
  local buf = Buf:get()
  Win:open(buf)
  require("my._atom._menu.render").draw(buf, get_items(ns_id), opts.layout)
  vim.api.nvim_create_autocmd("WinLeave", {
    callback = function(ev)
      if ev.buf == buf then
        M.close()
        return true
      end
    end,
  })
  install_buffer_maps(buf)
  Buf:set_option("modifiable", false)
end

function M.close()
  if Win then
    Win:close()
    Buf:del()
    Win = nil
    Buf = nil
    return
  end
end

return M
