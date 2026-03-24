local U = require("eye.core.util")
local Node = require("eye.core.tree.node")
local Extmark = require("eye.core.extmark")
local Config = require("eye.core.config")

--- @class Eye.Leaf: Eye.Node
--- @field spec Eye.LabelSpec
--- @field config Eye._Config._Label
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
      ---@diagnostic disable-next-line: param-type-mismatch
      local config = Config.label:proxy(Config.label:normalize(item), self.config)
      if not config.highlight.show_next_key and i ~= 1 then
        return
      end
      Extmark.set({
        line = item.row,
        col = item.col + i - 1,
        text = node.label,
        hl_group = config.highlight.group[i] or config.highlight.group[#config.highlight.group],
        buf = self.spec.buf,
        ns_id = require("eye.core").ns_id,
        virt_text_pos = config.extmark.virt_text_pos,
        virt = config.extmark.virt,
        right_gravity = config.extmark.right_gravity,
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
--- @param source Eye.LabelSpec
--- @param remain integer|nil
--- @param config Eye._Config
function M:new(parent, label, source, remain, config)
  local o = Node.new(self, parent, label, remain) --[[@as Eye.Leaf]]
  o.level = 0
  ---@diagnostic disable-next-line: param-type-mismatch, missing-fields
  o.config = Config.label:proxy(Config.label:normalize(source), config.label)
  o.spec = {
    data = source.data,
    items = source.items,
    buf = source.buf,
  }
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
  U.try(self.config.hook.matched or self:find_root().config.hook.matched, ctx)
  self:stop(ctx)
end

return M
