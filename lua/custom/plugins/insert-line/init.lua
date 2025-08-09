local M = {}

--- @class InsertLineOptions
--- @field dir "above" | "below" | "all"
--- @field cursor "keep" | "move"

local default_opts = {
  dir = "below",
  cursor = "keep",
}

--- @param opts InsertLineOptions
function M.insert_line(opts)
  opts = vim.tbl_deep_extend("force", default_opts, opts or {})
  local dir = opts.dir
  local cursor = opts.cursor
  local count = vim.v.count1

  if dir == "all" then
    vim.api.nvim_feedkeys(
      vim.api.nvim_replace_termcodes(count .. "[<space>" .. count .. "]<space>", true, true, true),
      "nm",
      true
    )
    return
  end

  if dir == "above" then
    local key = vim.api.nvim_replace_termcodes("[<space>", true, false, true)
    vim.api.nvim_feedkeys(key, "nm", false)
    if cursor == "move" then
      vim.api.nvim_feedkeys(count .. "k", "n", false)
    end
  elseif dir == "below" then
    local key = vim.api.nvim_replace_termcodes("]<space>", true, false, true)
    vim.api.nvim_feedkeys(key, "nm", false)
    if cursor == "move" then
      vim.api.nvim_feedkeys(count .. "j", "n", false)
    end
  end
end

return M
