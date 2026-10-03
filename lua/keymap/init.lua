local M = {}

function M.setup()
  local Key = require("native-packer.key")

  local paths = {
    -- "test",
    "motion",
    "buffer",
    "change",
    "comment",
    "copy",
    "delete",
    "directory",
    "file",
    "fold",
    "indent",
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
    "quit",
    "register",
    "screen-move",
    "search",
    "start-insert-mode",
    "start-select-mode",
    "start-visual-mode",
    "stop-insert-mode",
    "switch-option",
    "tabpage",
    "tagstack",
    "terminal",
    "textobject",
    "undo",
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
end

return M
