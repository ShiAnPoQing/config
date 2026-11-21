--- @class my.ui.Box.Opts
--- @field dir? "col"|"row"
--- @field grow? integer
--- @field size? number|string|my.ui.Opts.Size

--- @class my.ui.Box: my.Instance<my.ui.Box, nil>
--- @field mounted boolean
--- @field parent? my.ui.Box|my.ui.Container
--- @field children (my.ui.Box|my.ui.Window)[]
--- @field size my.ui.Size
--- @field position my.ui.Position
--- @field pending my.ui.Pending
local Box = my.class("my.ui.Box")
--[[
 local box = my.ui.Box({
   { component = component }
 })
 local box1 = my.ui.Box({
   { component = component1, grow = 1 },
   { component = component2, grow = 2 },
   { component = box, grow = 2}
 })
 my.ui.editor:place(box1, { row = 0, col = 0, grow = 1})
--]]

--- @param dir "col"|"row"
local function get_dir(dir)
  dir = dir or "row"
  if not vim.list_contains({ "col", "row" }, dir) then
    dir = "row"
  end
  return dir
end

--- @param boxs (my.ui.Window|my.ui.Box)[]
--- @param opts my.ui.Box.Opts
function Box:init(boxs, opts)
  opts = opts or {}
  self.dir = get_dir(opts.dir)
  self.grow = opts.grow
  ---@diagnostic disable-next-line: missing-fields
  self.win_config = {}
  self.children = boxs or {}
  self.pending = { size = my.ui.util.normalize_size(opts.size) }
  for _, box in ipairs(self.children) do
    if box:is_instance_of(my.ui.Window) then
      local window = box --[[@as my.ui.Window]]
      window.parent = self
    elseif box:is_instance_of(my.ui.Box) then
      box = box --[[@as my.ui.Box]]
      box.parent = self
    end
  end
end

function Box:_compute_layout()
  local relative = self.position.relative
  local dir = self.dir
  local base = self.position[self.dir]
  for _, component in ipairs(self.children) do
    local size = my.ui.util.compute_size(component.pending.size, self.size)
    -- component.pending.size = nil
    local position = { row = 0, col = 0, relative = relative }
    position[dir] = base
    local w = size[dir == "row" and "height" or "width"]
    base = base + (w and w or 0)
    component.size = size
    component.position = position
    if component:is_instance_of(my.ui.Box) then
      component = component --[[@as my.ui.Box]]
      component:_compute_layout()
    end
  end
end

--- @param boxs (my.ui.Box|my.ui.Window)[]
--- @param opts my.ui.Box.Opts
function Box:update(boxs, opts) end

function Box:hide() end

function Box:show() end

function Box:mount()
  for _, child in ipairs(self.children) do
    child:mount()
  end
end

function Box:unmount() end

--- @class my.ui.Class.Box: my.Class<my.ui.Class.Box>
--- @overload fun(boxs: (my.ui.Box|my.ui.Window)[], opts?: my.ui.Box.Opts): my.ui.Box

return Box --[[@as my.ui.Class.Box]]
