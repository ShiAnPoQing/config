local M = {}

local pointer = 0;
local undo_pointer = 0;

--- @alias HistoryWins table<number>
--- @alias HistoryList table<number, HistoryWins>

--- @type HistoryList
local history_list = {}

local function clean_backtrace()
  if pointer and undo_pointer then
    local new_history_list = {}
    for i, value in ipairs(history_list) do
      if i <= pointer or i > undo_pointer then
        new_history_list[i] = history_list[i]
      end
    end
    history_list = new_history_list
  end
end

local function update_pointer()
  pointer = #history_list
  undo_pointer = 0
end

--- @param current_win_id number
--- @param win_id number
function M.push_into_history(current_win_id, win_id)
  clean_backtrace()
  table.insert(history_list, { current_win_id, win_id })
  update_pointer()
end

function M.exchange_pre()
  if pointer == 0 then
    return
  end

  if undo_pointer == 0 then
    undo_pointer = pointer;
  end

  local history_wins = history_list[pointer]
  require("windows-layout.exchange").exchange(history_wins[2], history_wins[1])

  pointer = math.max(0, pointer - 1)
end

function M.exchange_next()
  if #history_list == 0 or pointer + 1 > #history_list then
    return
  end

  local history_wins = history_list[pointer + 1]
  require("windows-layout.exchange").exchange(history_wins[1], history_wins[2])

  pointer = pointer + 1
end

return M
