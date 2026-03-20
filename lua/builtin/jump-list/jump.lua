local Shared = require("builtin.jump-list.shared")

local M = {}

function M.jump_buffer_scope(direction)
  local count = vim.v.count1
  local jumplist, current_jump = unpack(vim.fn.getjumplist())
  if #jumplist == 0 then
    return
  end
  current_jump = current_jump + 1
  local current_buf = vim.api.nvim_get_current_buf()
  local jump_key
  local range = {}

  if direction > 0 then
    jump_key = Shared.JUMP_NEW_KEY
    if current_jump + 1 > #jumplist then
      return
    end
    range = vim.fn.range(current_jump + 1, #jumplist, 1)
  else
    jump_key = Shared.JUMP_OLD_KEY
    range = vim.fn.range(current_jump - 1, 1, -1)
  end

  local jump_index
  local prev_jump_index
  for _, index in ipairs(range) do
    local bufnr = jumplist[index].bufnr
    if count > 0 then
      if bufnr == current_buf then
        count = count - 1
        prev_jump_index = index
      end
    elseif count == 0 then
      jump_index = prev_jump_index
      break
    end
  end

  if not jump_index then
    jump_index = prev_jump_index
  end
  if jump_index and jump_index > 0 then
    local c = math.abs(jump_index - current_jump) .. jump_key
    vim.api.nvim_feedkeys(c, "nx", false)
  end
end

function M.jump_global_scope(direction)
  local count = vim.v.count1
  local jump_key
  if direction > 0 then
    jump_key = Shared.JUMP_NEW_KEY
  else
    jump_key = Shared.JUMP_OLD_KEY
  end
  vim.api.nvim_feedkeys(count .. jump_key, "nx", false)
end

return M
