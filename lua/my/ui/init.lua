--- @class my.ui
--- @field Box my.ui.Class.Box
--- @field Window my.ui.Class.Window
--- @field Input my.ui.Class.Input
local M = my.util.defer_require("my.ui", {
  Window = "window",
  Input = "input",
  Box = "box",
})

--- @param ui my.ui.Window|my.ui.Box
--- @param relative "cursor"|"editor"|"laststatus"|"mouse"|"tabline"
function M.place(ui, relative)
  vim.validate("relative", relative, "string")
  if not vim.list_contains({ "cursor", "editor", "laststatus", "mouse", "tabline" }, relative) then
    vim.notify(
      string.format(
        'my.ui.place: "relative" expected one of {"cursor", "editor", "laststatus", "mouse", "tabline"}, but got "%s"',
        relative
      ),
      vim.log.levels.ERROR
    )
    return
  end
end

-- local Input1 = my.ui.Input({ size = { width = 1, height = 1 } }, {})
-- local Input2 = my.ui.Input({ size = { width = 1, height = 1 } }, {})
--
-- my.ui.Box({
--   my.ui.Box({ Input1 }, { dir = "col" }),
--   Input2,
-- }, { dir = "row" })

return M
