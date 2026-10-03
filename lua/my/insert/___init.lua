local VISUAL = "v"
--- @class my.insert.vmode
--- @field VISUAL my.insert.vmode.VISUAL
--- @field VISUAL_LINE my.insert.vmode.VISUAL_LINE
--- @field VISUAL_BLOCK my.insert.vmode.VISUAL_BLOCK
local M = {
  _submodules = {
    VISUAL = true,
    VISUAL_LINE = true,
    VISUAL_BLOCK = true,
    ["v"] = "VISUAL",
    ["V"] = "VISUAL_LINE",
    [""] = "VISUAL_BLOCK",
  },
}

setmetatable(M, {
  ---@param t table<string, any>
  ---@param k string
  __index = function(t, k)
    if not M._submodules[k] then
      return
    end
    -- alias
    if type(M._submodules[k]) == "string" then
      ---@diagnostic disable-next-line: cast-local-type
      k = M._submodules[k]
    end
    local name = string.format("%s.%s", "my.insert.vmode", k)
    t[k] = require(name)
    return t[k]
  end,
})

function M.first_non_blank()
  local mode = vim.api.nvim_get_mode().mode
  local count = vim.v.count1

  if mode == VISUAL then
    vim.cmd("normal! " .. VISUAL)
    local start_row, start_col = unpack(vim.api.nvim_buf_get_mark(0, "<"))
    vim.api.nvim_win_set_cursor(0, { start_row, start_col })
    vim.api.nvim_feedkeys(count .. "i", "nt", false)
    return
  end
  M[mode].first_non_blank()
end

function M.last_non_blank()
  local mode = vim.api.nvim_get_mode().mode
  local count = vim.v.count1

  if mode == VISUAL then
    vim.cmd("normal! " .. VISUAL)
    local row, col = unpack(vim.api.nvim_buf_get_mark(0, ">"))
    vim.api.nvim_win_set_cursor(0, { row, col })
    vim.api.nvim_feedkeys(count .. "a", "nt", false)
    return
  end
  M[mode].last_non_blank()
end

function M.last()
  local mode = vim.api.nvim_get_mode().mode
  local count = vim.v.count1

  if mode == VISUAL then
    vim.cmd("normal! " .. VISUAL)
    local row, col = unpack(vim.api.nvim_buf_get_mark(0, ">"))
    vim.api.nvim_win_set_cursor(0, { row, col })
    vim.api.nvim_feedkeys(count .. "a", "nt", false)
    return
  end
  M[mode].last()
end

function M.first()
  local mode = vim.api.nvim_get_mode().mode
  local count = vim.v.count1

  if mode == VISUAL then
    vim.cmd("normal! " .. VISUAL)
    local start_row, start_col = unpack(vim.api.nvim_buf_get_mark(0, "<"))
    vim.api.nvim_win_set_cursor(0, { start_row, start_col })
    vim.api.nvim_feedkeys(count .. "i", "nt", false)
    return
  end
  M[mode].first()
end

return M
