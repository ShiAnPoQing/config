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

--- @param str string
local function get_action_highlights(str)
  local texts = {}
  --- @param s string
  --- @param b integer
  local function search(s, b)
    local start, end_ = s:find("<%w+>", 1)
    if start then
      if start > 1 then
        table.insert(texts, { s:sub(1, start - 1), "Normal" })
      end
      table.insert(texts, { s:sub(start, end_), "Special" })
      search(s:sub(end_ + 1), b + end_)
    else
      table.insert(texts, { s, "Normal" })
    end
  end
  search(str, 0)
  return texts
end

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
      __padding__ = {},
      atom_type = {
        text = function(ctx)
          local text = {}
          local atom = ctx.item --[[@as my.Atom]]
          if #atom.atoms == 0 then
            text[1] = ""
          elseif #atom.atoms > 1 then
            text[1] = "custom"
          else
            text[1] = atom.atoms[1].type
          end
          text[2] = type_highlights["command"]
          return { text }
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
          text = vim.fn.keytrans(text):gsub("<Space>", " "):gsub("<NL>", "<CR>")
          return get_action_highlights(text)
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
