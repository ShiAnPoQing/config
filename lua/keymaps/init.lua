local Key = require("native-packer.key")

local paths = {
  -- "test",
  "keymaps/buffer",
  "keymaps/change",
  "keymaps/comment",
  "keymaps/copy",
  "keymaps/delete",
  "keymaps/diagnostic",
  "keymaps/directory",
  "keymaps/file",
  "keymaps/fold",
  "keymaps/indent",
  "keymaps/insert-line",
  "keymaps/jump",
  "keymaps/location-list",
  "keymaps/lsp",
  "keymaps/macro",
  "keymaps/misc",
  "keymaps/move-select",
  "keymaps/move",
  "keymaps/nop",
  "keymaps/operator",
  "keymaps/paste",
  "keymaps/quickfix",
  "keymaps/quit",
  "keymaps/register",
  "keymaps/screen-move",
  "keymaps/scroll",
  "keymaps/search",
  "keymaps/start-insert-mode",
  "keymaps/start-select-mode",
  "keymaps/start-visual-mode",
  "keymaps/stop-insert-mode",
  "keymaps/switch-option",
  "keymaps/tabpage",
  "keymaps/tagstack",
  "keymaps/terminal",
  "keymaps/text",
  "keymaps/textobject",
  "keymaps/tmux-fixed",
  "keymaps/undo",
  "keymaps/window",
  "keymaps/word-move",
}

for _, path in ipairs(paths) do
  Key.add(require(path))
end
Key.del({
  ["in"] = { "x" },
})
