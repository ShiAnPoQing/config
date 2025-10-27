local M = {}

local lock

--- @param direction 1 | -1
--- @param only_current_buf? boolean
local function jump_buffer(direction, only_current_buf)
  local jumplist, current_jump = unpack(vim.fn.getjumplist())
  if #jumplist == 0 then
    return
  end
  local current_buf = vim.api.nvim_get_current_buf()
  local jump_key
  local range = {}

  if direction > 0 then
    jump_key = "<C-i>"
    if current_jump + 2 > #jumplist then
      return
    end
    range = vim.fn.range(current_jump + 2, #jumplist, 1)
  else
    jump_key = "<C-o>"
    range = vim.fn.range(current_jump, 1, -1)
  end

  local condition = function(bufnr)
    if only_current_buf then
      return bufnr == current_buf
    else
      return bufnr ~= current_buf
    end
  end

  for _, i in ipairs(range) do
    local bufnr = jumplist[i].bufnr
    if condition(bufnr) then
      local count = tostring(math.abs(i - current_jump - 1))
      vim.api.nvim_feedkeys(count .. vim.api.nvim_replace_termcodes(jump_key, true, false, true), "nx", false)
      break
    end
  end
end

function M.switch_lock(dir)
  lock = not lock
  M.jump(dir)
end

function M.jump(dir)
  if not lock then
    if dir == -1 then
      vim.api.nvim_feedkeys(vim.v.count1 .. vim.api.nvim_replace_termcodes("<C-o>", true, false, true), "nx", false)
    elseif dir == 1 then
      vim.api.nvim_feedkeys(vim.v.count1 .. vim.api.nvim_replace_termcodes("<C-i>", true, false, true), "nx", false)
    end
    return
  end

  jump_buffer(dir, lock)
end

function M.jump_buffer(dir)
  jump_buffer(dir)
end

return M
