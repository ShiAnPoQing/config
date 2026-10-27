--- @class my.atom.repeat
local M = {}

--- @class my.atom.repeat.set_repeat.Opts
--- @field noremap? boolean

local enbaled
--- @type integer
local ns_id
--- @type integer
local current_id
--- @type integer
local last_id

local patch = function(data)
  if (data.type == "operator" or data.type == "visual") and data.keys:find("g@") then
    data.keys =
      data.keys:gsub("g@", vim.keycode("<cmd>lua my.operator._pending_delete_({ reg = vim.v.register })<cr>") .. "g@")
  end
  return data
end

--- @param callback fun()|string
--- @param opts? my.atom.repeat.set_repeat.Opts
function M.set_repeat(callback, opts)
  vim.validate("callback", callback, { "string", "function" })
  vim.validate("opts", opts, "table", true)
  opts = opts or {}
  local noremap = opts.noremap
  if type(callback) == "string" then
    -- my.atom[ns_id].start({ patch = patch })
    vim.api.nvim_feedkeys(callback, noremap and "ni" or "mi", false)
    -- vim.api.nvim_feedkeys(vim.keycode("<cmd>lua my['repeat']._capture.finish()<cr>"), "nt", false)
  elseif type(callback) == "function" then
    callback()
  end
end

local function init()
  ns_id = vim.api.nvim_create_namespace("my.atom.repeat")

  my.atom.on("AtomBefore", function()
    current_id = my.atom[ns_id].create({ patch = patch })
    my.atom[ns_id].start(current_id)
  end)

  my.atom.on("AtomAfter", function()
    my.atom[ns_id][current_id].stop()
    local atoms = my.atom[ns_id][current_id].get()
    local atom = atoms[1]
    local is_redo_or_undo = atom.data.changed and (atom.data.undoseq or 0) <= (vim.b[atom.buf].maxseq or 0)
    vim.b[atom.buf].maxseq = math.max(vim.b[atom.buf].maxseq or 0, atom.data.undoseq or 0)
    if not (atom.data.keys ~= "." and atom.data.changed == true and not is_redo_or_undo) then
      my.atom[ns_id].del(current_id)
    else
      last_id = current_id
    end
  end)

  vim.keymap.set("n", ".", function()
    vim.schedule(function()
      if not last_id then
        return
      end
      my.atom.replay(ns_id, last_id)
    end)
  end)
end

--- @param enable boolean?
function M.enable(enable)
  enable = enable ~= false
  if enable == enbaled then
    return
  end
  enbaled = enable
  if enable then
    if not my.atom.is_enabled() then
      my.atom.enable()
    end
    init()
  else
    vim.keymap.del("n", ".")
    -- my.atom[ns_id].del()
  end
end

return M
