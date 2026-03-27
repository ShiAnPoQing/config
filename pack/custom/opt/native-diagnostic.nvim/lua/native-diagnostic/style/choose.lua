local M = {}
local Menu = require("native-diagnostic.menu")

local function create_style_items()
  local styles = require("native-diagnostic.style").styles
  local style = require("native-diagnostic.style").style
  local items = {}
  for _, _style in ipairs(styles) do
    local item = {
      text = _style.name,
    }
    if _style.name == style.name then
      item.selected = true
    end
    items[#items + 1] = item
  end
  return items
end

function M.choose()
  if Menu:is_open() then
    Menu:close()
    return
  end
  Menu:open({
    name = "Choose Diagnostic Style",
    items = create_style_items(),
    on_close = function() end,
    on_select = function(item)
      require("native-diagnostic.style").set_style(item.text)
    end,
    keymap = {
      select = { "<CR>" },
      close = { "<Esc>", "<C-c>", "q" },
    },
  })
end

return M
