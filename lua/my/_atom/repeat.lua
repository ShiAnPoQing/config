--- @class my._atom.repeat
local M = {}

local enabled
--- @type integer
local ns_id, last_id, CmdAtomBefore, CmdAtomAfter

--- @param sequenue string
function M.set_repeat(sequenue)
  vim.validate("sequenue", sequenue, "string")
  my._atom.feed(sequenue, function(atom)
    last_id = my._atom.create(ns_id, atom)
  end)
end

--- @param atom my.Atom
--- @return boolean
local function is_repeat_atom(atom)
  local first_atom = atom.atoms[1]
  local is_redo_or_undo = first_atom.changed and (first_atom.undoseq or 0) <= (vim.b[first_atom.buf].maxseq or 0)
  vim.b[first_atom.buf].maxseq = math.max(vim.b[first_atom.buf].maxseq or 0, first_atom.undoseq or 0)
  return first_atom.lhs ~= "." and first_atom.changed == true and not is_redo_or_undo
end

--- @param enable boolean|nil
function M.enable(enable)
  vim.validate("enable", enable, "boolean", true)
  enable = enable ~= false
  if enabled == enable then
    return
  end
  enabled = enable
  if enable then
    ns_id = vim.api.nvim_create_namespace("my.atom.repeat")
    local Capturer = my._atom.capturer({
      patch = function(cmdAtom)
        if (cmdAtom.type == "operator" or cmdAtom.type == "visual") and cmdAtom.keys and cmdAtom.keys:find("g@") then
          cmdAtom.keys = cmdAtom.keys:gsub(
            "g@",
            vim.keycode("<cmd>lua my.operator._pending_delete_({ reg = vim.v.register })<cr>") .. "g@"
          )
        end
        return cmdAtom
      end,
    })
    CmdAtomBefore = my._atom.on("CmdAtomBefore", function()
      Capturer:start()
    end)
    CmdAtomAfter = my._atom.on("CmdAtomAfter", function()
      Capturer:stop(function(atom)
        if is_repeat_atom(atom) then
          last_id = my._atom.create(ns_id, atom)
        end
      end)
    end)

    vim.keymap.set("n", ".", function()
      vim.schedule(function()
        if not last_id then
          return
        end
        my._atom.replay(ns_id, last_id)
      end)
    end)
  else
    ---@diagnostic disable-next-line: cast-local-type
    ns_id = nil
    last_id = nil
    vim.api.nvim_del_autocmd(CmdAtomBefore)
    vim.api.nvim_del_autocmd(CmdAtomAfter)
    CmdAtomAfter = nil
    CmdAtomBefore = nil
    pcall(vim.keymap.del, "n", ".")
  end
end

return M
