local layout = require("my.atom._menu.layout")

--- @class (private) my.atom._menu
local M = {}

--- @type my.atom._menu.window|nil
local Win
--- @type my.atom._menu.buffer|nil
local Buf

local function install_buffer_maps(buf)
  vim.keymap.set("n", "<esc>", function()
    M.close()
  end, { buf = buf })
  vim.keymap.set("n", "q", function()
    M.close()
  end, { buf = buf })
  vim.keymap.set("n", "<CR>", function()
    local cursor = vim.api.nvim_win_get_cursor(0)
  end, { buf = buf })
end

--- @param ns_id integer
--- @return my.Atom[]
local function get_items(ns_id)
  local atoms = my.atom.get(ns_id)
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
--- @param opts? my.atom._menu.Opts
function M.open(ns_id, opts)
  vim.validate("ns_id", ns_id, "number")
  vim.validate("opts", opts, "table", true)
  if Win then
    return
  end
  opts = require("my.atom._menu.config").merge(opts or {})
  Buf = require("my.atom._menu.buffer"):new({
    name = "my.atom.menu",
  })
  Win = require("my.atom._menu.window"):new({
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
  local Layout = layout.build(opts.layout, get_items(ns_id))
  require("my.atom._menu.render").draw(buf, get_items(ns_id), opts.layout)
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
