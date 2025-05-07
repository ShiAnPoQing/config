local select_mode = require("custom.plugins.move-select.start-end-move.select-mode")
local select_block_mode = require("custom.plugins.move-select.start-end-move.select-block-mode")

local M = {}

--- @param dir "left"|"right"
function M.select_start_end_move(dir)
  local mode = vim.api.nvim_get_mode().mode

  if mode == "s" then
    select_mode.select_mode_move(dir)
  elseif mode == "" then
    select_block_mode.select_block_mode_move(dir)
  end
end

return M
