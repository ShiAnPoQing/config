--- @class my.insert
--- @field NORMAL my.insert.NORMAL
--- @field VISUAL my.insert.VISUAL
--- @field VISUAL_LINE my.insert.VISUAL_LINE
--- @field VISUAL_BLOCK my.insert.VISUAL_BLOCK
--- @field ['n'] my.insert.NORMAL
--- @field ['v'] my.insert.VISUAL
--- @field ['V'] my.insert.VISUAL_LINE
--- @field [''] my.insert.VISUAL_BLOCK
local M = my.util.defer_require("my.insert", {
  VISUAL = true,
  VISUAL_LINE = true,
  VISUAL_BLOCK = true,
  NORMAL = true,
  ["n"] = "NORMAL",
  ["v"] = "VISUAL",
  ["V"] = "VISUAL_LINE",
  [""] = "VISUAL_BLOCK",
})

function M.first()
  my.insert[my.util.get_mode()].first()
end

function M.last()
  my.insert[my.util.get_mode()].last()
end

function M.first_non_blank()
  my.insert[my.util.get_mode()].first_non_blank()
end

function M.last_non_blank()
  my.insert[my.util.get_mode()].last_non_blank()
end

return M
