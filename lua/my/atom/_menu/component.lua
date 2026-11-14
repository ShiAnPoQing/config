--- @class my.atom._menu.component
--- @field private component my.atom._menu.Opts.Layout.Component
local M = {}
M.__index = M

--- @param component my.atom._menu.Opts.Layout.Component
--- @return my.atom._menu.component
function M.create(component)
  local o = setmetatable({}, M)
  o.component = component
  return o
end

--- @class my.atom._menu.component.build.Config
--- @field ctx any

--- @param pos [integer, integer]
--- @param context any
function M:build(pos, context)
  local component = self.component
  self.built = true

  local texts = type(component.text) == "function" and component.text(context) or {}
  local text = ""
  local highlights = {}

  local base = pos[2]
  for _, t in ipairs(texts) do
    local _text = t[1]
    text = text .. _text
    table.insert(highlights, { { pos[1], base }, { pos[1], base + #_text }, t[2] })
    base = base + #_text
  end

  if component.width then
    local width = component.width
    local text_width = #text
    width.min = width.min or text_width
    width.max = width.max or width.min
    if width.min > text_width then
      text = text .. string.rep(" ", width.min - text_width)
    end
    if width.max < text_width then
      text = text:sub(1, width.max)
    end
  end
  self.range = { { pos[1], pos[2] }, { pos[1], pos[2] + #text } }
  self.text = text
  self.highlight = highlights
end

function M:hover() end

function M:click() end

function M:get_text()
  if self.built then
    return self.text
  end
end

function M:get_highlight()
  if self.built then
    return self.highlight
  end
end

return M
