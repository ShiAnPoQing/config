local M = {}
local Search = require("_eye.eye-search.search")

function M.eye()
  local buf = vim.api.nvim_get_current_buf()
  local win = vim.api.nvim_get_current_win()
  local wininfo = vim.fn.getwininfo(win)[1]
  local topline = wininfo.topline
  local botline = wininfo.botline
  local leftcol = wininfo.leftcol
  local rightcol = leftcol + wininfo.width - wininfo.textoff

  local function step(pattern)
    if pattern == "" then
      local char = vim.fn.getchar(-1, { number = false })
      step(pattern .. vim.fn.keytrans(char or ""))
      return
    end
    local results = Search.search(pattern:gsub("([\\^$.~[*?+])", "\\%1") .. ".\\?", {
      buf = buf,
      topline = topline,
      botline = botline,
      leftcol = leftcol,
      rightcol = rightcol,
    })
    local eye = require("_eye.core"):new(results)
    eye:active({
      cancel = function()
        vim.print("hao")
      end,
      active = function(ctx)
        local ns_id = vim.api.nvim_create_namespace("eye-search")
        if #ctx.entries > 0 then
          for _, entry in ipairs(ctx.entries) do
            vim.api.nvim_buf_set_extmark(buf, ns_id, entry.data.row - 1, entry.data.start_col, {
              virt_text = { { entry.labels[1], "Search" } },
              virt_text_pos = "overlay",
            })
          end
          vim.cmd.redraw()
          return function()
            vim.api.nvim_buf_clear_namespace(buf, ns_id, 0, -1)
          end
        else
        end
      end,
    })
  end
  step("l")
end

M.eye()

return M
