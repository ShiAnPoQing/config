local M = {}

local SELECT_MODE = "gh"
local VISUAL_MODE = "v"
local SELECT_BLOCK_MODE = "gH"
local VISUAL_BLOCK_MODE = "<C-v>"
local ESC = "<esc>"
local RIGHT_ESC = "<right><esc>"
local IGNORE = "<Ignore>"

local function get_select_key(block_mode)
  return block_mode and SELECT_BLOCK_MODE or SELECT_MODE
end

local function get_visual_key(block_mode)
  return block_mode and VISUAL_BLOCK_MODE or VISUAL_MODE
end

function M.left_select(count, block_mode)
  if vim.api.nvim_win_get_cursor(0)[2] == 0 then
    return IGNORE
  end
  return ESC .. get_select_key(block_mode) .. vim.fn["repeat"]("<left>", count - 1)
end

function M.right_select(count, block_mode)
  local cursor = vim.api.nvim_win_get_cursor(0)
  local select = get_select_key(block_mode) .. vim.fn["repeat"]("<right>", count - 1)
  if cursor[2] == 0 then
    return ESC .. select
  end

  local line = vim.api.nvim_get_current_line()
  if #line == cursor[2] then
    return IGNORE
  end
  return RIGHT_ESC .. select
end

function M.down_select(count, block_mode)
  local cursor = vim.api.nvim_win_get_cursor(0)
  local line_count = vim.api.nvim_buf_line_count(0)
  local line = vim.api.nvim_get_current_line()
  local visual = get_visual_key(block_mode)
  if #line == cursor[2] then
    if cursor[1] == line_count then
      return IGNORE
    end
    local down = vim.fn["repeat"]("<down>", count)
    local up = vim.fn["repeat"]("<down>", count - 1)
    return down .. RIGHT_ESC .. visual .. up .. "0o<C-g>"
  end
  if cursor[1] == line_count then
    return RIGHT_ESC .. visual .. "$<C-g>"
  end
  return RIGHT_ESC .. visual .. count .. "j<C-g>"
end

function M.up_select(count, block_mode)
  local cursor = vim.api.nvim_win_get_cursor(0)
  local visual = get_visual_key(block_mode)
  if cursor[2] == 0 then
    if cursor[1] == 1 then
      return IGNORE
    end
    local up = vim.fn["repeat"]("<up>", count - 1)
    return "<up><esc>$" .. visual .. up .. "0<C-g>"
  end
  if cursor[1] == 1 then
    return ESC .. visual .. "0<C-g>"
  end
  return ESC .. visual .. count .. "k<C-g>"
end

function M.select_to_first_non_blank_character(block_mode)
  local cursor = vim.api.nvim_win_get_cursor(0)
  local line = vim.api.nvim_get_current_line()
  local col = line:find("%S")
  if not col then
    return IGNORE
  end

  local visual = get_visual_key(block_mode)
  if cursor[2] > col - 1 then
    return ESC .. visual .. "^<C-g>"
  elseif cursor[2] == col - 1 then
    return IGNORE
  else
    return RIGHT_ESC .. visual .. "^h<C-g>"
  end
end

function M.select_to_last_non_blank_character(block_mode)
  local cursor = vim.api.nvim_win_get_cursor(0)
  local line = vim.api.nvim_get_current_line()
  local reverse_col = line:reverse():find("%S")
  local visual = get_visual_key(block_mode)
  if not reverse_col then
    return IGNORE
  end

  local col = #line - reverse_col
  if cursor[2] == col + 1 then
    return IGNORE
  elseif cursor[2] > col + 1 then
    return ESC .. visual .. "g_l<C-g>"
  else
    return RIGHT_ESC .. visual .. "g_<C-g>"
  end
end

function M.select_to_first_character(block_mode)
  local line = vim.api.nvim_get_current_line()
  local cursor = vim.api.nvim_win_get_cursor(0)
  if #line == 0 or cursor[2] == 0 then
    return IGNORE
  end
  local visual = get_visual_key(block_mode)
  return ESC .. visual .. "0<C-g>"
end

function M.select_to_last_character(block_mode)
  local line = vim.api.nvim_get_current_line()
  local cursor = vim.api.nvim_win_get_cursor(0)
  if #line == cursor[2] or cursor[2] == 0 then
    return IGNORE
  end
  local visual = get_visual_key(block_mode)
  return RIGHT_ESC .. visual .. "$<C-g>"
end

function M.select_to_next_word_end(is_WORD, block_mode)
  local cursor = vim.api.nvim_win_get_cursor(0)
  local line = vim.api.nvim_get_current_line()
  local line_count = vim.api.nvim_buf_line_count(0)

  local motion = is_WORD and "E" or "e"
  local visual = get_visual_key(block_mode)
  if #line == cursor[2] then
    if cursor[1] == line_count then
      return IGNORE
    end
    return "<down><esc>0v" .. motion .. "<C-g>"
  end
  return RIGHT_ESC .. visual .. motion .. "<C-g>"
end

function M.select_to_previous_word_start(is_WORD, block_mode)
  local cursor = vim.api.nvim_win_get_cursor(0)
  local visual = get_visual_key(block_mode)
  local keys = is_WORD and visual .. "B<C-g>" or "gh<S-left>"
  if cursor[2] == 0 then
    if cursor[1] == 1 then
      return IGNORE
    end
    return "<up><esc>$" .. keys
  end
  return ESC .. keys
end

function M.select_to_next_word_start(is_WORD, block_mode)
  local cursor = vim.api.nvim_win_get_cursor(0)
  local line = vim.api.nvim_get_current_line()
  local line_count = vim.api.nvim_buf_line_count(0)

  local motion = is_WORD and "W" or "w"
  local visual = get_visual_key(block_mode)
  if #line == cursor[2] then
    if cursor[1] == line_count then
      return IGNORE
    end
    return "<down><esc>0v" .. motion .. "h" .. "<C-g>"
  end
  return RIGHT_ESC .. visual .. "l" .. motion .. "h" .. "<C-g>"
end

function M.select_to_previous_word_end(is_WORD, block_mode)
  local cursor = vim.api.nvim_win_get_cursor(0)
  local motion = is_WORD and "gE" or "ge"
  local visual = get_visual_key(block_mode)
  if cursor[2] == 0 then
    if cursor[1] == 1 then
      return IGNORE
    end
    return "<up><esc>$" .. visual .. motion .. "l" .. "<C-g>"
  end
  return ESC .. visual .. "h" .. motion .. "l" .. "<C-g>"
end

function M.select_middle_of_line(block_mode)
  local cursor = vim.api.nvim_win_get_cursor(0)
  local line = vim.api.nvim_get_current_line()
  local visual = get_visual_key(block_mode)
  if math.ceil(#line / 2) > cursor[2] then
    return RIGHT_ESC .. visual("gM<C-g>")
  else
    return ESC .. visual .. "gM<C-g>"
  end
end

return M
