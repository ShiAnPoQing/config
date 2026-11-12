local component = require("my._atom._menu.component")

--- @class my._atom._menu.layout
local M = {}

--- @alias my._atom._menu.Layout.ColNode table

--- @alias my._atom._menu.Layout.LineNode my._atom._menu.Layout.ColNode[]

--- @class my._atom._menu.Layout.Opts
--- @field columns? string[][]
--- @field components? table<string, my._atom._menu.Opts.Layout.Component>

--- @param config my._atom._menu.Opts.Layout
--- @param items my.Atom[]
--- @return my._atom._menu.Layout.LineNode[]
function M.build(config, items)
  local layout = {}
  local padding = config.padding or { 0, 0 }
  if type(padding) == "number" then
    padding = { padding, padding }
  end
  for i, item in ipairs(items) do
    local line_node = {}
    layout[#layout + 1] = line_node
    table.insert(layout, line_node)
    table.insert(config.columns, 1, { "__padding__" })
    table.insert(config.columns, { "__padding__" })
    local context = { idx = i, item = item }
    local components = config.components
    local column_gap = config.columns.gap
    for _, span in ipairs(config.columns) do
      local span_gap = span.gap
      for s_i, name in ipairs(span) do
        local Component = component.create(components[name])
        Component:build({ context.idx, 0 }, context)
        vim.print(name)
        table.insert(line_node, Component)
      end
      if column_gap > 0 then
        table.insert(config.columns)
      end
    end
  end
  return layout
end


return M
