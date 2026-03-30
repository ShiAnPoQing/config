local U = require("eye.core.util")
local Node = require("eye.core.tree.node")
local Extmark = require("eye.core.extmark")
local Config = require("eye.core.config")

--- @class Eye.Leaf.Pending
--- @field spec Eye._LabelSpec
--- @field config Eye.Config.Label

--- @class Eye._LabelSpec
--- @field buf integer
--- @field items Eye.Config.Label.Item[]
--- @field data? table<any>

--- @class Eye.Leaf: Eye.Node
--- @field spec Eye._LabelSpec
--- @field config Eye.Config.Label
local M = setmetatable({}, { __index = Node })
M.__index = M

--- @param targets Eye.Node[]
function M:highlight(targets)
  table.insert(targets, self)
  table.remove(targets, 1)
  --- @param i integer
  --- @param node Eye.Node|Eye.Leaf
  local function hl(i, node)
    for _, item in ipairs(self.spec.items) do
      local label_config = Config.label:proxy(item --[[@as Eye.Config.BaseLabel]], self.config)
      if not label_config.highlight.show_next_key and i ~= 1 then
        return
      end
      Extmark.set({
        line = item.row,
        col = item.col + i - 1,
        text = node.label,
        hl_group = label_config.highlight.group[i] or label_config.highlight.group[#label_config.highlight.group],
        buf = self.spec.buf,
        ns_id = require("eye.core").ns_id,
        virt_text_pos = label_config.extmark.virt_text_pos,
        virt = label_config.extmark.virt,
        right_gravity = label_config.extmark.right_gravity,
      })
    end
  end
  U.try(self.config.highlight.HighlightPre, require("eye.core").ns_id)
  for i, node in ipairs(targets) do
    hl(i, node)
  end
end

--- @param parent Eye.Node|nil
--- @param label string|nil
--- @param remain integer|nil
--- @param leaf_spec Eye.Leaf.Pending
function M:new(parent, label, remain, leaf_spec)
  local o = Node.new(self, parent, label, remain) --[[@as Eye.Leaf]]
  o.level = 0
  o.config = leaf_spec.config
  o.spec = leaf_spec.spec
  return o
end

function M:start()
  local ctx = {
    label = self.label,
    items = vim.tbl_deep_extend("force", {}, self.spec.items or {}),
    buf = self.spec.buf,
    data = vim.tbl_deep_extend("force", {}, self.spec.data or {}),
    matched = true,
  }
  U.try(self.config.matched, ctx)
  self:finish(ctx)
end

return M
