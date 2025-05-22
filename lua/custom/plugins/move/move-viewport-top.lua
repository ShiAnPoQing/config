local M = {}


local function magic_move(count)
  local wininfo = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
  local leftcol = wininfo.leftcol
  local topline = wininfo.topline
  local virt_col = vim.fn.virtcol('.')

  vim.api.nvim_feedkeys(count .. "h", "nx", false)
  local left_virt_col = vim.fn.virtcol('.') - leftcol
  vim.api.nvim_feedkeys(2 * count .. "l", "nx", false)
  local right_virt_col = vim.fn.virtcol('.') - leftcol
  vim.api.nvim_feedkeys(count .. "h", "nx", false)

  local ns_id = vim.api.nvim_create_namespace("test")

  vim.api.nvim_buf_set_extmark(0, ns_id, topline - 1, 0, {
    virt_text = { { "h", "HopNextKey" } },
    virt_text_win_col = left_virt_col - 1
  })
  vim.api.nvim_buf_set_extmark(0, ns_id, topline - 1, 0, {
    virt_text = { { "l", "HopNextKey" } },
    virt_text_win_col = right_virt_col - 1
  })

  local down_line_start = topline + count - 1
  vim.api.nvim_buf_set_extmark(0, ns_id, down_line_start, 0, {
    virt_text = { { "j", "HopNextKey" } },
    virt_text_win_col = virt_col - leftcol - 1
  })

  vim.schedule(function()
    local char = vim.fn.nr2char(vim.fn.getchar())
    local targets = {
      ["j"] = true,
      ['h'] = true,
      ['l'] = true
    }

    if targets[char] then
      vim.api.nvim_feedkeys(count .. char, "nx", false)
    end

    vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)
  end)
end


function M.move_viewport_top()
  local count = vim.v.count1
  vim.api.nvim_feedkeys("H", "nx", false)
  if count == 1 then return end
  magic_move(count)
end

return M
