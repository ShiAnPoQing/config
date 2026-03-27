local M = {}

--- @class NativeDiagnostic.Menu.Item
--- @field text string
--- @field selected? boolean

--- @class NativeDiagnostic.Menu.Keys
--- @field select string[]
--- @field close string[]

--- @class NativeDiagnostic.Menu.Options
--- @field items NativeDiagnostic.Menu.Item[]
--- @field keymap NativeDiagnostic.Menu.Keys
--- @field on_select fun(item: NativeDiagnostic.Menu.Item)
--- @field on_close fun()
--- @field name string

local function try(fn, ...)
  if type(fn) == "function" then
    return fn(...)
  end
end

local default_win_config = {
  relative = "editor",
  border = "rounded",
  style = "minimal",
  title_pos = "center",
}

local function resolve_win_config(config)
  local win_config = vim.tbl_deep_extend("force", {}, default_win_config)
  for key, value in pairs(config) do
    win_config[key] = value
  end
  local max_width = vim.o.columns
  local max_height = vim.o.lines
  win_config.width = math.max(math.min(config.width, max_width), #win_config.title + 2)
  win_config.height = math.min(config.height, max_height)
  win_config.row = math.ceil((max_height - win_config.height) / 2)
  win_config.col = math.ceil((max_width - win_config.width) / 2)
  return win_config
end

local function set_options(options, o)
  for key, value in pairs(options) do
    vim.api.nvim_set_option_value(key, value, o)
  end
end

local function resolve_items(items)
  local lines = {}
  local selected_item_index
  local max_width = 0
  for i, item in ipairs(items) do
    max_width = math.max(max_width, #item.text)
    if item.selected then
      selected_item_index = i
    end
    table.insert(lines, item.text)
  end
  return lines, selected_item_index, max_width
end

---@param options NativeDiagnostic.Menu.Options
function M:open(options)
  local lines, selected_item_index, max_width = resolve_items(options.items)
  self.ns_id = vim.api.nvim_create_namespace("native-diagnostic")
  self.on_select = options.on_select
  self.on_close = options.on_close
  self.items = options.items
  self.bufnr = vim.api.nvim_create_buf(false, true)
  self.winid = vim.api.nvim_open_win(
    self.bufnr,
    true,
    resolve_win_config({
      height = #options.items,
      width = max_width,
      title = options.name,
    })
  )
  vim.api.nvim_buf_set_lines(self.bufnr, 0, -1, false, lines)
  set_options({
    modifiable = false,
  }, {
    buf = self.bufnr,
  })
  set_options({
    winfixbuf = true,
  }, {
    win = self.winid,
  })
  self:select(selected_item_index)
  for _, key in ipairs(options.keymap.select) do
    vim.keymap.set("n", key, function()
      local index = vim.api.nvim_win_get_cursor(self.winid)[1]
      self:select(index)
    end, { buffer = self.bufnr })
  end
  for _, key in ipairs(options.keymap.close) do
    vim.keymap.set("n", key, function()
      self:close()
      options.on_close()
    end, { buffer = self.bufnr })
  end
  vim.api.nvim_create_autocmd("VimResized", {
    callback = function()
      vim.api.nvim_win_set_config(
        self.winid,
        resolve_win_config({
          width = max_width,
          height = #options.items,
          title = options.name,
        })
      )
    end,
    buffer = self.bufnr,
  })
end

function M:select(index)
  if type(index) ~= "number" then
    return
  end
  if index < 1 or index > #self.items then
    return
  end
  vim.api.nvim_buf_clear_namespace(self.bufnr, self.ns_id, 0, -1)
  vim.api.nvim_buf_set_extmark(self.bufnr, self.ns_id, index - 1, 0, {
    hl_eol = true,
    line_hl_group = "CursorLine",
  })
  try(self.on_select, self.items[index])
end

function M:close()
  if self.winid and vim.api.nvim_win_is_valid(self.winid) then
    vim.api.nvim_win_close(self.winid, true)
    self.winid = nil
    self.bufnr = nil
    self.ns_id = nil
    self.on_select = nil
    self.on_close = nil
    self.items = nil
  end
end

function M:is_open()
  if self.winid and vim.api.nvim_win_is_valid(self.winid) then
    return true
  end
end

return M
