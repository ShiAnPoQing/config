local M = {}

function M:create(buf, position)
  if position == "float" then
    return require("neo-buffer.window.float").create(self, buf)
  else
    return require("neo-buffer.window.split").create(self, buf, position)
  end
end

function M:update(position)
  if position == "float" then
    return require("neo-buffer.window.float").update(self)
  else
    return require("neo-buffer.window.split").update(self)
  end
end

return M
