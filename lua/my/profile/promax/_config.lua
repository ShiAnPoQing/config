--- @class my.profile.promax._config
--- @field _config my.profile.promax.Opts
local M = {}

--- @type my.profile.promax.Opts
local default_config = {
  keymap = {
    preset = "default",
    ["H"] = {},
    ["J"] = {},
    ["K"] = {},
    ["L"] = {},
    ["<bs>"] = {},
    ["<S-bs>"] = {},
    ["<space>h"] = {
      n = "motion.NORMAL.first_non_blank",
      x = "motion.VISUAL.first_non_blank",
      o = "motion.OPERATOR.first_non_blank",
    },
    ["<space>j"] = {},
    ["<space>k"] = {},
    ["<space>l"] = {
      n = "motion.NORMAL.last_non_blank",
      x = "motion.VISUAL.last_non_blank",
      o = "motion.OPERATOR.last_non_blank",
    },
    ["<space><space>h"] = {
      n = "motion.NORMAL.first",
      x = "motion.VISUAL.first",
      o = "motion.OPERATOR.first",
    },
    ["<space><space>j"] = {},
    ["<space><space>k"] = {},
    ["<space><space>l"] = {
      n = "motion.NORMAL.last",
      x = "motion.VISUAL.last",
      o = "motion.OPERATOR.last",
    },
    ["<S-space>H"] = {
      i = "motion.INSERT.first_non_blank",
      n = "insert.NORMAL.first_non_blank",
    },
    ["<S-space>J"] = {},
    ["<S-space>K"] = {},
    ["<S-space>L"] = {
      i = "motion.INSERT.last_non_blank",
      n = "insert.NORMAL.last_non_blank",
    },
    ["<S-space><S-space>H"] = {
      i = "motion.INSERT.first",
      n = "insert.NORMAL.first",
    },
    ["<S-space><S-space>J"] = {},
    ["<S-space><S-space>K"] = {},
    ["<S-space><S-space>L"] = {
      i = "motion.INSERT.last",
      n = "insert.NORMAL.last",
    },
    ["<C-space><C-h>"] = {},
    ["<C-space><C-j>"] = {},
    ["<C-space><C-k>"] = {},
    ["<C-space><C-l>"] = {},
    ["<C-space><C-space><C-h>"] = {},
    ["<C-space><C-space><C-j>"] = {},
    ["<C-space><C-space><C-k>"] = {},
    ["<C-space><C-space><C-l>"] = {},
    ["w"] = {
      n = "motion.NORMAL.backward_word_start",
      x = "motion.VISUAL.backward_word_start",
      o = "motion.OPERATOR.backward_word_start",
    },
    ["e"] = {
      n = "motion.NORMAL.backward_word_end",
      x = "motion.VISUAL.backward_word_end",
      o = "motion.OPERATOR.backward_word_end",
    },
    ["i"] = {
      n = "motion.NORMAL.forward_word_start",
      x = "motion.VISUAL.forward_word_start",
      o = "motion.OPERATOR.forward_word_start",
    },
    ["o"] = {
      n = "motion.NORMAL.forward_word_end",
      x = "motion.VISUAL.forward_word_end",
      o = "motion.OPERATOR.forward_word_end",
    },
    ["s"] = {
      n = "insert.NORMAL.cursor",
    },
    ["b"] = {
      n = "insert.NORMAL.open_line_below",
      x = "motion.VISUAL.other_end",
    },
    ["B"] = {
      n = "insert.NORMAL.open_line_above",
      x = "motion.VISUAL.other_corner",
    },

    ["jk"] = { i = "insert.stopinsert" },
    ["kj"] = { i = "insert.stopinsert" },
    ["jj"] = { i = "insert.stopinsert" },
    ["kk"] = { i = "insert.stopinsert" },
    ["<esc>"] = { i = "insert.stopinsert" },

    ["aw"] = { o = "textobject.a_word" },
    ["iw"] = { o = "textobject.inner_word" },
  },
}

--- @class my.profile.promax.Opts.Keymap.Spec
--- @field n? string
--- @field v? string
--- @field o? string
--- @field x? string
--- @field i? string
--- @field c? string
--- @field s? string
--- @field t? string

--- @class my.profile.promax.Opts.Keymap
--- @field [string] string|my.profile.promax.Opts.Keymap.Spec
--- @field preset? "default"|"none"

--- @class my.profile.promax.Opts
--- @field keymap? my.profile.promax.Opts.Keymap

--- @param path string
local function resolve_action(path)
  local value = my.profile.promax

  local parts = vim.split(path, ".", { plain = true })
  for i, part in ipairs(parts) do
    if i < #parts then
      if type(value[part]) == "table" then
        value = value[part]
      end
    else
      if type(value[part]) == "function" then
        value = value[part]
      end
    end
  end
  return value
end

---@param source my.profile.promax.Opts.Keymap
---@param keymap my.profile.promax.Opts.Keymap
local function resolve_keymap(source, keymap)
  if source.preset == "default" then
    for lhs, value in ipairs(source) do
      if lhs ~= "preset" then
        if type(value) == "table" then
          for mode, action in pairs(value) do
            if vim.list_contains({ "n", "i", "x", "o", "t", "c", "s", "v" }, mode) then
              if not M._config.keymap[lhs] then
                M._config.keymap[lhs] = {}
              end
              M._config.keymap[lhs][mode] = action
            end
          end
        end
      end
    end
  elseif source.preset == "none" then
    --- nothing to do
  else
    --
  end
  for lhs, value in pairs(keymap) do
    if lhs ~= "preset" then
      if type(value) == "table" then
        for mode, action in pairs(value) do
          if vim.list_contains({ "n", "i", "x", "o", "t", "c", "s", "v" }, mode) then
            local rhs = resolve_action(action)
            if type(rhs) == "function" or type(rhs) == "string" then
              keymap[lhs][mode] = rhs
            end
          end
        end
      end
    end
  end
end

---@param opts my.profile.promax.Opts?
function M.config(opts)
  opts = vim.tbl_deep_extend("force", {}, opts or {})
  vim.validate("opts", opts, "table")
  vim.validate("opts.keymap", opts.keymap, "table", true)
  M._config = { keymap = vim.tbl_deep_extend("force", default_config.keymap, {}) }
  opts.keymap = opts.keymap or {}
  opts.keymap.preset = opts.keymap.preset or "default"
  vim.validate("opts.keymap.preset", opts.keymap.preset, "string", true)
  resolve_keymap(opts.keymap, M._config.keymap)
end

return M
