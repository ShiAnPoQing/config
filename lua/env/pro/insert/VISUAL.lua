--- @class my.env.pro.insert.VISUAL
--- @field CHAR my.env.pro.insert.VISUAL.CHAR
--- @field LINE my.env.pro.insert.VISUAL.LINE
--- @field BLOCK my.env.pro.insert.VISUAL.BLOCK
local M = my.util.defer_require(..., {
  CHAR = ..., --- @module 'my.env.pro.insert.VISUAL.CHAR'
  LINE = ..., --- @module 'my.env.pro.insert.VISUAL.LINE'
  BLOCK = ..., --- @module 'my.env.pro.insert.VISUAL.BLOCK'
  ["v"] = "CHAR", --- @module 'my.env.pro.insert.VISUAL.CHAR'
  ["V"] = "LINE",
  ["\22"] = "BLOCK",
})

function M.first()
  M[vim.api.nvim_get_mode().mode].first()
end

function M.last()
  M[vim.api.nvim_get_mode().mode].last()
end

function M.first_non_blank()
  M[vim.api.nvim_get_mode().mode].first_non_blank()
end

function M.last_non_blank()
  M[vim.api.nvim_get_mode().mode].last_non_blank()
end

return M
