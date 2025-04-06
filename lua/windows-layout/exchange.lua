local M = {}

--- @alias WinPos {
---   start_row: number,
---   end_row: number,
---   start_col: number,
---   end_col: number,
---   win: number,
--- }

--- @alias MatchCondition fun(win_pos:WinPos, current_win_pos: WinPos): boolean
--- @alias CursorPointerCondition fun(match_win_pos: WinPos, current_win_pos: WinPos): boolean
--- @alias SortFunc fun(a: WinPos, b: WinPos): boolean;

--- @alias ActionLogic {
---    match_condition: MatchCondition,
---    cursor_pointer_condition: CursorPointerCondition,
---    sort_func: SortFunc,
--- }

--- @alias ActionType {
---    up: ActionLogic,
---    down: ActionLogic,
---    left: ActionLogic,
---    right: ActionLogic,
--- }


--- @param current_win_id number
--- @param win_id number
function M.exchange(current_win_id, win_id)
  local api = vim.api
  local fn = vim.fn

  local current_buf = api.nvim_win_get_buf(current_win_id)
  local buf = api.nvim_win_get_buf(win_id)

  if current_buf == buf then
    api.nvim_set_current_win(current_win_id)
    local current_view = fn.winsaveview()
    api.nvim_set_current_win(win_id)
    local view = fn.winsaveview()

    api.nvim_set_current_win(current_win_id)
    fn.winrestview(view)
    api.nvim_set_current_win(win_id)
    fn.winrestview(current_view)
  else
    api.nvim_win_set_buf(current_win_id, buf)
    api.nvim_win_set_buf(win_id, current_buf)
    api.nvim_set_current_win(win_id)
  end
end

--- @return boolean
local function isCursorPointer(num, min, max)
  return num >= min and num <= max
end

--- @param match_win_pos WinPos
--- @param current_win_pos WinPos
--- @return boolean
local function isCursorPointer_left_right(match_win_pos, current_win_pos)
  return isCursorPointer(vim.fn.winline() + current_win_pos.start_row, match_win_pos.start_row, match_win_pos.end_row)
end

--- @param match_win_pos WinPos
--- @param current_win_pos WinPos
--- @return boolean
local function isCursorPointer_up_down(match_win_pos, current_win_pos)
  return isCursorPointer(vim.fn.wincol() + current_win_pos.start_col, match_win_pos.start_col, match_win_pos.end_col)
end

--- @param win_pos WinPos
--- @param current_win_pos WinPos
--- @return boolean
local function isInnerRow(win_pos, current_win_pos)
  return win_pos.start_row <= current_win_pos.end_row and win_pos.end_row >= current_win_pos.start_row
end

--- @param win_pos WinPos
--- @param current_win_pos WinPos
--- @return boolean
local function isInnerCol(win_pos, current_win_pos)
  return win_pos.start_col <= current_win_pos.end_col and win_pos.end_col >= current_win_pos.start_col
end


--- @type ActionType
local Action = {
  ["right"] = {
    match_condition = function(win_pos, current_win_pos)
      return win_pos.start_col >= current_win_pos.start_col and isInnerRow(win_pos, current_win_pos)
    end,
    cursor_pointer_condition = isCursorPointer_left_right,
    sort_func = function(a, b)
      return a.end_col < b.end_col
    end
  },
  ["left"] = {
    match_condition = function(win_pos, current_win_pos)
      return win_pos.start_col <= current_win_pos.start_col and isInnerRow(win_pos, current_win_pos)
    end,
    cursor_pointer_condition = isCursorPointer_left_right,
    sort_func = function(a, b)
      return a.end_col > b.end_col
    end
  },
  ["down"] = {
    match_condition = function(win_pos, current_win_pos)
      return win_pos.start_row >= current_win_pos.start_row and isInnerCol(win_pos, current_win_pos)
    end,
    cursor_pointer_condition = isCursorPointer_up_down,
    sort_func = function(a, b)
      return a.end_row < b.end_row
    end
  },
  ['up'] = {
    match_condition = function(win_pos, current_win_pos)
      return win_pos.start_row <= current_win_pos.start_row and isInnerCol(win_pos, current_win_pos)
    end,
    cursor_pointer_condition = isCursorPointer_up_down,
    sort_func = function(a, b)
      return a.end_row > b.end_row
    end
  }
}

--- @param win_id number
--- @return WinPos
local function get_win_pos(win_id)
  local pos = vim.api.nvim_win_get_position(win_id)
  local start_row = pos[1]
  local start_col = pos[2]
  local end_row = vim.api.nvim_win_get_height(win_id) + start_row
  local end_col = vim.api.nvim_win_get_width(win_id) + start_col

  return {
    start_row = start_row,
    end_row = end_row,
    start_col = start_col,
    end_col = end_col,
    win = win_id
  }
end

--- @param win_id_list table<number>
--- @param current_win_pos WinPos
--- @param match_condition MatchCondition
--- @return table<number, WinPos>
local function get_match_win_pos_list(win_id_list, current_win_pos, match_condition)
  --- @type table<number, WinPos>
  local match_win_pos_list = {}
  for _, win_id in ipairs(win_id_list) do
    if current_win_pos.win == win_id then
      goto continue
    end
    local win_pos = get_win_pos(win_id)
    if match_condition(win_pos, current_win_pos) then
      table.insert(match_win_pos_list, win_pos)
    end
    ::continue::
  end

  return match_win_pos_list
end

--- @param win_pos_list table<number, WinPos>
--- @param current_win_pos WinPos
--- @param actionLogic ActionLogic
--- @return WinPos
local function get_final_win_pos(win_pos_list, current_win_pos, actionLogic)
  --- @type table<number, WinPos>
  local match_win_pos_list = {}
  for _, win_pos in ipairs(win_pos_list) do
    if actionLogic.cursor_pointer_condition(win_pos, current_win_pos) then
      table.insert(match_win_pos_list, win_pos)
    end
  end
  table.sort(match_win_pos_list, actionLogic.sort_func)
  return match_win_pos_list[math.min(vim.v.count1, #match_win_pos_list)]
end


local function isExcludeFileType(win_id)
  local result = false
  local exclude = { "neo-tree" }
  local filetype = vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(win_id), "filetype")

  for _, value in ipairs(exclude) do
    if filetype == value then
      result = true
    end
  end

  return result
end

--- @param action "up"|"down"|"left"|"right"
function M.win_exchange(action)
  local current_win_id = vim.api.nvim_get_current_win()
  local current_win_pos = get_win_pos(current_win_id)

  if isExcludeFileType(current_win_id) then
    return
  end

  local match_win_pos_list = get_match_win_pos_list(
    vim.api.nvim_list_wins(),
    current_win_pos,
    Action[action].match_condition
  )

  if #match_win_pos_list == 0 then
    return
  end

  local final_win_pos = get_final_win_pos(
    match_win_pos_list,
    current_win_pos,
    Action[action]
  )

  if final_win_pos and not isExcludeFileType(final_win_pos.win) then
    require("windows-layout.exchange").exchange(current_win_id, final_win_pos.win)
    require("windows-layout.history").push_into_history(current_win_id, final_win_pos.win)
  end
end

--- @param current_win_id number
--- @param another_win_id number
local function change_layout(current_win_id, another_win_id)
  local another_win_config = vim.api.nvim_win_get_config(another_win_id)
  local another_buf = vim.api.nvim_win_get_buf(another_win_id)
  vim.api.nvim_win_close(another_win_id, false)

  if another_win_config.split == "left" or another_win_config.split == "right" then
    another_win_config.split = "above"
    another_win_config.height = math.floor(another_win_config.height / 2)
  else
    another_win_config.split = "right"
    another_win_config.width = math.floor(another_win_config.width / 2)
  end
  vim.api.nvim_open_win(another_buf, false, another_win_config)
end

--- @param action "up"|"down"|"left"|"right"
--- @param wins number[]
--- @param current_win_pos WinPos
--- @param current_win_id number
--- @return boolean
local function _a(action, wins, current_win_pos, current_win_id)
  local match_win_pos_list = get_match_win_pos_list(
    wins,
    current_win_pos,
    Action[action].match_condition
  )

  local final_win_pos = get_final_win_pos(
    match_win_pos_list,
    current_win_pos,
    Action[action]
  )

  if not final_win_pos then
    return false
  end

  if action == "left" or action == "right" then
    if final_win_pos.start_row == current_win_pos.start_row and final_win_pos.end_row == current_win_pos.end_row then
      change_layout(current_win_id, final_win_pos.win)
      -- require("windows-layout.exchange").exchange(current_win_id, final_win_pos.win)
      return true
    end
  elseif action == "down" or action == "up" then
    if final_win_pos.start_col == current_win_pos.start_col and final_win_pos.end_col == current_win_pos.end_col then
      change_layout(current_win_id, final_win_pos.win)
      -- require("windows-layout.exchange").exchange(current_win_id, final_win_pos.win)
      return true
    end
  end
  return false
end

function M.exchange_layout()
  local wins = vim.api.nvim_list_wins()
  local current_win_id = vim.api.nvim_get_current_win()
  local current_win_pos = get_win_pos(current_win_id)

  local f = false
  if not f then
    f = _a("up", wins, current_win_pos, current_win_id)
  end
  if not f then
    f = _a("down", wins, current_win_pos, current_win_id)
  end
  if not f then
    f = _a("left", wins, current_win_pos, current_win_id)
  end
  if not f then
    f = _a("right", wins, current_win_pos, current_win_id)
  end
end

return M
