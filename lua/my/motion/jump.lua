--- @class my.motion.jump.Opts
--- @field scope? "local"|"global" default global

--- @class my.motion.jump
--- @overload fun(count: integer, opts?: my.motion.jump.Opts)
local M = {}

local last_jump_info

--- @param count integer
--- @return string
local function get_jump_key(count)
  return vim.keycode(count > 0 and "<C-i>" or "<C-o>")
end

local function record_last_jump_info(key)
  local jumplist, last_jump = unpack(vim.fn.getjumplist())
  last_jump_info = {
    jump = jumplist[last_jump + 1],
    key = key,
  }
end

--- @param count integer
--- @param opts? my.motion.jump.Opts
local function jump(count, opts)
  vim.validate("count", count, "number")
  vim.validate("opts", opts, "table", true)
  count = math.floor(count)
  if count == 0 then
    return
  end
  opts = opts or {}
  vim.validate("opts.scope", opts.scope, "string", true)
  local scope = opts.scope == "local" and opts.scope or "global"
  local jump_count
  local jumplist, last_jump = unpack(vim.fn.getjumplist())
  if scope == "global" then
    if count < 0 then
      local current_jump = jumplist[last_jump + 1]
      local cursor = vim.api.nvim_win_get_cursor(0)
      if current_jump and current_jump.lnum ~= cursor[1] and current_jump.lnum ~= cursor[2] then
        vim.cmd("silent! normal! " .. vim.keycode("<C-o><C-i>"))
        count = count + 1
      end
    end
    if jump_count == 0 then
      return
    end
    jump_count = math.abs(count)
  else
    if #jumplist == 0 then
      return
    end
    local current_jump = last_jump + 1
    local buf = vim.api.nvim_get_current_buf()
    local range
    if count > 0 then
      if current_jump > #jumplist then
        return
      end
      range = vim.fn.range(current_jump + 1, #jumplist, 1)
    else
      range = vim.fn.range(current_jump - 1, 1, -1)
    end
    local i = 1
    local jump_idx
    for _, idx in ipairs(range) do
      local j = jumplist[idx]
      if j.bufnr == buf then
        jump_idx = idx
        if i == math.abs(count) then
          break
        end
        i = i + 1
      end
    end
    if jump_idx then
      jump_count = math.abs(jump_idx - current_jump)
    end
  end
  if not jump_count then
    return
  end
  vim.cmd("silent! normal! " .. jump_count .. get_jump_key(count))
  record_last_jump_info(jump_count .. get_jump_key(-count))
end

--- @param count integer
function M.buffer(count)
  vim.validate("count", count, "number")
  count = math.floor(count)
  if count == 0 then
    return
  end
  local jumplist, last_jump = unpack(vim.fn.getjumplist())
  if #jumplist == 0 then
    return
  end
  local current_jump = last_jump + 1
  local buf = vim.api.nvim_get_current_buf()
  local range
  if count > 0 then
    if current_jump > #jumplist then
      return
    end
    range = vim.fn.range(current_jump + 1, #jumplist, 1)
  else
    range = vim.fn.range(current_jump - 1, 1, -1)
  end
  local i = 1
  local jump_idx
  local prev_buf
  for _, idx in ipairs(range) do
    local j = jumplist[idx]
    if j.bufnr ~= buf and j.bufnr ~= prev_buf then
      jump_idx = idx
      if i == math.abs(count) then
        break
      end
      i = i + 1
    end
    prev_buf = j.bufnr
  end
  if not jump_idx then
    return
  end
  vim.cmd("silent! normal! " .. math.abs(jump_idx - current_jump) .. get_jump_key(count))
end

--- @param count integer
function M.jump_prev(count)
  vim.validate("count", count, "number")
  count = math.floor(count)
  if count == 0 then
    return
  end
  if not last_jump_info then
    return
  end
  local jumplist, idx = unpack(vim.fn.getjumplist())
  local current_jump = jumplist[idx + 1]
  local last_jump = last_jump_info.jump
  if
    current_jump and
    current_jump.bufnr == last_jump.bufnr
    and current_jump.col == last_jump.col
    and current_jump.lnum == last_jump.lnum
  then
    vim.cmd("silent normal!" .. last_jump_info.key)
  end
end

---@diagnostic disable-next-line: param-type-mismatch
setmetatable(M, {
  __call = function(_, ...)
    jump(...)
  end,
})

return M
