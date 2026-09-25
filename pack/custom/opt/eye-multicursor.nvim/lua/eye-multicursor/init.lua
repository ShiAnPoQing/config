local M = {}

--- @param continue? boolean
function M.delete(continue)
  local mc_ns_id = vim.api.nvim_create_namespace("nvim.multicursor")
  local marks = vim.api.nvim_buf_get_extmarks(0, mc_ns_id, { vim.fn.line("w0") - 1, 0 }, { vim.fn.line("w$") - 1, 0 })
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
  local ns_id = vim.api.nvim_create_namespace("eye-multicursor")
  local eye = require("_eye.core"):new(labels)
  eye:active({
    flush = function()
      vim.cmd.redraw()
    end,
    update = function(ctx)
      local text = vim.fn.join(ctx.labels, "")
      local id = vim.api.nvim_buf_set_extmark(ctx.data.buf, ns_id, ctx.data.row - 1, ctx.data.col, {
        virt_text = { { text:sub(1, 1), "ErrorMsg" } },
        virt_text_pos = "overlay",
      })
      return function()
        vim.api.nvim_buf_del_extmark(ctx.data.buf, ns_id, id)
      end
    end,
    complete = function(ctx)
      local data = ctx.data
      vim.api.nvim_buf_del_extmark(0, mc_ns_id, data.id)
      del_mark_count = del_mark_count + 1
      if continue and del_mark_count < #marks then
        ctx.rollback(1)
      end
    end,
  })
end

return M
