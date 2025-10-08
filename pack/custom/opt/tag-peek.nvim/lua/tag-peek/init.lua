local M = {}
local float = require("tag-peek.float")
local preview = require("tag-peek.preview")

--- @class TagPeekOptions

--- @param opts? TagPeekOptions
function M.setup(opts) end

function M.peek()
  vim.ui.input({ prompt = "tselect: " }, function(input)
    local tags = vim.fn.taglist(input)
    float.float()
    local lines = {}
    local data = {}

    for _, tag in ipairs(tags) do
      local lnum, col = tag.cmd:match("\\%%(%d+)l\\%%(%d+)c")
      data[#data + 1] = {
        text = tag.filename .. ":" .. lnum .. ":" .. col,
        filename = tag.filename,
        name = tag.name,
        line = tonumber(lnum),
        col = tonumber(col),
      }
      table.insert(lines, tag.name)
    end

    vim.api.nvim_buf_set_lines(float.buf, 0, -1, false, lines)

    local ns_id = vim.api.nvim_create_namespace("tag-peek-cursor-line")
    local _ns_id = vim.api.nvim_create_namespace("tag-peek-cursor-line-extmark")
    for i, d in ipairs(data) do
      vim.api.nvim_buf_set_extmark(float.buf, _ns_id, i - 1, 0, {
        virt_text_pos = "inline",
        virt_text = { { " ", "Special" } },
      })
    end
    vim.api.nvim_create_autocmd("CursorMoved", {
      callback = function()
        local cursor = vim.api.nvim_win_get_cursor(0)
        local line = cursor[1]
        vim.api.nvim_buf_clear_namespace(float.buf, ns_id, 0, -1)
        vim.api.nvim_buf_set_extmark(float.buf, ns_id, line - 1, 0, {
          end_line = line,
          hl_group = "Function",
        })
        local d = data[line]
        vim.api.nvim_buf_set_extmark(float.buf, ns_id, line - 1, 0, {
          virt_text = { { d.text, "Special" } },
        })
        preview.preview({ path = d.filename, line = d.line })
        vim.api.nvim_set_current_win(float.win)
      end,
      buffer = float.buf,
    })
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-y>", true, false, true), "n", true)
    vim.api.nvim_set_option_value("modifiable", false, { buf = float.buf })
    preview.preview({ path = data[1].filename, line = data[1].line })
    vim.api.nvim_set_current_win(float.win)
  end)
end

return M
