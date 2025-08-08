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

--- @param opts LineConcatOpts
local function neovim_native_join(opts)
  local operator
  if opts.join_char == " " then
    operator = "J"
  end
  if opts.join_char == "" and opts.trim_blank == false then
    operator = "gJ"
  end

  return operator and {
    operator = operator,
  } or nil
end

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

local function set_visual_mark(mode, start_row, end_row)
  local ns_id
  if mode ~= "v" and mode ~= "V" then
    ns_id = vim.api.nvim_create_namespace("line_concat_input")
    vim.api.nvim_buf_set_extmark(0, ns_id, start_row - 1, 0, {
      end_row = end_row - 1,
      hl_group = "Visual",
    })
    vim.cmd.redraw()
  end

  return function()
    if ns_id then
      vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)
    end
  end
end

local function line_concat_input(start_mark, end_mark, mode, cursor_pos)
  local start_row = start_mark[1]
  local end_row = end_mark[1] + 1

  local cleanup = set_visual_mark(mode, start_row, end_row)
  vim.ui.input({ prompt = "请输入内容:" }, function(text)
    cleanup()
    if text == nil then
      return
    end

    local new_line = ""
    local lines = api.nvim_buf_get_lines(0, start_row - 1, end_row - 1, false)

    for i, line in ipairs(lines) do
      if i == #lines then
        new_line = new_line .. line
      else
        new_line = new_line .. line:gsub("%s*$", "") .. text
      end
    end
    api.nvim_buf_set_lines(0, start_row - 1, end_row - 1, false, { new_line })
    restore_cursor_position(mode, start_row, cursor_pos)
  end)
end

local function line_concat_neovim_native_join(neovim_native, line_count, mode, start_mark, cursor_pos)
  api.nvim_feedkeys(line_count .. neovim_native.operator, "nx", false)
  restore_cursor_position(mode, start_mark[1], cursor_pos)
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
    local line_count = end_mark[1] - start_mark[1]
    if line_count > 1 then
      line_count = line_count + 1
    end

    if opts.input then
      line_concat_input(start_mark, end_mark, mode, cursor_pos)
      return
    end

    local neovim_native = neovim_native_join(opts)
    if neovim_native_join then
      line_concat_neovim_native_join(neovim_native, line_count, mode, start_mark, cursor_pos)
      return
    end

    -- TODO: trim_blank

    -- if trim_blank then
    --
    -- else
    --   local lines = api.nvim_buf_get_lines(0, start_mark[1], end_mark[1], false)
    --   vim.print(lines)
    -- end
    -- restore_cursor_position(mode, start_mark[1], cursor_pos)
  end

  vim.opt.operatorfunc = "v:lua.custom_line_concat"
end

return M
