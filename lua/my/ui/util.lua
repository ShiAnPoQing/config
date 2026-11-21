--- @class my.ui.util
local M = {}

--- @param str string
--- @return string|nil
local function get_percentage_string(str)
  if vim.endswith(str, "%") then
    str = str:sub(1, -2)
  end
  if type(tonumber(str)) == "number" then
    return str
  end
end

--- @param size number|string|my.ui.Opts.Size|nil
--- @return my.ui.Pending.Size
function M.normalize_size(size)
  size = size or {}
  local normalized_size = {}
  if type(size) == "table" then
    normalized_size.width = size.width
    normalized_size.height = size.height
  else
    normalized_size.width = size
    normalized_size.height = size
  end
  for key, value in pairs(normalized_size) do
    if value then
      if type(value) == "number" then
        value = math.floor(math.max(value, 0))
      elseif type(value) == "string" then
        value = get_percentage_string(value)
      else
        value = nil
      end
      normalized_size[key] = value
    end
  end
  return normalized_size
end

--- @param position my.ui.Opts.Position
--- @return my.ui.Pending.Position
function M.normalize_postion(position)
  local normalized_position = {
    row = position.row,
    col = position.col,
  }
  for key, value in pairs(normalized_position) do
    if type(value) == "number" then
      value = math.floor(math.max(value, 0))
    elseif type(value) == "string" then
      ---@diagnostic disable-next-line: cast-local-type
      value = get_percentage_string(value)
      if not value then
        value = 0
      end
    else
      value = 0
    end
    normalized_position[key] = value
  end
  return normalized_position
end

--- @param size my.ui.Pending.Size
--- @param container_size my.ui.Size
--- @return my.ui.Size
function M.compute_size(size, container_size)
  local computed_size = {}

  for _, field in ipairs({ "width", "height" }) do
    local value = size[field]
    local container_value = container_size[field]
    if not container_value then
      value = nil
    else
      if type(value) == "string" then
        value = container_size[field] * tonumber(value) / 100
      end
      if type(value) == "number" then
        computed_size[field] = math.floor(value)
      end
    end
  end

  return computed_size
end

--- @param position my.ui.Pending.Position
--- @param container_position my.ui.Position
--- @param container_size my.ui.Size
--- @return my.ui.Position
function M.compute_position(position, container_position, container_size)
  local computed_position = { relative = container_position.relative }

  for _, field in ipairs({ "row", "col" }) do
    local value = position[field]
    if type(value) == "string" then
      value = math.floor(container_size[field == "row" and "height" or "width"] * tonumber(value) / 100)
    end
    computed_position[field] = value + container_position[field]
  end

  return computed_position
end

return M
