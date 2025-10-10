local M = {}
local api = vim.api

--- @class LineConcatOpts
--- @field join_char? string
--- @field trim_blank? boolean
--- @field input? boolean

local default_opts = {
  join_char = "",
  trim_blank = false,
  input = false,
}

local function restore_cursor_position(mode, start_row, cursor_pos)
  if mode == "V" then
    if cursor_pos[1] > start_row then
      api.nvim_win_set_cursor(0, { start_row, cursor_pos[2] })
    else
      api.nvim_win_set_cursor(0, cursor_pos)
    end
  else
    api.nvim_win_set_cursor(0, cursor_pos)
  end
end

local function set_visual_mark(start_row, end_row)
  local ns_id = vim.api.nvim_create_namespace("line_concat_input")
  vim.api.nvim_buf_set_extmark(0, ns_id, start_row - 1, 0, {
    end_row = end_row - 1,
    hl_group = "Visual",
  })
  vim.cmd.redraw()

  return function()
    vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)
  end
end

--- @class LineConcatCharOpts
--- @field join_char string
--- @field trim_blank boolean
--- @field start_row integer
--- @field end_row integer

function M.line_concat_char(opts)
  local join_char = opts.join_char
  local start_row = opts.start_row
  local end_row = opts.end_row
  local trim_blank = opts.trim_blank

  local new_line = ""
  local lines = api.nvim_buf_get_lines(0, start_row - 1, end_row - 1, false)

  for i, line in ipairs(lines) do
    if i == #lines then
      new_line = new_line .. line
    else
      if trim_blank then
        new_line = new_line .. line:gsub("%s*$", "") .. join_char
      else
        new_line = new_line .. line .. join_char
      end
    end
  end
  api.nvim_buf_set_lines(0, start_row - 1, end_row - 1, false, { new_line })

  return true
end

--- @class LineConcatInputOpts
--- @field prompt? string
--- @field start_row integer
--- @field end_row integer
--- @field callback? fun(text: string)
--- @field trim_blank boolean
---
--- @param opts LineConcatInputOpts
function M.line_concat_input_char(opts)
  local start_row = opts.start_row
  local end_row = opts.end_row
  local prompt = opts.prompt or "Join Chars: "
  local callback = opts.callback
  local trim_blank = opts.trim_blank

  local cleanup = set_visual_mark(start_row, end_row)
  vim.ui.input({ prompt = prompt }, function(text)
    cleanup()
    if text == nil then
      return
    end

    M.line_concat_char({
      join_char = text,
      start_row = start_row,
      end_row = end_row,
      trim_blank = trim_blank,
    })

    if callback then
      callback("")
    end
  end)
end

local function line_concat_input_char(opts, mode, start_mark, end_mark, cursor_pos)
  if not opts.input then
    return
  end

  M.line_concat_input_char({
    start_row = start_mark[1],
    end_row = end_mark[1] + 1,
    callback = function(text)
      restore_cursor_position(mode, start_mark[1], cursor_pos)
    end,
  })

  return true
end

local function line_concat_neovim_native(opts, mode, start_mark, end_mark, cursor_pos)
  local operator
  if opts.join_char == " " then
    operator = "J"
  end
  if opts.join_char == "" and opts.trim_blank == false then
    operator = "gJ"
  end

  if not operator then
    return
  end

  local line_count = end_mark[1] - start_mark[1]
  if line_count > 1 then
    line_count = line_count + 1
  end
  api.nvim_feedkeys(line_count .. operator, "nx", false)
  return true
end

--- @param opts? LineConcatOpts
function M.line_concat(opts)
  opts = vim.tbl_extend("force", default_opts, opts or {})
  local mode = api.nvim_get_mode().mode
  local cursor_pos = api.nvim_win_get_cursor(0)

  _G.custom_line_concat = function(type)
    if type ~= "line" then
      return
    end
    local start_mark = api.nvim_buf_get_mark(0, "[")
    local end_mark = api.nvim_buf_get_mark(0, "]")

    if line_concat_input_char(opts, mode, start_mark, end_mark, cursor_pos) then
      return
    end

    if line_concat_neovim_native(opts, mode, start_mark, end_mark, cursor_pos) then
      return
    end

    M.line_concat_char({
      join_char = opts.join_char,
      trim_blank = opts.trim_blank,
      start_row = start_mark[1],
      end_row = end_mark[1] + 1,
    })

    restore_cursor_position(mode, start_mark[1], cursor_pos)
  end

  vim.opt.operatorfunc = "v:lua.custom_line_concat"
end

function M.setup() end

return M
