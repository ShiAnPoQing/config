--- @class Gaze.Config.Label.Hook
--- @field matched? fun()

--- @class Gaze.Config.Label.Extmark
--- @field virt_text_pos? "eol" | "eol_right_align" | "overlay" | "right_align" | "inline"

--- @class Gaze.Config.Label.Highlight

--- @class Gaze.Config.Label.Item
--- @field row integer
--- @field col integer
--- @field extmark? Gaze.Config.Label.Extmark
--- @field highlight? Gaze.Config.Label.Highlight

--- @class Gaze.Config.Label: Gaze.Config.Label.Hook
--- @field extmark? Gaze.Config.Label.Extmark
--- @field highlight? Gaze.Config.Label.Highlight

--- @class Gaze.Config.Layer

--- @class Gaze.LabelSpec: Gaze.Config.Label
--- @field items Gaze.Config.Label.Item[]
--- @field data? table<any>

--- @class Gaze.Group.Config
--- @field label? Gaze.Config.Label
--- @field layer? Gaze.Config.Layer

--- @class Gaze.RootGroup.Config: Gaze.Group.Config
--- @field start? fun()
--- @field finish? fun()

--- @class Gaze.BufferGroup.Config: Gaze.Group.Config
--- @field buf integer

--- @class Gaze.Group.Groups
--- @field [integer] Gaze.Group|Gaze.LabelSpec

--- @class Gaze.RootGroup.Groups
--- @field [integer] Gaze.BufferGroup

--- @class Gaze.Group: Gaze.Group.Config, Gaze.Group.Groups
--- @class Gaze.RootGroup: Gaze.RootGroup.Config, Gaze.RootGroup.Groups
--- @class Gaze.BufferGroup: Gaze.BufferGroup.Config, Gaze.Group.Groups

--- @class Gaze.Config: Gaze.RootGroup
