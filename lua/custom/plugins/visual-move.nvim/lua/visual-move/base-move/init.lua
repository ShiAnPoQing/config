local M = {}

--- @param dir "left"| "right"
function M.visual_move(dir)
  local mode = vim.api.nvim_get_mode().mode
  if mode == "s" or mode == "v" then
    require("visual-move.base-move.visual-mode").visual_mode_move(dir)
  elseif mode == "" or mode == "" then
    require("visual-move.base-move.visual-block-mode").visual_block_mode_move(dir)
  end
end

return M
