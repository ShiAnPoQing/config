local U = require("bufferman.utils")

--- @class Bufferman.UI
--- @field __items Bufferman.UI.Item[]
--- @field __selected_item Bufferman.UI.Item
--- @field ns_id integer
--- @field bufnr integer
--- @field winid integer
--- @field win_config vim.api.keyset.win_config
--- @field hook Bufferman.UI.Hook
local M = {}

--- @class Bufferman.UI.Hook.Submit.Context
--- @field items Bufferman.UI.Item[]
--- @field lines string[]
--- @field bang? boolean

--- @class Bufferman.UI.Hook.Select.Context
--- @field item Bufferman.UI.Item

--- @class Bufferman.UI.Hook.Select
--- @field callback fun(ctx: Bufferman.UI.Hook.Select.Context): any
--- @field keymap string[]

--- @class Bufferman.UI.Hook.Submit
--- @field callback fun(ctx: Bufferman.UI.Hook.Submit.Context)
--- @field keymap string[]

--- @class Bufferman.UI.Hook.Close
--- @field callback fun()
--- @field keymap string[]

--- @class Bufferman.UI.Hook
--- @field select? Bufferman.UI.Hook.Select
--- @field submit? Bufferman.UI.Hook.Submit
--- @field close? Bufferman.UI.Hook.Close

--- @class Bufferman.UI.Item
--- @field text string
--- @field selected? boolean
--- @field data? any

--- @class Bufferman.UI.Options: Bufferman.UI.Hook
--- @field items Bufferman.UI.Item[]
--- @field name string

local default_win_config = {
  relative = "editor",
  border = "rounded",
  style = "minimal",
  title_pos = "center",
  noautocmd = true,
}

local function resolve_win_config(config)
  local max_width = vim.o.columns
  local max_height = vim.o.lines
  config.width = math.max(math.min(config.width, max_width), #config.title + 2)
  config.height = math.min(config.height, max_height)
  config.row = math.ceil((max_height - config.height) / 2)
  config.col = math.ceil((max_width - config.width) / 2)
  return config
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
    max_width = math.max(max_width, #item.text + 1)
    if item.selected then
      selected_item_index = i
    end
    table.insert(lines, item.text)
  end
  return lines, selected_item_index, max_width
end

---@param options Bufferman.UI.Options
function M:open(options)
  self.ns_id = vim.api.nvim_create_namespace("bufferman.ui")
  self.hook = { select = options.select, close = options.close, submit = options.submit }
  self.bufnr = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_name(self.bufnr, "Bufferman")
  set_options({ buftype = "acwrite", filetype = "bufferman", modified = false }, { buf = self.bufnr })
  self.win_config = vim.tbl_deep_extend("force", default_win_config, { title = options.name })
  self:update(options.items)
  local select = self.hook.select
  local close = self.hook.close
  if select then
    for _, key in ipairs(select.keymap) do
      self:keymap(key, function()
        self:select(vim.api.nvim_win_get_cursor(self.winid)[1])
      end)
    end
  end
  if close then
    for _, key in ipairs(close.keymap) do
      self:keymap(key, function()
        vim.api.nvim_win_close(self.winid, true)
      end)
    end
  end
  self:_listen()
end

function M:_listen()
  self:on("VimResized", function()
    resolve_win_config(self.win_config)
    vim.api.nvim_win_set_config(self.winid, self.win_config)
  end)
  local pre_cmd
  self:on("CmdlineLeavePre", function()
    pre_cmd = vim.fn.getcmdline()
  end)
  self:on("BufWriteCmd", function()
    if pre_cmd == "w" then
      self:submit()
    elseif pre_cmd == "w!" then
      self:submit(true)
    end
  end)
  self:on("WinClosed", function()
    self:close()
  end)
  self:on("BufReadCmd", function(args)
    if args.buf == self.bufnr then
      self:update(self.__items)
    end
  end)
end

--- @param bang? boolean
function M:submit(bang)
  local submit = self.hook.submit
  if submit then
    U.try(submit.callback, {
      lines = vim.api.nvim_buf_get_lines(self.bufnr, 0, -1, false),
      items = self.__items,
      bang = bang,
    })
  end
end

--- @param items Bufferman.UI.Item
function M:update(items)
  self.__items = items
  local lines, selected_item_index, max_width = resolve_items(self.__items)
  self.win_config = vim.tbl_deep_extend("force", self.win_config, { height = #self.__items, width = max_width })
  resolve_win_config(self.win_config)
  if self.winid then
    vim.api.nvim_win_set_config(self.winid, self.win_config)
  else
    self.winid = vim.api.nvim_open_win(self.bufnr, true, self.win_config)
    set_options({ winfixbuf = true }, { win = self.winid })
  end
  set_options({ undolevels = -1 }, { buf = self.bufnr })
  vim.api.nvim_buf_set_lines(self.bufnr, 0, -1, false, lines)
  set_options({ undolevels = 1000 }, { buf = self.bufnr })
  self:select(selected_item_index)
end

function M:select(index, is_item_index)
  if type(index) ~= "number" then
    return
  end
  local item_index, item_row
  if is_item_index then
    item_index = index
    if item_index < 0 or item_index > #self.__items then
      return
    end
    local item = self.__items[item_index]
    for i, line in ipairs(vim.api.nvim_buf_get_lines(self.bufnr, 0, -1, false)) do
      line = vim.trim(line)
      if item.text == line then
        item_row = i
        break
      end
    end
  else
    item_row = index
    local lines = vim.api.nvim_buf_get_lines(self.bufnr, item_row - 1, item_row, false)
    if #lines == 0 then
      return
    end
    local line = vim.trim(lines[1])
    for i, item in ipairs(self.__items) do
      if item.text == line then
        item_index = i
        break
      end
    end
  end

  if not item_row or not item_index then
    return
  end

  local select = self.hook.select
  if select then
    --- @type Bufferman.UI.Hook.Select.Context
    local ctx = { item = self.__items[item_index] }
    if not U.try(select.callback, ctx) then
      return
    end
  end
  if self.__selected_item then
    self.__selected_item.selected = nil
  end
  self.__selected_item = self.__items[item_index]
  self.__selected_item.selected = true
  vim.api.nvim_buf_clear_namespace(self.bufnr, self.ns_id, 0, -1)
  vim.api.nvim_buf_set_extmark(self.bufnr, self.ns_id, item_row - 1, 0, {
    hl_eol = true,
    line_hl_group = "Visual",
    invalidate = true,
    undo_restore = false,
  })
  local cursor = vim.api.nvim_win_get_cursor(self.winid)
  vim.api.nvim_win_set_cursor(self.winid, { item_row, cursor[2] })
  return true
end

function M:close()
  if not self:is_open() then
    return
  end
  if self.hook.close then
    U.try(self.hook.close.callback)
  end
  vim.api.nvim_win_close(self.winid, true)
  vim.api.nvim_buf_delete(self.bufnr, { force = true })
  self.winid = nil
  self.bufnr = nil
  self.ns_id = nil
  self.hook = nil
  self.__items = nil
end

function M:is_open()
  return U.is_win_valid(self.winid)
end

--- @param event vim.api.keyset.events|vim.api.keyset.events[]
--- @param callback fun(args: vim.api.keyset.create_autocmd.callback_args)
function M:on(event, callback)
  if type(event) ~= "string" and type(event) ~= "table" then
    vim.api.nvim_echo({ { "evenst must be a string or string[]", "ErrorMsg" } }, false, {})
    return
  end
  vim.api.nvim_create_autocmd(event, { callback = callback, buffer = self.bufnr })
end

--- @param lhs string
--- @param callback fun()
function M:keymap(lhs, callback)
  vim.keymap.set("n", lhs, callback, { buffer = self.bufnr, noremap = true, nowait = true })
end

--- @param width integer
function M:fit_width(width)
  vim.validate("width", width, "number", true, "width must be number")
  local lines = vim.api.nvim_buf_get_lines(self.bufnr, 0, -1, false)
  local _max_width = 0
  for _, line in ipairs(lines) do
    _max_width = math.max(#line + 1, _max_width)
  end
  if width < _max_width then
    width = _max_width
  end
  self.win_config.width = width
  local max_width = vim.o.columns
  self.win_config.width = math.max(math.min(self.win_config.width or 0, max_width), #self.win_config.title + 2)
  self.win_config.col = math.ceil((max_width - self.win_config.width) / 2)
  vim.api.nvim_win_set_config(self.winid, self.win_config)
end

--- @param height integer
function M:fit_height(height)
  vim.validate("height", height, "number", true, "height must be number")
  if height == self.win_config.height then
    return
  end
  self.win_config.height = height
  local max_height = vim.o.lines
  self.win_config.height = math.min(self.win_config.height, max_height)
  self.win_config.row = math.ceil((max_height - self.win_config.height) / 2)
  vim.api.nvim_win_set_config(self.winid, self.win_config)
end

function M:is_item(row)
  if not self:is_open() then
    return false
  end

  local line = vim.api.nvim_buf_get_lines(self.bufnr, row - 1, row, false)[1]
  line = vim.trim(line)

  for _, item in ipairs(self.__items or {}) do
    if item.text == line then
      return true
    end
  end

  return false
end

function M:get_selected_item()
  return self.__selected_item
end

function M:get_items()
  return self.__items
end

function M:get_cursor_item()
  if not self:is_open() then
    return
  end
  local cursor = vim.api.nvim_win_get_cursor(self.winid)
  local line = vim.api.nvim_buf_get_lines(self.bufnr, cursor[1] - 1, cursor[1], false)[1]
  line = vim.trim(line)
  for _, item in ipairs(self.__items) do
    if item.text == line then
      return item
    end
  end
end

function M:select_next()
  if not self:is_open() then
    return
  end
  local start
  for i, line in ipairs(vim.api.nvim_buf_get_lines(self.bufnr, 0, -1, false)) do
    line = vim.trim(line)
    if start then
      if self:select(i) then
        return true
      end
    end
    if line == self.__selected_item.text then
      start = true
    end
  end
  return self:select(1, true)
end

function M:select_prev()
  if not self:is_open() then
    return
  end
  local start
  local lines = vim.iter(vim.api.nvim_buf_get_lines(self.bufnr, 0, -1, false)):rev():totable()
  for i, line in ipairs(lines) do
    line = vim.trim(line)
    if start then
      if self:select(#lines - i + 1) then
        return true
      end
    end
    if line == self.__selected_item.text then
      start = true
    end
  end
  return self:select(#self.__items, true)
end

return M
