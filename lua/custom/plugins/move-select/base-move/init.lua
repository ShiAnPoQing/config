local select_block_mode = require("custom.plugins.move-select.base-move.select-block-mode")
local select_mode = require("custom.plugins.move-select.base-move.select-mode")

local M = {}

--- @param dir "left"|"right"
function M.select_move(dir)
  local mode = vim.api.nvim_get_mode().mode

  if mode == "s" then
    select_mode.select_mode_move(dir)
  elseif mode == "" then
    select_block_mode.select_block_mode_move(dir)
  end
end

return M
