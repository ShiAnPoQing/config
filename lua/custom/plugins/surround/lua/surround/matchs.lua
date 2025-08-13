local M = {}

local start_matchs = {
  ["["] = "]",
  ["<"] = ">",
  ["{"] = "}",
  ["("] = ")",
  ["'"] = "'",
  ['"'] = '"',
  ["|||"] = "|||",
}

local end_matchs = {
  ["]"] = "[",
  [">"] = "<",
  ["}"] = "{",
  [")"] = "(",
  ["|||"] = "|||",
}

function M.get_match(mc)
  local end_match = start_matchs[mc]
  if end_match then
    return mc, end_match
  end

  local start_match = end_matchs[mc]
  if start_match then
    return start_match, mc
  end
  return nil, nil
end

return M
