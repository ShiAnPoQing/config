local M = {}

local function feedkeys(key)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), "m", true)
end

local function split_keys(seq)
  local result = {}
  local i = 1
  while i <= #seq do
    local c = seq:sub(i, i)
    if c == "<" then
      local j = seq:find(">", i + 1, true)
      if j then
        table.insert(result, seq:sub(i, j))
        i = j + 1
      else
        table.insert(result, c)
        i = i + 1
      end
    else
      table.insert(result, c)
      i = i + 1
    end
  end
  return result
end

local function contain_key(lhs_keys, key)
  for _, value in ipairs(lhs_keys) do
    if vim.startswith(value, key) then
      return true
    end
  end
end

local function get_real_keys(keys)
  local new_keys = {}
  local keymaps = require("simple-keymap").get_keymaps()
  local lhs_keys = {}

  for key, _ in pairs(keymaps) do
    if type(key) == "string" then
      table.insert(lhs_keys, key:lower())
    end
  end

  local function run(prefix, prefix_ok)
    if #keys == 0 then
      if prefix_ok then
        table.insert(new_keys, prefix)
      end
      return
    end

    local key = keys[1]
    local test = prefix .. key
    if contain_key(lhs_keys, test) then
      table.remove(keys, 1)
      run(test, true)
    else
      if prefix_ok then
        table.insert(new_keys, prefix)
      else
        table.insert(new_keys, key)
        table.remove(keys, 1)
      end

      run("")
    end
  end

  run("")

  return new_keys
end

local function get_keymap_context(keymap)
  for _, value in pairs(keymap) do
    if value.after then
      return value
    end
  end
end

function M.macro_repeat(register_name)
  if type(register_name) ~= "string" then
    return
  end

  local reg = vim.fn.getreg(register_name)
  if reg == "" then
    return
  end

  M.last_register_name = register_name

  local normalize_reg = vim.fn.keytrans(reg):lower()
  local keys = split_keys(normalize_reg)
  local new_keys = get_real_keys(keys)
  local new_keys_copy = vim.tbl_deep_extend("force", {}, new_keys)
  local function run()
    if #new_keys_copy == 0 then
      return
    end
    local key = table.remove(new_keys_copy, 1)
    local keymap = require("simple-keymap").get(key)
    feedkeys(key)

    if keymap then
      local context = get_keymap_context(keymap)
      if context then
        context.after = run()
      else
        vim.schedule(run)
      end
    else
      vim.schedule(run)
    end
  end
  run()
end

return M
