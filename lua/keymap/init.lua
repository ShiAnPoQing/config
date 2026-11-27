local M = {}

function M.setup()
  local Key = require("native-packer.key")

  local paths = {
    -- "test",
    "buffer",
    "change",
    "comment",
    "delete",
    "directory",
    "file",
    "fold",
    "insert-line",
    "jump",
    "location-list",
    "lsp",
    -- "macro",
    "misc",
    -- "move-select",
    "move",
    "nop",
    "operator",
    "paste",
    "quickfix",
    -- "register",
    -- "screen-move",
    "search",
    "start-insert-mode",
    "switch-option",
    "tabpage",
    "tagstack",
    "textobject",
    "window",
    "word-move",
    "test",
    "cmdwin",
    -- "dir",
    "multicursor",
  }

  for _, path in ipairs(paths) do
    local ok, keymaps = pcall(require, "keymap.keymaps." .. path)
    if ok then
      Key.add(keymaps)
    end
  end
  Key.del({
    ["in"] = { "x", "o" },
  })

  vim.api.nvim_create_autocmd("TermEnter", {
    once = true,
    callback = function()
      Key.add(require("keymap.keymaps.terminal"))
    end,
  })

  local pending_load_modes = {
    ["no"] = "keymap.keymaps.omode",
    ["i"] = "keymap.keymaps.imode",
    ["s"] = "keymap.keymaps.smode",
    ["c"] = "keymap.keymaps.cmode",
  }
  vim.api.nvim_create_autocmd("ModeChanged", {
    callback = function()
      if vim.tbl_isempty(pending_load_modes) then
        pending_load_modes = nil
        return true
      end
      local mode = vim.api.nvim_get_mode().mode
      local pending = pending_load_modes[mode]
      if pending then
        Key.add(require(pending))
        pending_load_modes[mode] = nil
      end
    end,
  })
end

return M
