local M = {}
local api = vim.api
local Key = require("magic.key")
local Line_hl = require("magic.line-hl")

function M.magic_visual_mode(opts)
  local mode = vim.api.nvim_get_mode().mode
  if mode == "s" or mode == "v" then
    M.visual_mode_move(opts)
  elseif mode == "" or mode == "" then
    -- require("visual-move.base-move.visual-block-mode").visual_block_mode_move(dir)
  end
end

function M.visual_mode_move(opts)
  local wininfo = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
  local topline = wininfo.topline
  local botline = wininfo.botline
  local virt_col = -wininfo.textoff

  local key = Key:init()
  key.compute(botline - topline + 1)
  for line = topline, botline do
    key.register({
      callback = function() end,
      one_key = {
        line = line - 1,
        virt_col = virt_col,
      },
      two_key = {
        line = line - 1,
        virt_col = virt_col,
      },
    })
  end

  key.on_key({
    unmatched_callback = function()
      Line_hl:del_hl()
    end,
    matched_callback = function()
      Line_hl:del_hl()
    end,
  })
end

return M
