local M = {}

local Comment = vim.api.nvim_get_hl(0, { name = "Comment" })
vim.api.nvim_set_hl(0, "EyeLayer", { fg = Comment.fg })

local function hl(data)
  vim.api.nvim_buf_set_extmark(0, data.ns_id, data.start_row, 0, {
    end_row = data.end_row,
    hl_group = data.group,
    hl_eol = true,
  })
end

local function get_win(buf)
  local wins = vim.api.nvim_tabpage_list_wins(0)
  local win
  for _, v in ipairs(wins) do
    if vim.api.nvim_win_get_buf(v) == buf then
      win = v
      break
    end
  end
  return win
end

--- @param buf integer
--- @param config Eye._Config._Layer
function M.draw(buf, config)
  local win = get_win(buf)
  if not win then
    return
  end
  local wininfo = vim.fn.getwininfo(win)[1]

  for _, value in ipairs(config.highlight) do
    local group = value.group
    local range = value.range({
      topline = wininfo.topline,
      botline = wininfo.botline,
    })
    hl({
      start_row = range[1],
      end_row = range[2],
      group = group or "EyeLayer",
      ns_id = require("eye.core").ns_id,
      buf = buf,
    })
  end
end

return M
