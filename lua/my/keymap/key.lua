--- @class my.keymap.key
local M = {}

local KEYS = {}

---  @param lhs string
---  @param rhs string
function M.set(lhs, rhs)
  vim.validate("lhs", lhs, "string")
  vim.validate("rhs", rhs, "string")
  KEYS[lhs:lower()] = rhs
end

--- @param lhs string
--- @return string
function M.get(lhs)
  vim.validate("lhs", lhs, "string")
  return KEYS[lhs:lower()] or lhs
end

--- @param key_sequence string
--- @return string
function M.translate(key_sequence)
  vim.validate("key_sequence", key_sequence, "string")
  local _, chords = vim.keycode(key_sequence, true)
  local _key_sequence = ""
  for _, chord in ipairs(chords or {}) do
    _key_sequence = _key_sequence .. M.get(chord.keys)
  end
  return _key_sequence
end

setmetatable(M, {
  __index = function(_, k)
    if type(k) == "string" then
      return M.get(k)
    end
  end,
})

if vim.env.TERM == "xterm-ghostty" or vim.env.TERM == "tmux-256color" then
  M.set("<c-9>", "<F19>")
  M.set("<c-0>", "<F18>")
  M.set("<c-bs>", "<F17>")
  M.set("<esc>", "<F13>")
  M.set("<M-space>", "<C-esc>")
end

return M
