local M = {}

local lock

local jumps_history = {}
local JUMP_NEW_KEY = "<C-i>"
local JUMP_OLD_KEY = "<C-o>"

--- @param direction 1 | -1
--- @param only_current_buf? boolean
local function jump_buffer(direction, only_current_buf)
  local jumplist, current_jump = unpack(vim.fn.getjumplist())
  current_jump = current_jump + 1
  if #jumplist == 0 then
    return
  end
  local current_buf = vim.api.nvim_get_current_buf()
  local jump_key
  local range = {}

  if direction > 0 then
    jump_key = JUMP_NEW_KEY
    if current_jump + 1 > #jumplist then
      return
    end
    range = vim.fn.range(current_jump + 1, #jumplist, 1)
  else
    jump_key = JUMP_OLD_KEY
    range = vim.fn.range(current_jump - 1, 1, -1)
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
      vim.api.nvim_feedkeys(
        tostring(math.abs(i - current_jump)) .. vim.api.nvim_replace_termcodes(jump_key, true, false, true),
        "nx",
        false
      )
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
  else
    jump_buffer(dir, lock)
  end
end

function M.jump_buffer(dir)
  jump_buffer(dir)
end

function M._jump_buffer(dir)
  require("builtin.jump-list.core").jump(dir)
end

return M
