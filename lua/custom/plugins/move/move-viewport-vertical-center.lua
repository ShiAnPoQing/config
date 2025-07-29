local M = {}

function M.move_vertical_center(opt)
  local count = vim.v.count1
  opt = opt or {}

  if count == 1 and not opt.one_count then
    vim.api.nvim_feedkeys("M", "nx", false)
  else
    local virt_col = vim.fn.virtcol(".")
    local wininfo = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
    local topline = wininfo.topline
    local botline = wininfo.botline
    local leftcol = wininfo.leftcol
    local line_count = botline - topline + 1
    local center_line_number = math.ceil(line_count / 2) + topline - 1

    vim.api.nvim_feedkeys(center_line_number .. "G", "nx", false)
    vim.api.nvim_feedkeys(count .. "h", "nx", false)
    local left_virt_col = vim.fn.virtcol(".") - leftcol
    vim.api.nvim_feedkeys(2 * count .. "l", "nx", false)
    local right_virt_col = vim.fn.virtcol(".") - leftcol
    vim.api.nvim_feedkeys(count .. "h", "nx", false)

    local ns_id = vim.api.nvim_create_namespace("test")
    local up_line_start = center_line_number - count - 1
    vim.api.nvim_buf_set_extmark(0, ns_id, up_line_start, 0, {
      virt_text = { { "k", "HopNextKey" } },
      virt_text_win_col = virt_col - 1 - leftcol,
    })
    local down_line_start = center_line_number + count - 1
    vim.api.nvim_buf_set_extmark(0, ns_id, down_line_start, 0, {
      virt_text = { { "j", "HopNextKey" } },
      virt_text_win_col = virt_col - 1 - leftcol,
    })
    vim.api.nvim_buf_set_extmark(0, ns_id, center_line_number - 1, 0, {
      virt_text = { { "h", "HopNextKey" } },
      virt_text_win_col = left_virt_col - 1,
    })
    vim.api.nvim_buf_set_extmark(0, ns_id, center_line_number - 1, 0, {
      virt_text = { { "l", "HopNextKey" } },
      virt_text_win_col = right_virt_col - 1,
    })

    vim.schedule(function()
      local char = vim.fn.nr2char(vim.fn.getchar())
      local targets = {
        ["j"] = true,
        ["h"] = true,
        ["l"] = true,
        ["k"] = true,
      }
      if targets[char] then
        vim.api.nvim_feedkeys(count .. char, "nx", false)
      end
      vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)
    end)
  end
end

return M
