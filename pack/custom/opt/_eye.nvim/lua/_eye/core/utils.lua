local M = {}

function M.compute(label_count, total)
  local function compute_run(i)
    local min = label_count * math.pow(label_count, i - 1)
    local max = label_count * math.pow(label_count, i)

    if total >= min and total <= max then
      local remain = total - min
      local quotient = math.ceil(remain / min)
      local remainder = remain - (quotient * min)
      local key_count = math.ceil((remainder + quotient) / min) + quotient
      return i + 1, key_count
    elseif total > max then
      return compute_run(i + 1)
    end
    return i + 1, 0
  end

  return compute_run(1)
end

function M.try(fn, ...)
  if type(fn) == "function" then
    return fn(...)
  end
end

function M.get_char()
  local char = vim.fn.getchar(-1, { number = false })
  char = type(char) == "string" and vim.fn.keytrans(char) or ""
  return char
end

return M
