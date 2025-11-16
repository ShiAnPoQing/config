local M = {}

--- @class LineConcatOpts
--- @field join_char? string
--- @field trim_blank? boolean
--- @field input? boolean

function M.setup() end

--- @param opts LineConcatOpts
function M.line_concat(opts)
  require("concat-line.core")(opts)
end

return M
