local M = {}

function M.hasCapture(cap)
  return type(cap) == "table" and next(table) ~= nil
end

function M.has_TM_SELECTED_TEXT(snip)
  local TM_SELECTED_TEXT = snip.env.TM_SELECTED_TEXT
  return type(TM_SELECTED_TEXT) == "table" and next(TM_SELECTED_TEXT) ~= nil
end

return M
