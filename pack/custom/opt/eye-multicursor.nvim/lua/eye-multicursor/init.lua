local M = {}

--- @param continue? boolean
function M.delete(continue)
  local topline = vim.fn.line("w0")
  local botline = vim.fn.line("w$")
  local ns_id = vim.api.nvim_create_namespace("nvim.multicursor")
  local marks = vim.api.nvim_buf_get_extmarks(0, ns_id, { topline - 1, 0 }, { botline - 1, 0 })
  if #marks == 0 then
    return
  end
  local labels = {}
  for _, mark in ipairs(marks) do
    table.insert(labels, {
      buf = 0,
      row = mark[2] + 1,
      col = mark[3],
      id = mark[1],
    })
  end
  local del_mark_count = 0
  local H = require("_eye.core.highlight")
  local eye = require("_eye.core"):new(labels)
  eye:_active({
    active = function(ctx)
      if #ctx.entries > 0 then
        local hls = {}
        for _, entry in ipairs(ctx.entries) do
          local text = vim.fn.join(entry.labels, "")
          table.insert(hls, {
            virt_text = { { text:sub(1, 1), H.EyeLabel } },
            row = entry.data.row - 1,
            col = entry.data.col,
            buf = entry.data.buf,
          })
        end
        local clean = H.highlight(hls, {})
        return function()
          clean()
        end
      else
        local data = ctx.data
        vim.api.nvim_buf_del_extmark(0, ns_id, data.id)
        del_mark_count = del_mark_count + 1
        if continue then
          if del_mark_count < #marks then
            ctx.rollback(1)
          end
        end
      end
    end,
  })
end

return M
