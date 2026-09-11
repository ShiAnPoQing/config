local M = {}

function M.goto_next_error()
  local fq = vim.fn.getqflist({ idx = 0, size = 0 })
  local current_idx = fq.idx
  local total = fq.size
  local count = vim.v.count1

  local ok
  if current_idx < total then
    ---@diagnostic disable-next-line: param-type-mismatch
    ok = pcall(vim.cmd, count .. "cnext")
  else
    ---@diagnostic disable-next-line: param-type-mismatch
    ok = pcall(vim.cmd, "cfirst")
  end

  if ok then
    vim.cmd("normal! zz")
  end
end

function M.goto_prev_error()
  local current_idx = vim.fn.getqflist({ idx = 0 }).idx
  local count = vim.v.count1

  local ok
  if current_idx > 1 then
    ---@diagnostic disable-next-line: param-type-mismatch
    ok = pcall(vim.cmd, count .. "cprevious")
  else
    ---@diagnostic disable-next-line: param-type-mismatch
    ok = pcall(vim.cmd, "clast")
  end
  if ok then
    vim.cmd("normal! zz")
  end
end

function M.toggle()
  local is_open = M.is_open()
  if is_open then
    vim.cmd("cclose")
  else
    local count = vim.v.count
    if count == 0 then
      count = 10
    end
    vim.cmd("copen " .. count)
  end
end

function M.is_open()
  return vim.fn.getqflist({ winid = 0 }).winid ~= 0
end

return M
