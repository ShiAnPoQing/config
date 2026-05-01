local U = require("lsp-layer.definition.utils")
---@class LspLayer.Definition._Float
---@field result LspLayer.Definition.PipelineResult
local M = {}

---@return integer, integer
local function get_height_part()
  local winline = vim.fn.winline()
  local below_height = vim.o.lines - winline - vim.o.cmdheight - 2
  if vim.o.laststatus > 1 then
    below_height = below_height - 1
  end
  return winline, below_height
end

---@param bufnr integer
---@param start_row integer
---@param end_row integer
---@return {width:integer, height:integer, row:integer, col:integer}
local function compute_size_and_position(bufnr, start_row, end_row)
  local width = math.ceil(vim.o.columns * 0.3)
  local height = 3
  local row
  local above_height, below_height = get_height_part()
  local max_height = above_height + below_height
  if start_row then
    local lines = vim.api.nvim_buf_get_lines(bufnr, start_row, end_row + 1, false)
    local max_width
    for _, line in ipairs(lines) do
      local line_width = vim.fn.strdisplaywidth(line)
      max_width = math.max(max_width or 0, line_width)
      if line_width > max_width then
        max_width = line_width
      end
    end
    width = math.max(max_width, width)
    height = math.max(end_row - start_row + 1, height)
  end

  -- 核心思想：尽可能显示 preview 的内容
  if below_height >= above_height then
    -- 下方空间大，则展示在下方
    row = 1
    -- 不能超过最大高度
    height = math.min(height, max_height)
    if height > below_height then
      --- 下方空间还小，为了尽可能显示 preview 的内容，修正 row
      row = row - (height - below_height)
    end
  else
    -- 上方空间大，则展示在上方
    row = -height - 2
    -- 不能超过最大高度
    height = math.min(height, max_height)
    if height > above_height then
      --- 上方空间还小，为了尽可能显示 preview 的内容，修正 row
      row = row + (height - above_height)
    end
  end
  width = math.min(width, vim.o.columns)

  return {
    width = width,
    height = height,
    row = row,
    col = 0,
  }
end

function M:float()
  local result = self.result
  if self.result.type == "location" then
    ---@cast result LspLayer.Definition.PipelineLocationResult
    local list = result.result
    local context = result.context
    local win = context.win
    local from = vim.fn.getpos(".")
    from[1] = context.bufnr
    local tagname = vim.fn.expand("<cword>")

    if #list.items == 1 then
      local preview_item = list.items[1]
      local float_bufnr = vim.uri_to_bufnr(preview_item.user_data.targetUri)
      preview_item.bufnr = float_bufnr
      vim.fn.bufload(float_bufnr)

      local start_row, _, end_row = U.get_definition_node_range(preview_item)
      local fix_view = {
        topline = start_row and start_row + 1,
        leftcol = 0,
      }
      local compute = compute_size_and_position(float_bufnr, start_row, end_row)
      local float_win = vim.api.nvim_open_win(float_bufnr, true, {
        relative = "cursor",
        width = compute.width,
        height = compute.height,
        style = "minimal",
        row = compute.row,
        col = compute.col,
        title = "Tag: " .. tagname,
        title_pos = "center",
        border = "single",
      })
      vim.api.nvim_set_option_value("signcolumn", "no", { win = float_win })
      vim.api.nvim_set_option_value("winfixbuf", true, { win = float_win })
      if #list.items == 1 then
        local tagstack = { { tagname = tagname, from = from } }
        vim.fn.settagstack(vim.fn.win_getid(win), { items = tagstack }, "t")
      else
        vim.cmd("copen")
      end
      vim.api.nvim_win_call(float_win, function()
        vim.cmd("cfirst")
        vim.fn.winrestview(vim.tbl_extend("force", vim.fn.winsaveview(), fix_view))
      end)
      vim.api.nvim_set_current_win(float_win)
      vim.schedule(function()
        vim.api.nvim_set_option_value("cursorline", true, { win = float_win })
      end)
      vim.keymap.set("n", "q", function()
        vim.api.nvim_win_close(float_win, true)
      end, { buffer = float_bufnr })
      vim.keymap.set("n", "<esc>", function()
        vim.api.nvim_win_close(float_win, true)
      end, { buffer = float_bufnr })
    else
    end
  elseif self.result.type == "source" then
  end
end

return M
