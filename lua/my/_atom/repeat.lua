--- @class my._atom.repeat
local M = {}

local enabled
local ns_id
--- @type integer
local last_id

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
    my._atom.on("CmdAtomBefore", function()
      Capturer:start()
    end)
    my._atom.on("CmdAtomAfter", function()
      Capturer:stop(function(atom)
        local first_atom = atom.atoms[1]
        local is_redo_or_undo = first_atom.changed and (first_atom.undoseq or 0) <= (vim.b[first_atom.buf].maxseq or 0)
        vim.b[first_atom.buf].maxseq = math.max(vim.b[first_atom.buf].maxseq or 0, first_atom.undoseq or 0)
        if first_atom.lhs ~= "." and first_atom.changed == true and not is_redo_or_undo then
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
  end
end

return M
