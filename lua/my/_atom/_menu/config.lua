--- @class my._atom._menu.config
local M = {}

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

--- @type my._atom._menu.Opts
local default_config = {
  window = {
    height = 12,
  },
  layout = {
    columns = {
      { "atom_type", "atom_action", gap = 4 },
    },
    components = {
      atom_type = {
        text = function(ctx)
          local atom = ctx.item --[[@as my.Atom]]
          if #atom.atoms == 0 then
            return ""
          end
          if #atom.atoms > 1 then
            return "custom"
          end
          return atom.atoms[1].type
        end,
        highlight = function(ctx)
          local atom = ctx.item --[[@as my.Atom]]
          if #atom.atoms == 0 then
            return type_highlights["command"]
          end
          if #atom.atoms > 1 then
            return type_highlights["insert"]
          end
          return type_highlights[atom.atoms[1].type]
        end,
        width = {
          min = 8,
        },
      },
      atom_action = {
        text = function(ctx)
          local atom = ctx.item --[[@as my.Atom]]
          local text = ""
          for _, cmdatom in ipairs(atom.atoms) do
            text = text .. (cmdatom.keys or cmdatom.lhs)
          end
          text = vim.fn.keytrans(text):gsub("<Space>", " ")
          return text
        end,
        highlight = function()
          return "Normal"
        end,
      },
    },
    padding = 4,
  },
}

--- @param config my._atom._menu.Opts
function M.merge(config)
  return vim.tbl_deep_extend("force", default_config, config)
end

return M
