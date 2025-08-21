vim.api.nvim_set_hl(0, "CustomMagicVisual", {
  fg = "#cdcdcd",
  bg = "#333738",
})
local visual_hl = vim.api.nvim_get_hl(0, { name = "Visual" })
vim.api.nvim_set_hl(0, "CustomMagicNextKey", {
  fg = "#ff007c",
})
vim.api.nvim_set_hl(0, "CustomMagicNextKey1", {
  fg = "#00dfff",
})
vim.api.nvim_set_hl(0, "CustomMagicNextKey2", {
  fg = "#2b8db3",
})
vim.api.nvim_set_hl(0, "CustomMagicUnmatched", {
  fg = "#666666",
})
vim.api.nvim_set_hl(0, "CustomMagicNextKeyInVisual", {
  fg = "#ff007c",
  bg = visual_hl.bg,
})
vim.api.nvim_set_hl(0, "CustomMagicNextKey1InVisual", {
  fg = "#00dfff",
  bg = visual_hl.bg,
})
vim.api.nvim_set_hl(0, "CustomMagicNextKey2InVisual", {
  fg = "#2b8db3",
  bg = visual_hl.bg,
})

local M = {
  --- @param opts KeyOpts
  init = function(opts)
    local Key = require("magic.key.key")
    Key:init(opts)

    return {
      compute = function(total)
        return Key:compute(total)
      end,
      --- @type fun(register_opts: KeyRegisterOpts)
      register = function(register_opts)
        return Key:register(register_opts)
      end,
      --- @param on_key_opts OnKeyOpts
      on_key = function(on_key_opts)
        return Key:on_key(on_key_opts)
      end,
    }
  end,
}

return M
