--- @class my.motion.jump.Opts
--- @field scope? "local"|"global" default global
--- @field count? integer default 1

--- @class my.motion.jump
--- @overload fun(dir: -1|1, opts?: my.motion.jump.Opts)
local M = {}

--- @param dir -1|1
--- @param opts? my.motion.jump.Opts
local function jump(dir, opts)
  vim.validate("dir", dir, "number")
  vim.validate("opts", opts, "table", true)
  if not vim.list_contains({ -1, 1 }, dir) then
    vim.notify(string.format('my.motion.jump: "dir" must be -1 or 1, but got %d', dir), vim.log.levels.ERROR)
    return
  end
  opts = opts or {}
  vim.validate("opts.scope", opts.scope, "string", true)
  vim.validate("opts.count", opts.count, "number", true)
  local count = opts.count or 1
  local scope = opts.scope == "local" and opts.scope or "global"
  if scope == "global" then
    local jump_key
    if dir > 0 then
      jump_key = vim.keycode("<C-i>")
    else
      jump_key = vim.keycode("<C-o>")
    end
    vim.cmd("silent! normal! " .. count .. jump_key)
    return
  end
  local jumplist, current_jump = unpack(vim.fn.getjumplist())
  if #jumplist == 0 then
    return
  end
  vim.print(#jumplist, current_jump)
  -- current_jump = current_jump + 1
  -- local buf = vim.api.nvim_get_current_buf()
  -- local range
  -- if dir > 0 then
  --   if current_jump + 1 > #jumplist then
  --     return
  --   end
  --   range = vim.fn.range(current_jump + 1, #jumplist, 1)
  -- else
  --   range = vim.fn.range(current_jump - 1, 1, -1)
  -- end
  --
  -- local jump_idx
  -- local i = 1
  -- for _, idx in ipairs(range) do
  --   if jumplist[idx].bufnr == buf then
  --     if i == count then
  --       break
  --     end
  --     i = i + 1
  --     jump_idx = idx
  --   end
  -- end
  -- if not jump_idx then
  --
  -- end
end

---@diagnostic disable-next-line: param-type-mismatch
setmetatable(M, {
  __call = function(_, ...)
    jump(...)
  end,
})

return M
