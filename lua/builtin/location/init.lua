local M = {}

function M.goto_next_location()
  local fq = vim.fn.getloclist(0, { idx = 0, size = 0 })
  local current_idx = fq.idx
  local total = fq.size
  local count = vim.v.count1

  local ok
  if current_idx < total then
    ---@diagnostic disable-next-line: param-type-mismatch
    ok = pcall(vim.cmd, count .. "lnext")
  else
    ---@diagnostic disable-next-line: param-type-mismatch
    ok = pcall(vim.cmd, "lfirst")
  end
  if ok then
    vim.cmd("normal! zz")
  else
    vim.api.nvim_echo({ { "No more location list", vim.log.levels.WARN } }, true, {})
  end
end

function M.goto_prev_location()
  local current_idx = vim.fn.getloclist(0, { idx = 0 }).idx
  local count = vim.v.count1

  local ok
  if current_idx > 1 then
    ---@diagnostic disable-next-line: param-type-mismatch
    ok = pcall(vim.cmd, count .. "lprev")
  else
    ---@diagnostic disable-next-line: param-type-mismatch
    ok = pcall(vim.cmd, "llast")
  end

  if ok then
    vim.cmd("normal! zz")
  else
    vim.api.nvim_echo({ { "No more location list", vim.log.levels.WARN } }, true, {})
  end
end

function M.toggle()
  for _, win in pairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.api.nvim_win_is_valid(win) and vim.fn.win_gettype(win) == "loclist" then
      vim.api.nvim_win_close(win, false)
      return
    end
  end
  local has_loclist = not vim.tbl_isempty(vim.fn.getloclist(0))
  if has_loclist then
    local count = vim.v.count
    if count == 0 then
      count = 10
    end
    vim.cmd("lopen" .. count)
  else
    vim.notify("No location list found", vim.log.levels.WARN)
  end
end

return M
