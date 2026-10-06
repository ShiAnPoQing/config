--- @class my.profile.pro._runtime
local M = {}

local function init_options()
  vim.o.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,t:block-blinkon500-blinkoff500-TermCursor"
  vim.o.selection = "inclusive"
end

local function init_keymaps(keymaps)
  for lhs, value in pairs(keymaps) do
    if lhs == "preset" then
    elseif type(value) == "table" then
      for mode, cb in pairs(value) do
        if vim.list_contains({ "n", "i", "x", "o", "t", "c", "s", "v" }, mode) then
          vim.keymap.set(mode, lhs, cb)
        end
      end
    end
  end
end

function M.init()
  local config = my.profile.pro._config._config
  init_options()
  init_keymaps(config.keymap)
end

function M.cleanup() end

return M
