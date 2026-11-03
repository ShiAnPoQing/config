--- @class my._atom._menu.buffer
--- @field buf integer
--- @field config my._atom._menu.buffer.Opts
local Buf = {}
Buf.__index = Buf

--- @class my._atom._menu.buffer.Opts
--- @field name? string
--- @field option? table<string, any>
--- @field on_line_count? fun()

--- @param opts my._atom._menu.buffer.Opts?
function Buf:new(opts)
  vim.validate("opts", opts, "table", true)
  opts = opts or {}
  vim.validate("opts.option", opts.option, "table", true)
  opts.option = opts.option or {}
  local o = setmetatable({}, self)
  o.buf = vim.api.nvim_create_buf(false, true)
  o.config = opts
  if opts.name and type(opts.name) == "string" then
    vim.api.nvim_buf_set_name(o.buf, opts.name)
  end
  for name, value in pairs(opts.option) do
    o:set_option(name, value)
  end
  return o
end

function Buf:get()
  return self.buf
end

function Buf:del()
  vim.api.nvim_buf_delete(self.buf, { force = true })
  self.buf = nil
end

--- @param name string
--- @param value any
function Buf:set_option(name, value)
  vim.api.nvim_set_option_value(name, value, { scope = "local", buf = self.buf })
end

--- @param start integer
--- @param end_ integer
--- @param lines string[]
function Buf:set_lines(start, end_, lines)
  local old_lines = vim.api.nvim_buf_get_lines(self.buf, 0, -1, false)
  vim.api.nvim_buf_set_lines(self.buf, start, end_, false, lines)
  local new_lines = vim.api.nvim_buf_get_lines(self.buf, 0, -1, false)
  if self.config.on_line_count and #old_lines ~= #new_lines then
    self.config.on_line_count()
  end
end

return Buf
