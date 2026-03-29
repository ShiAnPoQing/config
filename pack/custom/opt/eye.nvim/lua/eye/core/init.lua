--- @class Eye.Gaze
local M = {
  ns_id = vim.api.nvim_create_namespace("eye-namespace"),
}

--- @class Eye.Config.Hook.Context
--- @field matched boolean
--- @field label? string
--- @field items? Eye.Config.Label.Item[]
--- @field buf? integer
--- @field data? table<any>

--- @class Eye.Config.Hook: Eye.Config.Label.Hook
--- @field start? fun(ctx: Eye.Config.Hook.Context)
--- @field stop? fun(ctx: Eye.Config.Hook.Context)

--- @class Eye.Config.Label.Misc
--- @field include? string[]
--- @field exclude? string[]

--- @class Eye.Config.Label.Hook
--- @field matched? fun(ctx: Eye.Config.Label.Hook.Context)
--- @field unmatched? fun(ctx: Eye.Config.Label.Hook.Context)

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

--- @class Eye.Config.LabelBase: Eye.Config.Hook
--- @field extmark? Eye.Config.Label.Extmark
--- @field highlight? Eye.Config.Label.Highlight

--- @class Eye.Config.Label.Item
--- @field row integer
--- @field col integer
--- @field extmark? Eye.Config.Label.Extmark
--- @field highlight? Eye.Config.Label.Highlight

--- @class Eye.Config.Label: Eye.Config.LabelBase, Eye.Config.Label.Misc

--- @class Eye.LabelSpec: Eye.Config.LabelBase
--- @field items Eye.Config.Label.Item[]
--- @field data? table<any>

--- @class Eye.ConfigBase: Eye.Config.Hook
--- @field label? Eye.Config.Label
--- @field layer? Eye.Config.Layer

--- @class Eye.BufferConfig: Eye.ConfigBase
--- @field buf integer
--- @field source Eye.LabelSpec[]

--- @class Eye.Config: Eye.ConfigBase
--- @field source Eye.BufferConfig[]

--- @param spec Eye.Config
function M.gaze(spec)
  return require("eye.core.tree.root"):new(spec)
end

return M
