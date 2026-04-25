---@class LspLayer.Definition._Float
---@field result LspLayer.Definition.PipelineResult
local M = {}

function M:float()
  local result = self.result
  if self.result.type == "location" then
    --- @cast result LspLayer.Definition.PipelineLocationResult
    local list = result.result
    local ctx = self.result.context
    local win = ctx.win
    local from = vim.fn.getpos(".")
    from[1] = ctx.bufnr
    local tagname = vim.fn.expand("<cword>")

    local height = math.ceil(vim.o.lines * 0.3)
    local row
    local winline = vim.fn.winline()
    local below_height = vim.o.lines - winline - vim.o.cmdheight - 2

    if vim.o.laststatus > 1 then
      below_height = below_height - 1
    end
    if below_height >= winline then
      height = math.min(below_height, height)
      row = 1
    else
      height = math.min(winline, height)
      row = -height - 2
    end
    local first_item = list.items[1]
    local buf = vim.uri_to_bufnr(first_item.user_data.targetUri)
    first_item.bufnr = buf
    vim.fn.bufload(buf)

    local width = #vim.api.nvim_buf_get_lines(buf, list.items[1].lnum - 1, list.items[1].lnum, false)[1]
    width = math.max(width, height * 3)

    local float_win = vim.api.nvim_open_win(buf, true, {
      relative = "cursor",
      width = width,
      height = height,
      style = "minimal",
      row = row,
      col = 0,
      title = "Tag: " .. tagname,
      title_pos = "center",
      border = "single",
    })
    vim.api.nvim_set_option_value("signcolumn", "no", { win = float_win })
    vim.fn.setqflist({}, " ", list)
    local tagstack = { { tagname = tagname, from = from } }
    vim.fn.settagstack(vim.fn.win_getid(win), { items = tagstack }, "t")
    vim.cmd("cfirst")
    vim.schedule(function()
      vim.api.nvim_set_option_value("cursorline", true, { win = float_win })
    end)
    vim.api.nvim_set_current_win(win)
    vim.api.nvim_create_autocmd("CursorMoved", {
      callback = function()
        vim.api.nvim_win_close(float_win, true)
        return true
      end,
    })
  elseif self.result.type == "source" then
  end
end

return M
