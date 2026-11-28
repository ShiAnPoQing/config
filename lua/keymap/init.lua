local M = {}

function M.setup()
  local paths = {
    -- "test",
    "buffer",
    "delete",
    "directory",
    "file",
    "insert-line",
    "lsp",
    -- "macro",
    "misc",
    -- "move-select",
    "move",
    "nop",
    "paste",
    "quickfix",
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
      my.keymap2.set(keymaps)
    end
  end
  my.keymap2.del({
    ["in"] = { "x", "o" },
  })

  vim.api.nvim_create_autocmd("TermEnter", {
    once = true,
    callback = function()
      my.keymap2.set(require("keymap.keymaps.terminal"))
    end,
  })

  local pending_load_modes = {
    ["no"] = "keymap.keymaps.omode",
    ["i"] = "keymap.keymaps.imode",
    ["s"] = "keymap.keymaps.smode",
    ["c"] = "keymap.keymaps.cmode",
    ["x"] = "keymap.keymaps.xmode",
  }
  vim.api.nvim_create_autocmd("ModeChanged", {
    callback = function()
      if vim.tbl_isempty(pending_load_modes) then
        pending_load_modes = nil
        return true
      end
      local mode = vim.api.nvim_get_mode().mode
      if vim.list_contains({ "v", "V", "" }, mode) then
        mode = "x"
      end
      local pending = pending_load_modes[mode]
      if pending then
        my.keymap2.set(require(pending))
        pending_load_modes[mode] = nil
      end
    end,
  })
end

return M
