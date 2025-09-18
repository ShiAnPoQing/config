local M = {}

--- @class InsertLineOptions
--- @field dir "above" | "below" | "all"
--- @field cursor "keep" | "move"
--- @field indent? boolean

local default_opts = {
  dir = "below",
  cursor = "keep",
  indent = true,
}

--- @param opts InsertLineOptions
function M.insert_line(opts)
  local modifable = vim.api.nvim_get_option_value("modifiable", {
    buf = vim.api.nvim_get_current_buf(),
  })
  if modifable == false then
    vim.notify("Buffer is not modifiable", vim.log.levels.WARN)
    return
  end

  opts = vim.tbl_deep_extend("force", default_opts, opts or {})
  local dir = opts.dir
  local cursor = opts.cursor
  local count = vim.v.count1
  local mode = vim.api.nvim_get_mode().mode

  if mode ~= "n" then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
  end

  if dir == "all" then
    vim.api.nvim_feedkeys(
      vim.api.nvim_replace_termcodes(count .. "[<space>" .. count .. "]<space>", true, true, true),
      "nm",
      true
    )
  end

  if dir == "above" then
    local key = vim.api.nvim_replace_termcodes(count .. "[<space>", true, false, true)
    vim.api.nvim_feedkeys(key, "nm", false)
    if cursor == "move" then
      vim.api.nvim_feedkeys(count .. "k", "n", false)
    end
  elseif dir == "below" then
    local key = vim.api.nvim_replace_termcodes(count .. "]<space>", true, false, true)
    vim.api.nvim_feedkeys(key, "nm", false)
    if cursor == "move" then
      vim.api.nvim_feedkeys(count .. "j", "n", false)
    end
  end

  if mode == "i" then
    if dir == "all" then
      return vim.api.nvim_feedkeys("a", "n", false)
    end

    local key = "A"
    if opts.indent then
      key = key .. vim.api.nvim_replace_termcodes("<C-f>", true, false, true)
    end
    key = key .. vim.api.nvim_replace_termcodes("<C-g>u", true, false, true)
    vim.api.nvim_feedkeys(key, "n", false)
  end
end

return M
