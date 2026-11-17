--- @class my.ui.Box: my.Instance<my.ui.Box, nil>

--- @class my.ui.Box.Opts
--- @field dir? "col"|"row"
--- @field grow? integer

--- @class my.ui.Class.Box: my.Class<my.ui.Class.Box>
--- @overload fun(boxs: (my.ui.Box|my.ui.Window)[], opts?: my.ui.Box.Opts): my.ui.Box|my.ui.Class.Box
local Box = my.class("my.ui.Box")

local function is_box(obj)
  return obj and obj.boxs
end

local function get_dir(dir)
  dir = dir or "row"
  if not vim.list_contains({ "col", "row" }, dir) then
    dir = "row"
  end
  return dir
end

--- @param self my.ui.Box
--- @param boxs (my.ui.Box|my.ui.Window)[]
--- @param opts? my.ui.Box.Opts
function Box.init(self, boxs, opts)
  opts = opts or {}
  self.dir = get_dir(opts.dir)
  self.grow = opts.grow
  self.config = opts or {}
  self.boxs = boxs

  for _, box in ipairs(boxs) do
    if box:is_instance_of(my.ui.Window) then
    end

    if self.dir == "row" then
    elseif self.dir == "col" then
    end
  end
end

--- @param boxs (my.ui.Box|my.ui.Window)[]
--- @param opts my.ui.Box.Opts
function Box:update(boxs, opts) end

function Box:hide() end

function Box:show() end

function Box:mount() end

function Box:unmount() end

return Box
