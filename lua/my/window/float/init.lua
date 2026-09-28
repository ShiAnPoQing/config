--- @class my.window.float
--- @field drag my.window.float.drag
local M = vim._defer_require("my.window.float", {
  drag = ..., --- @module 'my.window.float.drag'
})

--- @param opts my.window.float.ResizeOpts?
--- @return my.window.float.ResizeOpts
local function resolve_resize_opts(opts)
  opts = opts or {}
  vim.validate("opts.relative", opts.relative, "boolean", true)
  vim.validate("opts.anchor", opts.anchor, "table", true)
  local anchor = opts.anchor or {}
  anchor.x = anchor.x or -1
  anchor.y = anchor.y or -1
  if anchor.x ~= nil and anchor.x ~= 0 and anchor.x ~= -1 and anchor.x ~= 1 then
    error("my.window.float.resize: invalid anchor.x")
  end
  if anchor.y ~= nil and anchor.y ~= 0 and anchor.y ~= -1 and anchor.y ~= 1 then
    error("my.window.float.resize: invalid anchor.y")
  end

  return { relative = opts.relative, anchor = anchor }
end

--- @class my.window.float.Anchor
--- @field x? -1|0|1
--- @field y? -1|0|1

--- @class my.window.float.ResizeOpts
--- @field anchor my.window.float.Anchor?
--- @field relative? boolean

--- @param win integer
--- @param width integer
--- @param height integer
--- @param opts my.window.float.ResizeOpts?
function M.resize(win, width, height, opts)
  vim.validate("win", win, "number")
  vim.validate("width", width, "number")
  vim.validate("height", height, "number")
  vim.validate("opts", opts, "table", true)

  if not vim.api.nvim_win_is_valid(win) then
    error("my.window.float.resize: invalid window")
  end

  if not M.is_float(win) then
    error("my.window.float.resize: not a floating window")
  end

  local config = vim.api.nvim_win_get_config(win)

  opts = resolve_resize_opts(opts)
  local w_delta, h_delta
  if not opts.relative then
    w_delta = width - config.width
    h_delta = height - config.height
  else
    w_delta = width
    h_delta = height
  end
  if opts.anchor.x == 1 then
    config.col = config.col - w_delta
  elseif opts.anchor.x == 0 then
    config.col = config.col - math.floor(w_delta / 2)
  end
  if opts.anchor.y == -1 then
    config.row = config.row - h_delta
  elseif opts.anchor.y == 0 then
    config.row = config.row - math.floor(h_delta / 2)
  end
  config.width = config.width + w_delta
  config.height = config.height + h_delta
  vim.api.nvim_win_set_config(win, config)
end

--- @class my.window.float.PlaceOpts
--- @field anchor? "NW"|"NE"|"SW"|"SE"|"C"

--- @param opts my.window.float.PlaceOpts?
local function resolve_place_opts(opts)
  opts = opts or {}

  vim.validate("opts.anchor", opts.anchor, "string", true)
  local anchor = opts.anchor or "NW"
  if
    opts.anchor ~= "NW"
    and opts.anchor ~= "NE"
    and opts.anchor ~= "SW"
    and opts.anchor ~= "SE"
    and opts.anchor ~= "C"
  then
    error("my.window.float.place: invalid anchor")
  end
  return { anchor = anchor }
end

local function get_border_size(border)
  if type(border) == "table" and border[1][1] ~= "" then
    return 1
  end
  return 0
end

--- @param win integer
--- @param row integer
--- @param col integer
--- @param opts my.window.float.PlaceOpts?
function M.place(win, row, col, opts)
  vim.validate("win", win, "number")
  vim.validate("row", row, "number")
  vim.validate("col", col, "number")
  vim.validate("opts", opts, "table", true)

  if not vim.api.nvim_win_is_valid(win) then
    error("my.window.float.place: invalid window")
  end

  if not M.is_float(win) then
    error("my.window.float.place: not a floating window")
  end

  local config = vim.api.nvim_win_get_config(win)
  opts = resolve_place_opts(opts)
  local pos = vim.api.nvim_win_get_position(win)
  local offset_row, offset_col = 0, 0
  if opts.anchor == "NE" then
    offset_col = -config.width
  elseif opts.anchor == "SW" then
    offset_row = -config.height
  elseif opts.anchor == "SE" then
    offset_row = -config.height
    offset_col = -config.width
  elseif opts.anchor == "C" then
    offset_row = -math.floor(config.height / 2)
    offset_col = -math.floor(config.width / 2)
  end

  local border_size = get_border_size(config.border)
  offset_col = offset_col - 2 * border_size
  offset_row = offset_row - 2 * border_size
  config.row = config.row + (row - pos[1]) + offset_row
  config.col = config.col + (col - pos[2]) + offset_col
  vim.api.nvim_win_set_config(win, config)
end

--- @class my.window.float.MoveOpts

--- @param opts my.window.float.MoveOpts?
local function resolve_move_opts(opts)
  opts = opts or {}
end

--- @param win integer
--- @param drow integer
--- @param dcol integer
--- @param opts my.window.float.MoveOpts?
function M.move(win, drow, dcol, opts)
  vim.validate("win", win, "number")
  vim.validate("drow", drow, "number")
  vim.validate("dcol", dcol, "number")
  vim.validate("opts", opts, "table", true)

  if not vim.api.nvim_win_is_valid(win) then
    error("my.window.float.move: invalid window")
  end

  if not M.is_float(win) then
    error("my.window.float.move: not a floating window")
  end

  local config = vim.api.nvim_win_get_config(win)
  opts = resolve_move_opts(opts)
  local border_size = get_border_size(config.border)
  config.row = config.row + drow
  config.col = config.col + dcol
  if config.row < 0 then
    config.row = 0
  end
  if config.col < 0 then
    config.col = 0
  end
  config.row = math.min(config.row, vim.o.lines - vim.o.cmdheight - 2 * border_size - config.height)
  config.col = math.min(config.col, vim.o.columns - 2 * border_size - config.width)
  vim.api.nvim_win_set_config(win, config)
end

--- @param win integer
--- @return boolean
function M.is_float(win)
  vim.validate("win", win, "number")
  if vim.api.nvim_win_is_valid(win) then
    local config = vim.api.nvim_win_get_config(win)
    return config.relative ~= ""
  end
  return false
end

--- @param file string?
function M.edit(file)
  file = file or vim.api.nvim_buf_get_name(0)
  local buf = vim.api.nvim_create_buf(false, true)
  local width = math.floor(0.5 * vim.o.columns)
  local height = math.floor(0.5 * vim.o.lines)
  local row = math.floor(vim.o.lines / 2 - (height + 2) / 2)
  local col = math.floor(vim.o.columns / 2 - (width + 2) / 2)
  vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = math.floor(0.5 * vim.o.columns),
    height = math.floor(0.5 * vim.o.lines),
    row = row,
    col = col,
    title = file,
    title_pos = "center",
    style = "minimal",
    border = "single",
  })
  vim.cmd.edit(file)
end

function M.view(file)
  file = file or vim.api.nvim_buf_get_name(0)
  local buf = vim.api.nvim_create_buf(false, true)
  local width = math.floor(0.5 * vim.o.columns)
  local height = math.floor(0.5 * vim.o.lines)
  local row = math.floor(vim.o.lines / 2 - (height + 2) / 2)
  local col = math.floor(vim.o.columns / 2 - (width + 2) / 2)
  vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = math.floor(0.5 * vim.o.columns),
    height = math.floor(0.5 * vim.o.lines),
    row = row,
    col = col,
    title = file,
    title_pos = "center",
    border = "single",
  })
  vim.cmd.edit(file)
  vim.bo.readonly = true
end

vim.api.nvim_create_user_command("FloatEdit", function(args)
  my.window.float.edit(args.fargs[1])
end, {
  nargs = "?",
  complete = "file",
})

vim.api.nvim_create_user_command("FloatView", function(args)
  my.window.float.view(args.fargs[1])
end, {
  nargs = "?",
  complete = "file",
})

return M
