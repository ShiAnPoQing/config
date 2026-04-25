local U = require("lsp-layer.code_action.utils")

---@class LspLayer.CodeAction._UI
--- @field response LspLayer.CodeAction.Action[]
local M = {}

function M:float()
  local response = self.response
  if #response == 0 then
    return
  end
  local winline = vim.fn.winline()
  local lines = {}
  local width
  local height
  local row
  for _, action in ipairs(response) do
    width = math.max(width or 0, #action.action.title)
    table.insert(lines, action.action.title)
  end
  local below_height = vim.o.lines - winline - vim.o.cmdheight - 2
  if vim.o.laststatus > 1 then
    below_height = below_height - 1
  end
  if below_height >= winline then
    height = math.min(below_height, #lines)
    row = 1
  else
    height = math.min(winline, #lines)
    row = -height - 2
  end
  local bufnr = vim.api.nvim_create_buf(false, true)
  local winid = vim.api.nvim_open_win(bufnr, true, {
    relative = "cursor",
    style = "minimal",
    width = width,
    height = height,
    row = row,
    col = 0,
    border = "rounded",
  })
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
  vim.api.nvim_set_option_value("modifiable", false, { buf = bufnr })
  vim.api.nvim_set_option_value("cursorline", true, { win = winid })
  vim.api.nvim_set_option_value("winfixbuf", true, { win = winid })
  vim.keymap.set("n", "<cr>", function()
    U.on_user_choice(response[vim.fn.line(".")])
    vim.api.nvim_win_close(winid, true)
  end, {
    buf = bufnr,
  })
  vim.keymap.set("n", "q", function()
    vim.api.nvim_win_close(winid, true)
  end, {
    buf = bufnr,
  })
  vim.keymap.set("n", "<esc>", function()
    vim.api.nvim_win_close(winid, true)
  end, {
    buf = bufnr,
  })
end

---@param item {action: lsp.Command|lsp.CodeAction, ctx: lsp.HandlerContext}
local function format_item(item)
  local clients = vim.lsp.get_clients({ bufnr = item.ctx.bufnr })
  local title = item.action.title:gsub("\r\n", "\\r\\n"):gsub("\n", "\\n")

  if item.action.disabled then
    title = title .. " (disabled)"
  end

  if #clients == 1 then
    return title
  end

  local source = assert(vim.lsp.get_client_by_id(item.ctx.client_id)).name
  return ("%s [%s]"):format(title, source)
end

function M:choice()
  local actions = self.response
  local select_opts = {
    prompt = "Code actions:",
    kind = "codeaction",
    format_item = format_item,
  }
  vim.ui.select(actions, select_opts, U.on_user_choice)
end

return M
