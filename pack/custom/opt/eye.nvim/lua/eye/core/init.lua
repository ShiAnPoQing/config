--- @class Eye.Gaze
local M = {
  ns_id = vim.api.nvim_create_namespace("eye-namespace"),
}

--- @class Eye.RootGroup.Config.Hook.Context
--- @field matched boolean
--- @field label? string
--- @field items? Eye.Config.Label.Item[]
--- @field buf? integer
--- @field data? table<any>

--- @class Eye.RootGroup.Config.Hook
--- @field start? fun(ctx: Eye.RootGroup.Config.Hook.Context)
--- @field finish? fun(ctx: Eye.RootGroup.Config.Hook.Context)
--- @field completed? fun(ctx: Eye.RootGroup.Config.Hook.Context)
--- @field cancelled? fun(ctx: Eye.RootGroup.Config.Hook.Context)

--- @class Eye.Config.Label.Misc
--- @field include? string[]
--- @field exclude? string[]

--- @class Eye.Config.Label.Hook
--- @field matched? fun(ctx: Eye.Config.Label.Hook.Context)

--- @class Eye.Config.Label.Hook.Context
--- @field label string
--- @field buf integer
--- @field items Eye.Config.Label.Item[]
--- @field data table<any>
--- @field matched boolean

--- @class Eye.Config.Label.Highlight
--- @field group? string[]|fun(ctx:any):string[]
--- @field show_next_key? boolean
--- @field HighlightPre? fun(ns_id: integer)

--- @class Eye.Config.Label.Extmark
--- @field virt? boolean
--- @field virt_text_pos? "eol" | "eol_right_align" | "overlay" | "right_align" | "inline"
--- @field right_gravity? boolean

--- @class Eye.Config.BaseLabel: Eye.Config.Label.Hook
--- @field extmark? Eye.Config.Label.Extmark
--- @field highlight? Eye.Config.Label.Highlight

--- @class Eye.Config.Label.Item
--- @field row integer
--- @field col integer
--- @field extmark? Eye.Config.Label.Extmark
--- @field highlight? Eye.Config.Label.Highlight

--- @class Eye.LabelSpec: Eye.Config.BaseLabel
--- @field items Eye.Config.Label.Item[]
--- @field data? table<any>

--- @class Eye.Config.Label: Eye.Config.BaseLabel, Eye.Config.Label.Misc

--- @class Eye.Group.Config
--- @field label? Eye.Config.Label

--- @class Eye.RootGroup.Config: Eye.Group.Config, Eye.RootGroup.Config.Hook
--- @field layer? Eye.Config.Layer

--- @class Eye.BufferGroup.Config: Eye.Group.Config
--- @field buf integer
--- @field layer? Eye.Config.Layer

--- @class Eye.Group.Groups
--- @field [integer] Eye.LabelSpec|Eye.Group

--- @class Eye.RootGroup.Groups
--- @field [integer] Eye.BufferGroup

--- @class Eye.Group: Eye.Group.Config, Eye.Group.Groups
--- @class Eye.RootGroup: Eye.RootGroup.Config, Eye.RootGroup.Groups
--- @class Eye.BufferGroup: Eye.BufferGroup.Config, Eye.Group.Groups

--- @class Eye.Config: Eye.RootGroup

--- @param config Eye.Config
function M.gaze(config)
  return require("eye.core.tree.root"):new(config)
end

return M
