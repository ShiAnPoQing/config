--- @class Eye.Label.Config.Hook
--- @field matched? fun(ctx: Eye.Label.Config.Hook.Context)

--- @class Eye.Label.Config.Hook.Context
--- @field matched boolean
--- @field buf integer
--- @field label string
--- @field items Eye.Label.Spec.Item[]
--- @field data table<any>

--- @class Eye.Label.Config.Highlight
--- @field group? string[]|fun(ctx:any):string[]
--- @field show_next_key? boolean
--- @field HighlightPre? fun(ns_id: integer)

--- @class Eye.Label.Config.Extmark
--- @field virt? boolean
--- @field virt_text_pos? "eol" | "eol_right_align" | "overlay" | "right_align" | "inline"
--- @field right_gravity? boolean

--- @class Eye.Label.Spec.Item
--- @field pos [integer, integer]
--- @field extmark? Eye.Label.Config.Extmark
--- @field highlight? Eye.Label.Config.Highlight

--- @class Eye.Label.Spec: Eye.Label.Config.Hook
--- @field buf integer
--- @field items Eye.Label.Spec.Item[]
--- @field data? table<any>
--- @field extmark? Eye.Label.Config.Extmark
--- @field highlight? Eye.Label.Config.Highlight

--- @class Eye.Label._Spec: Eye.Label.Config.Hook
--- @field buf integer
--- @field items Eye.Label.Spec.Item[]
--- @field data? table<any>
--- @field label string

--- @class Eye.Label.Config: Eye.Label.Config.Hook
--- @field include? string[]
--- @field exclude? string[]
--- @field extmark? Eye.Label.Config.Extmark
--- @field highlight? Eye.Label.Config.Highlight

local U = require("eye.core.util")

--- @class Eye.Label
--- @field config Eye.Label.Config
--- @field label Eye.Label._Spec
--- @field bufs {[string]: boolean}
local M = {
  config = {
    exclude = {},
    -- stylua: ignore
    include = { "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", },
    extmark = {
      virt_text_pos = "overlay",
    },
    highlight = {
      group = { "EyeLabel", "EyeNextLabel" },
      show_next_key = true,
    },
  },
}
M.__index = M

--- @class Eye.Label.Extmark.Opt
--- @field buf integer
--- @field ns_id integer
--- @field line integer
--- @field col integer
--- @field text string
--- @field hl_group string
--- @field virt? boolean
--- @field virt_text_pos? "eol" | "eol_right_align" | "overlay" | "right_align" | "inline"
--- @field right_gravity? boolean

--- @param opt Eye.Label.Extmark.Opt
local function set_extmark(opt)
  local line = opt.line
  local col = opt.col
  local ns_id = opt.ns_id
  local extmark_opts = {
    virt_text = { { opt.text, opt.hl_group } },
    hl_mode = "combine",
  }
  if opt.right_gravity ~= nil then
    extmark_opts.right_gravity = opt.right_gravity
  end
  if opt.virt_text_pos ~= nil then
    extmark_opts.virt_text_pos = opt.virt_text_pos
  end
  if opt.virt then
    extmark_opts.virt_text_win_col = col
    pcall(vim.api.nvim_buf_set_extmark, opt.buf, ns_id, line, 0, extmark_opts)
  else
    pcall(vim.api.nvim_buf_set_extmark, opt.buf, ns_id, line, col, extmark_opts)
  end
end

--- @param label Eye.Label._Spec
--- @param config Eye.Label.Config
function M:new(label, config)
  local o = setmetatable({}, self) --[[@as Eye.Label]]
  o.label = {
    buf = label.buf,
    items = label.items,
    data = label.data,
    label = label.label,
  }
  o.config = config
  return o
end

--- @param texts string[]
function M:highlight(texts)
  local ns_id = require("eye.core.tree.root").get_ns_id()
  --- @param i integer
  --- @param text string
  local function hl(i, text)
    for _, item in ipairs(self.label.items) do
      local config = vim.tbl_deep_extend("force", self.config, {
        extmark = item.extmark,
        highlight = item.highlight,
      })
      if not config.highlight.show_next_key and i ~= 1 then
        return
      end
      set_extmark({
        line = item.pos[1],
        col = item.pos[2] + i - 1,
        text = text,
        hl_group = config.highlight.group[i] or config.highlight.group[#config.highlight.group],
        buf = self.label.buf,
        ns_id = ns_id,
        virt_text_pos = config.extmark.virt_text_pos,
        virt = config.extmark.virt,
        right_gravity = config.extmark.right_gravity,
      })
    end
  end
  U.try(self.config.highlight.HighlightPre, ns_id)
  for i, text in ipairs(texts) do
    hl(i, text)
  end
end

function M:matched()
  local ctx = {
    char = self.label.label,
    items = vim.tbl_deep_extend("force", {}, self.label.items or {}),
    buf = self.label.buf,
    data = vim.tbl_deep_extend("force", {}, self.label.data or {}),
  }
  U.try(self.config.matched, ctx)

  return ctx
end

return M
