--- @class my.profile.promax.motion.VISUAL
--- @field CHAR my.profile.promax.motion.VISUAL.CHAR
--- @field LINE my.profile.promax.motion.VISUAL.LINE
--- @field BLOCK my.profile.promax.motion.VISUAL.BLOCK
--- @field ['v'] my.profile.promax.motion.VISUAL.CHAR
--- @field ['V'] my.profile.promax.motion.VISUAL.LINE
--- @field [''] my.profile.promax.motion.VISUAL.BLOCK
local M = my.util.defer_require("my.profile.promax.motion.VISUAL", {
  CHAR = true,
  LINE = true,
  BLOCK = true,
  ["v"] = "CHAR",
  ["V"] = "LINE",
  [""] = "BLOCK",
})

function M.other_end()
  vim.api.nvim_feedkeys("o", "n", false)
end

function M.other_corner()
  vim.api.nvim_feedkeys("O", "n", false)
end

function M.backward_word_end()
  my.profile.promax.motion.NORMAL.backward_word_end()
end

function M.forward_word_end()
  local visual = vim.fn.getpos("v")
  local col = vim.fn.getpos(".")
  if visual[2] == col[2] and visual[3] == col[3] then
    vim.cmd("normal! e")
    return
  end
  local mode = vim.api.nvim_get_mode().mode
  vim.cmd("normal! e" .. mode .. "l" .. mode)
end

function M.backward_word_start()
  my.profile.promax.motion.NORMAL.backward_word_start()
end

function M.forward_word_start()
  my.profile.promax.motion.NORMAL.forward_word_start()
end

function M.first()
  my.profile.promax.motion.NORMAL.first()
end

function M.last()
  my.profile.promax.motion.NORMAL.last()
end

function M.first_non_blank()
  my.profile.promax.motion.NORMAL.first_non_blank()
end

function M.last_non_blank()
  my.profile.promax.motion.NORMAL.last_non_blank()
end

return M
