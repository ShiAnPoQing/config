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
		end,
	},
	["left"] = {
		match_condition = function(win_pos, current_win_pos)
			return win_pos.start_col <= current_win_pos.start_col and isInnerRow(win_pos, current_win_pos)
		end,
		cursor_pointer_condition = isCursorPointer_left_right,
		sort_func = function(a, b)
			return a.end_col > b.end_col
		end,
	},
	["down"] = {
		match_condition = function(win_pos, current_win_pos)
			return win_pos.start_row >= current_win_pos.start_row and isInnerCol(win_pos, current_win_pos)
		end,
		cursor_pointer_condition = isCursorPointer_up_down,
		sort_func = function(a, b)
			return a.end_row < b.end_row
		end,
	},
	["up"] = {
		match_condition = function(win_pos, current_win_pos)
			return win_pos.start_row <= current_win_pos.start_row and isInnerCol(win_pos, current_win_pos)
		end,
		cursor_pointer_condition = isCursorPointer_up_down,
		sort_func = function(a, b)
			return a.end_row > b.end_row
		end,
	},
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
		win = win_id,
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
	local filetype = vim.api.nvim_get_option_value("filetype", { buf = vim.api.nvim_win_get_buf(win_id) })

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
	local cursor_pos = vim.api.nvim_win_get_cursor(current_win_id)
	local current_win_pos = get_win_pos(current_win_id)

	if isExcludeFileType(current_win_id) then
		return
	end

	local match_win_pos_list =
		get_match_win_pos_list(vim.api.nvim_list_wins(), current_win_pos, Action[action].match_condition)

	if #match_win_pos_list == 0 then
		return
	end

	local final_win_pos = get_final_win_pos(match_win_pos_list, current_win_pos, Action[action])

	if final_win_pos and not isExcludeFileType(final_win_pos.win) then
		M.exchange(current_win_id, final_win_pos.win)
		vim.api.nvim_win_set_cursor(final_win_pos.win, cursor_pos)
	end
end

return M
