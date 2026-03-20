local M = {}

--- @param dir integer
--- @param scope "global" | "buffer"
function M.jump(dir, scope)
  if scope == "global" then
    require("builtin.jump-list.jump").jump_global_scope(dir)
  elseif scope == "buffer" then
    require("builtin.jump-list.jump").jump_buffer_scope(dir)
  end
end

function M.jump_buffer(dir)
  require("builtin.jump-list.jump-buffer").jump(dir)
end

return M
