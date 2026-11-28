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

local map = {
  ["<C-M-F60>"] = {
    pattern = "<[Cc]%-[Ii]>",
    key = "<C-i>",
  },
  ["<C-M-F59>"] = {
    pattern = { "<[Cc]%-[Ss]%-[Ii]>", "<[Ss]%-[Cc]%-[Ii]>" },
    key = "<C-S-i>",
  },
  ["<C-M-F58>"] = {
    pattern = { "<[Cc]%-[Mm]%-[Ii]>", "<[Mm]%-[Cc]%-[Ii]>" },
    key = "<C-M-i>",
  },
  ["<C-M-F57>"] = {
    pattern = {
      "<[Cc]%-[Mm]%-[Ss]%-[Ii]>",
      "<[Cc]%-[Ss]%-[Mm]%-[Ii]>",
      "<[Mm]%-[Cc]%-[Ss]%-[Ii]>",
      "<[Mm]%-[Ss]%-[Cc]%-[Ii]>",
      "<[Ss]%-[Cc]%-[Mm]%-[Ii]>",
      "<[Ss]%-[Mm]%-[Cc]%-[Ii]>",
    },
    key = "<C-M-S-i>",
  },
  ["<C-M-F56>"] = {
    pattern = "<[Cc]%-%[>",
    key = "<C-[>",
  },
  ["<C-M-F55>"] = {
    pattern = { "<[Cc]%-[Ss]%-%[>", "<[Ss]%-[Cc]%-%[>" },
    key = "<C-S-[>",
  },
  ["<C-M-F54>"] = {
    pattern = { "<[Cc]%-[Mm]%-%[>", "<[Mm]%-[Cc]%-%[>" },
    key = "<C-M-[>",
  },
  ["<C-M-F53>"] = {
    pattern = {
      "<[Cc]%-[Mm]%-[Ss]%-%[>",
      "<[Cc]%-[Ss]%-[Mm]%-%[>",
      "<[Mm]%-[Cc]%-[Ss]%-%[>",
      "<[Mm]%-[Ss]%-[Cc]%-%[>",
      "<[Ss]%-[Cc]%-[Mm]%-%[>",
      "<[Ss]%-[Mm]%-[Cc]%-%[>",
    },
    key = "<C-M-S-[>",
  },
  ["<C-M-F52>"] = {
    pattern = "<[Cc]%-[Mm]>",
    key = "<C-m>",
  },
  ["<C-M-F51>"] = {
    pattern = { "<[Cc]%-[Ss]%-[Mm]>", "<[Ss]%-[Cc]%-[Mm]>" },
    key = "<C-S-m>",
  },
  ["<C-M-F50>"] = {
    pattern = { "<[Cc]%-[Mm]%-[Mm]>", "<[Mm]%-[Cc]%-[Mm]>" },
    key = "<C-M-m>",
  },
  ["<C-M-F49>"] = {
    pattern = {
      "<[Cc]%-[Mm]%-[Ss]%-[Mm]>",
      "<[Cc]%-[Ss]%-[Mm]%-[Mm]>",
      "<[Mm]%-[Cc]%-[Ss]%-[Mm]>",
      "<[Mm]%-[Ss]%-[Cc]%-[Mm]>",
      "<[Ss]%-[Cc]%-[Mm]%-[Mm]>",
      "<[Ss]%-[Mm]%-[Cc]%-[Mm]>",
    },
    key = "<C-M-S-M>",
  },
}
map["<M-C-F60>"] = map["<C-M-F60>"]
map["<M-C-F59>"] = map["<C-M-F59>"]
map["<M-C-F58>"] = map["<C-M-F58>"]
map["<M-C-F57>"] = map["<C-M-F57>"]
map["<M-C-F56>"] = map["<C-M-F60>"]
map["<M-C-F55>"] = map["<C-M-F55>"]
map["<M-C-F54>"] = map["<C-M-F54>"]
map["<M-C-F53>"] = map["<C-M-F53>"]
map["<M-C-F52>"] = map["<C-M-F56>"]
map["<M-C-F51>"] = map["<C-M-F51>"]
map["<M-C-F50>"] = map["<C-M-F50>"]
map["<M-C-F49>"] = map["<C-M-F49>"]

--- @param key_sequence string
--- @return string
local function translate(key_sequence)
  for k, info in pairs(map) do
    --- @type string[]
    local pattern
    if type(info.pattern) == "string" then
      pattern = { info.pattern }
    elseif type(info.pattern) == "table" then
      pattern = info.pattern --[[@as table<string>]]
    end
    for _, p in ipairs(pattern) do
      key_sequence = key_sequence:gsub(p, k)
    end
  end
  local _, chords = vim.keycode(key_sequence, true)
  local _key_sequence = ""
  for _, chord in ipairs(chords or {}) do
    local key = chord.keys
    if map[key] then
      key = map[key].key
    end
    _key_sequence = _key_sequence .. M.get(key)
  end
  return _key_sequence
end

local special_keys = {
  "<Tab>",
  "<S-Tab>",
  "<M-Tab>",
  "<M-S-Tab>",
  "<Esc>",
  "<S-Esc>",
  "<M-Esc>",
  "<M-S-Esc>",
  "<CR>",
  "<S-CR>",
  "<M-CR>",
  "<M-S-CR>",
}

--- @param key_sequence string
--- @return string
function M.translate(key_sequence)
  vim.validate("key_sequence", key_sequence, "string")
  local _, chords = vim.keycode(key_sequence, true)
  local _key_sequence = ""
  for _, chord in ipairs(chords or {}) do
    if vim.list_contains(special_keys, chord.keys) then
      return translate(key_sequence)
    end
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
  M.set("<m-space>", "<C-esc>")
  M.set("<c-space>", "<C-esc><C-esc>")
end

return M
