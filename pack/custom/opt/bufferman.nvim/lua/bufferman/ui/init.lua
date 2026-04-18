--- @class Bufferman.UI
--- @field items Bufferman.UI.Item[]
--- @field selected_item Bufferman.UI.Item
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

--- @generic T
--- @param fn fun(...: T)
--- @param ... T
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
  local lines, selected_item_index, max_width = resolve_items(options.items)
  self.ns_id = vim.api.nvim_create_namespace("bufferman.ui")
  self.hook = {
    select = options.select,
    close = options.close,
    submit = options.submit,
  }
  self.items = options.items
  self.bufnr = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_name(self.bufnr, "Bufferman")
  self.win_config = vim.tbl_deep_extend(
    "force",
    default_win_config,
    { height = #options.items, width = max_width, title = options.name }
  )
  resolve_win_config(self.win_config)
  self.winid = vim.api.nvim_open_win(self.bufnr, true, self.win_config)
  vim.api.nvim_buf_set_lines(self.bufnr, 0, -1, false, lines)
  set_options({ buftype = "acwrite", filetype = "bufferman", modified = false }, { buf = self.bufnr })
  set_options({ winfixbuf = true }, { win = self.winid })

  local Update = require("bufferman.ui.update"):new(self.bufnr)
  Update:attach({
    added = function() end,
    removed = function() end,
  })

  self:select(selected_item_index)

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
        self:close()
      end)
    end
  end
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
      set_options(
        { buftype = "acwrite", filetype = "bufferman", modified = false, buflisted = false },
        { buf = self.bufnr }
      )
    end
  end)
end

--- @param bang? boolean
function M:submit(bang)
  local submit = self.hook.submit
  if submit then
    try(submit.callback, {
      lines = vim.api.nvim_buf_get_lines(self.bufnr, 0, -1, false),
      items = self.items,
      bang = bang,
    })
  end
end

--- @param items Bufferman.UI.Item
function M:update(items)
  self.items = items
  local lines, selected_item_index, max_width = resolve_items(self.items)
  self.win_config = vim.tbl_deep_extend("force", self.win_config, { height = #self.items, width = max_width })
  resolve_win_config(self.win_config)
  vim.api.nvim_win_set_config(self.winid, self.win_config)
  vim.api.nvim_buf_set_lines(self.bufnr, 0, -1, false, lines)
  self:select(selected_item_index)
end

function M:select(index)
  if type(index) ~= "number" then
    return
  end
  if index < 1 or index > #self.items then
    return
  end
  local select = self.hook.select
  if select then
    --- @type Bufferman.UI.Hook.Select.Context
    local ctx = { item = self.items[index] }
    if not try(select.callback, ctx) then
      return
    end
  end
  if self.selected_item then
    self.selected_item.selected = nil
  end
  self.selected_item = self.items[index]
  self.selected_item.selected = true
  vim.api.nvim_buf_clear_namespace(self.bufnr, self.ns_id, 0, -1)
  vim.api.nvim_buf_set_extmark(self.bufnr, self.ns_id, index - 1, 0, {
    hl_eol = true,
    line_hl_group = "Visual",
    invalidate = true,
    undo_restore = false,
  })
  local cursor = vim.api.nvim_win_get_cursor(self.winid)
  vim.schedule(function()
    vim.api.nvim_win_set_cursor(self.winid, { index, cursor[2] })
  end)
end

function M:close()
  if self.hook.close then
    try(self.hook.close.callback)
  end

  if self.winid and vim.api.nvim_win_is_valid(self.winid) then
    vim.api.nvim_win_close(self.winid, true)
    pcall(vim.api.nvim_buf_delete, self.bufnr, { force = true })
    self.winid = nil
    self.bufnr = nil
    self.ns_id = nil
    self.hook = nil
    self.items = nil
  end
end

function M:is_open()
  if self.winid and vim.api.nvim_win_is_valid(self.winid) then
    return true
  end
end

--- @param event vim.api.keyset.events|vim.api.keyset.events[]
--- @param callback fun(args: vim.api.keyset.create_autocmd.callback_args)
function M:on(event, callback, opts)
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

return M
