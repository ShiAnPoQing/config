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

return {
  -- goto last cursor position
  ["<space>["] = {
    "<C-o>",
    "n",
    desc = "Go to [count] Older cursor position in jump list (not a motion command)",
  },
  -- goto new cursor position
  ["<space>]"] = {
    "<C-i>",
    "n",
    desc = "Go to [count] newer cursor position in jump list(not a motion command)",
    noremap = true,
  },
  -- goto last cursor position
  ["<space><space>["] = {
    function()
      jump_buffer(-1, true)
      require("repeat"):set(function()
        jump_buffer(-1, true)
      end)
    end,
    "n",
    desc = "Go to [count] Older cursor position in jump list (not a motion command)",
  },
  -- goto new cursor position
  ["<space><space>]"] = {
    function()
      jump_buffer(1, true)
      require("repeat"):set(function()
        jump_buffer(1, true)
      end)
    end,
    "n",
    desc = "Go to [count] newer cursor position in jump list(not a motion command)",
    noremap = true,
  },
  ["<space>{"] = {
    function()
      jump_buffer(-1)
      require("repeat"):set(function()
        jump_buffer(-1)
      end)
    end,
    "n",
    desc = "Older Jump(buffer)",
  },
  ["<space>}"] = {
    function()
      jump_buffer(1)
      require("repeat"):set(function()
        jump_buffer(1)
      end)
    end,
    "n",
    desc = "Newer Jump(buffer)",
  },
}
