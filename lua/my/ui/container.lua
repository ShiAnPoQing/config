--- @alias my.ui.Container.Name "cursor"|"editor"|"laststatus"|"mouse"|"tabline"

--- @class my.ui.Class.Container
--- @overload fun(): my.ui.Container

--- @class my.ui.Container
--- @field name string
--- @field size my.ui.Size
--- @diagnostic disable-next-line: assign-type-mismatch
local Container = my.class("my.ui.Container")

--- @param name my.ui.Container.Name
function Container:init(name)
  self.name = name
  vim.api.nvim_create_autocmd("VimResized", {
    callback = function()
      self:_update_size()
    end,
  })
  self:_update_size()
end

function Container:_update_size()
  self.size = {
    width = vim.o.columns,
    height = vim.o.lines,
  }
end

--- @param ui my.ui.Window|my.ui.Box
--- @param position {row?: number|string, col?:number|string, anchor?: "NW"|"NE"|"SW"|"SE"}
function Container:_compute_layout(ui, position)
  ui.parent = self
  ui.size = my.ui.util.compute_size(ui.pending.size, self.size)
  ui.position = my.ui.util.compute_position(my.ui.util.normalize_postion(position), {
    row = 0,
    col = 0,
    relative = self.name,
  }, self.size)

  if ui:is_instance_of(my.ui.Box) then
    ui = ui --[[@as my.ui.Box]]
    ui:_compute_layout()
  end
end

--- @param ui my.ui.Window|my.ui.Box
--- @param position {row?: number|string, col?:number|string, anchor?: "NW"|"NE"|"SW"|"SE"}
function Container:place(ui, position)
  vim.validate("position", position, "table")
  self:_compute_layout(ui, position)
  ui:mount()
end

return Container --[[@as my.ui.Class.Container]]
