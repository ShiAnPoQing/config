--- @class my._atom._menu.render
local M = vim._defer_require("my._atom._menu.render", {})

--- @param buf integer
--- @param items any
--- @param opts my._atom._menu.Opts.Layout
function M.draw(buf, items, opts)
  local padding = opts.padding or { 0, 0 }
  if type(padding) == "number" then
    padding = { padding, padding }
  end
  local lines = {}
  local highlights = {}
  for i, item in ipairs(items) do
    local line = string.rep(" ", padding[1])
    local context = {
      idx = i,
      item = item,
    }
    local components = opts.components
    for _, span in ipairs(opts.columns) do
      local gap = span.gap or 0
      for s_i, name in ipairs(span) do
        local component = components[name]
        local Component = require("my._atom._menu.component").create(component)
        Component:build({ context.idx, #line }, context)
        local text = Component:get_text()
        for _, hl in ipairs(Component:get_highlight()) do
          table.insert(highlights, hl)
        end
        line = line .. text
        if s_i ~= #span then
          line = line .. string.rep(" ", gap)
        end
      end
    end
    table.insert(lines, line)
  end
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  local ns_id = vim.api.nvim_create_namespace("my.atom.menu")
  for _, hl in ipairs(highlights) do
    local start_pos = hl[1]
    local end_pos = hl[2]
    vim.api.nvim_buf_set_extmark(buf, ns_id, start_pos[1] - 1, start_pos[2], {
      end_col = end_pos[2],
      end_line = end_pos[1] - 1,
      hl_group = hl[3],
    })
  end
  vim.fn.winrestview({ lnum = #items })
end

return M
