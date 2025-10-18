local M = {}

local function get_virt_col()
  return vim.fn.virtcol(".")
end

local function get_cursor()
  return vim.api.nvim_win_get_cursor(0)
end

local function get_visual_mark()
  local start_row, start_col = unpack(vim.api.nvim_buf_get_mark(0, "<"))
  local end_row, end_col = unpack(vim.api.nvim_buf_get_mark(0, ">"))
  return start_row, start_col, end_row, end_col
end

--- @param keys string
--- @param mode string
--- @param escape_ks boolean
local function feedkeys(keys, mode, escape_ks)
  vim.api.nvim_feedkeys(keys, mode, escape_ks)
end

local function set_cursor(row, col)
  vim.api.nvim_win_set_cursor(0, { row, col })
end

local function esc()
  feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, true, true), "nx", true)
end

local function ctrl_g()
  local key = vim.api.nvim_replace_termcodes("<C-g>", true, true, true)
  feedkeys(key, "n", false)
end

local function gv()
  feedkeys("gv", "nx", false)
end

local function o()
  feedkeys("o", "nx", false)
end

local function get_count()
  return vim.v.count1
end

local function get_mode()
  return vim.api.nvim_get_mode().mode
end

local function is_visual_block_mode(mode)
  return mode == ""
end

local function is_select_block_mode(mode)
  return mode == ""
end

local function is_visual_or_visual_line_mode(mode)
  return mode == "V" or mode == "v"
end

local function is_select_or_select_line_mode(mode)
  return mode == "s" or mode == "S"
end

local function set_cursor_at_visual_start_mark()
  local virt_col1 = get_virt_col()
  o()
  local virt_col2 = get_virt_col()
  if virt_col2 > virt_col1 then
    o()
  end
end

local function set_cursor_at_visual_end_mark()
  local virt_col1 = get_virt_col()
  o()
  local virt_col2 = get_virt_col()
  if virt_col2 < virt_col1 then
    o()
  end
end

local function get_visual_start_mark_virt_col(start_row, start_col, end_row, end_col)
  local cursor_row, cursor_col = unpack(get_cursor())
  gv()
  if start_col == end_col and start_row == end_row then
    set_cursor_at_visual_start_mark()
  else
    if cursor_row == start_row and cursor_col + 1 == start_col then
      if cursor_row == end_row and cursor_col + 1 == end_col then
        set_cursor_at_visual_start_mark()
      end
    else
      o()
    end
  end

  local virt_col = get_virt_col()
  esc()
  return virt_col
end

local function get_visual_end_mark_virt_col(start_row, start_col, end_row, end_col)
  local cursor_row, cursor_col = unpack(get_cursor())

  gv()
  if start_col == end_col and start_row == end_row then
    set_cursor_at_visual_end_mark()
  else
    if cursor_row == end_row and cursor_col + 1 == end_col then
      if cursor_row == start_row and cursor_col + 1 == start_col then
        set_cursor_at_visual_end_mark()
      end
    else
      o()
    end
  end

  local virt_col = get_virt_col()
  esc()
  return virt_col
end

function M.first_non_black_character(after)
  local count = get_count()
  local mode = get_mode()
  vim.schedule(function()
    after()
  end)
  if is_visual_or_visual_line_mode(mode) or is_select_or_select_line_mode(mode) then
    esc()
    local start_row, start_col, end_row, end_col = get_visual_mark()
    local start_line = vim.api.nvim_buf_get_lines(0, start_row - 1, start_row, true)[1]

    if #start_line == start_col then
      local virt_col = get_visual_start_mark_virt_col(start_row, start_col, end_row, end_col)
      set_cursor(start_row, start_col)
      feedkeys(virt_col - start_col - 1 .. "l" .. count .. "i", "n", false)
    else
      local first_text = vim.api.nvim_buf_get_text(0, start_row - 1, start_col, end_row - 1, end_col + 1, {})[1]
      local sc = first_text:find("%S")
      if sc then
        sc = sc - 1
      else
        sc = 0
      end
      set_cursor(start_row, sc + start_col)
      feedkeys(count .. "i", "n", false)
    end
    return
  end

  if is_visual_block_mode(mode) then
    feedkeys(count .. "I", "n", false)
    return
  end

  if is_select_block_mode(mode) then
    ctrl_g()
    feedkeys(count .. "I", "n", false)
    return
  end
end

function M.first_character()
  local count = get_count()
  local mode = get_mode()

  if is_visual_or_visual_line_mode(mode) or is_select_or_select_line_mode(mode) then
    esc()
    local start_row, start_col, end_row, end_col = get_visual_mark()
    local start_line = vim.api.nvim_buf_get_lines(0, start_row - 1, start_row, true)[1]

    if #start_line == start_col then
      local virt_col = get_visual_start_mark_virt_col(start_row, start_col, end_row, end_col)
      set_cursor(start_row, start_col)
      feedkeys(virt_col - start_col - 1 .. "l" .. count .. "i", "n", false)
    else
      set_cursor(start_row, start_col)
      feedkeys(count .. "i", "n", false)
    end

    return
  end

  if is_visual_block_mode(mode) then
    feedkeys(count .. "I", "n", false)
    return
  end

  if is_select_block_mode(mode) then
    ctrl_g()
    feedkeys(count .. "I", "n", false)
    return
  end
end

function M.last_non_black_character(after)
  local count = get_count()
  local mode = get_mode()

  vim.schedule(function()
    after()
  end)

  if is_visual_or_visual_line_mode(mode) or is_select_or_select_line_mode(mode) then
    esc()
    local start_row, start_col, end_row, end_col = get_visual_mark()
    local end_line = vim.api.nvim_buf_get_lines(0, end_row - 1, end_row, true)[1]

    if end_col == #end_line then
      local text = vim.api.nvim_buf_get_text(0, start_row - 1, start_col, end_row - 1, end_col + 1, {})
      local last_text = text[#text]
      local sc = last_text:reverse():find("%S")
      if not sc then
        local virt_col = get_visual_end_mark_virt_col(start_row, start_col, end_row, end_col)
        set_cursor(end_row, end_col)
        feedkeys(virt_col - end_col - 1 .. "l" .. count .. "a", "n", false)
      else
        set_cursor(end_row, end_col - sc)
        feedkeys(count .. "a", "n", false)
      end
    else
      local text = vim.api.nvim_buf_get_text(0, start_row - 1, start_col, end_row - 1, end_col + 1, {})
      local last_text = text[#text]
      local sc = last_text:reverse():find("%S")
      if sc then
        sc = sc - 1
      else
        sc = 0
      end
      set_cursor(end_row, end_col - sc)
      feedkeys(count .. "a", "n", false)
    end
    return
  end

  if is_visual_block_mode(mode) then
    feedkeys(count .. "A", "n", false)
    return
  end

  if is_select_block_mode(mode) then
    ctrl_g()
    feedkeys(count .. "A", "n", false)
  end
end

function M.last_character()
  local count = get_count()
  local mode = get_mode()

  if is_visual_or_visual_line_mode(mode) or is_select_or_select_line_mode(mode) then
    esc()
    local start_row, start_col, end_row, end_col = get_visual_mark()
    local end_line = vim.api.nvim_buf_get_lines(0, end_row - 1, end_row, true)[1]

    if end_col == #end_line then
      local virt_col = get_visual_end_mark_virt_col(start_row, start_col, end_row, end_col)
      set_cursor(end_row, end_col)
      feedkeys(virt_col - end_col - 1 .. "l" .. count .. "a", "n", false)
    else
      set_cursor(end_row, end_col)
      feedkeys(count .. "a", "n", false)
    end

    return
  end

  if is_visual_block_mode(mode) then
    feedkeys(count .. "A", "n", false)
    return
  end

  if is_select_block_mode(mode) then
    ctrl_g()
    feedkeys(count .. "A", "n", false)
    return
  end
end

return M
