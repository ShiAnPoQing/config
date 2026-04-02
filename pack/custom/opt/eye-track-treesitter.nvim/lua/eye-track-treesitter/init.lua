local M = {}

function M.treesitter(config)
  local bufnr = vim.api.nvim_get_current_buf()
  local tree = vim.treesitter.get_parser(bufnr, config.language):parse()[1]
  local query = vim.treesitter.query.get(config.language, config.scm)
  if query == nil then
    return
  end
  local wininfo = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
  local topline = wininfo.topline
  local botline = wininfo.botline

  --- @type Eye.Label.Spec[]
  local labels = {}
  local root = tree:root()
  for id, node, _, _ in query:iter_captures(root, bufnr) do
    if query.captures[id] == config.query then
      local start_row, start_col, end_row, end_col = node:range()
      if start_row + 1 >= topline and start_row + 1 <= botline then
        --- @type Eye.Label.Spec
        local label = {
          buf = bufnr,
          extmark = {
            virt_text_pos = "inline",
            right_gravity = false,
          },
          highlight = {
            show_next_key = false,
          },
          items = {
            { pos = { start_row, start_col } },
            { pos = { end_row, end_col } },
          },
          data = {
            start_row = start_row,
            start_col = start_col,
            end_row = end_row,
            end_col = end_col,
          },
        }
        labels[#labels + 1] = label
      end
    end
  end
  require("eye.core")
    .gaze({
      labels = labels,
      label = {
        matched = function(ctx)
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "nx", false)
          vim.api.nvim_win_set_cursor(0, { ctx.data.start_row + 1, ctx.data.start_col })
          vim.api.nvim_feedkeys("v", "nx", false)
          vim.api.nvim_win_set_cursor(0, { ctx.data.end_row + 1, ctx.data.end_col - 1 })
        end,
      },
      cancelled = function()
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Ignore>", true, false, true), "nx", false)
      end,
    })
    :start()
end

return M
