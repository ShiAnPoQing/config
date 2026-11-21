--- @class my.win.cursor.motion
--- @field INSERT my.win.cursor.motion.INSERT
--- @field ["i"] my.win.cursor.motion.INSERT
local M = my.module.defer_require("my.win.cursor.motion", {
  ["INSERT"] = {
    scope = true,
  },
  ["i"] = "INSERT",
})

local function get_mode_api(name)
  local mode = vim.api.nvim_get_mode().mode
  local submodule = M[mode]
  if submodule then
    return submodule[name]
  end
end

--- @param win integer
function M.line_last_character(win)
  vim.validate("win", win, "number")
  local api = get_mode_api("line_last_character")
  if not api then
    return
  end
  api(win)
end

--- @param win integer
function M.line_last_non_blank_character(win)
  vim.validate("win", win, "number")
  local api = get_mode_api("line_last_non_blank_character")
  if not api then
    return
  end
  api(win)
end

--- @param win integer
function M.line_first_character(win)
  vim.validate("win", win, "number")
  local api = get_mode_api("line_first_character")
  if not api then
    return
  end
  api(win)
end

--- @param win integer
function M.line_first_non_blank_character(win)
  vim.validate("win", win, "number")
  local api = get_mode_api("line_first_non_blank_character")
  if not api then
    return
  end
  api(win)
end

--- @param win integer
--- @param count integer
function M.forward_word_start(win, count)
  vim.validate("win", win, "number")
  vim.validate("count", count, "number")
  local api = get_mode_api("forward_word_start")
  if not api then
    return
  end
  api(win)
end

--- @param win integer
--- @param count integer
function M.forward_WORD_start(win, count)
  vim.validate("win", win, "number")
  vim.validate("count", count, "number")
  local api = get_mode_api("forward_WORD_start")
  if not api then
    return
  end
  api(win)
end

--- @param win integer
--- @param count integer
function M.forward_word_end(win, count)
  vim.validate("win", win, "number")
  vim.validate("count", count, "number")
  local api = get_mode_api("forward_word_end")
  if not api then
    return
  end
  api(win)
end

--- @param win integer
--- @param count integer
function M.forward_WORD_end(win, count)
  vim.validate("win", win, "number")
  vim.validate("count", count, "number")
  local api = get_mode_api("forward_WORD_end")
  if not api then
    return
  end
  api(win)
end

--- @param win integer
--- @param count integer
function M.backward_word_start(win, count)
  vim.validate("win", win, "number")
  vim.validate("count", count, "number")
  local api = get_mode_api("backward_word_start")
  if not api then
    return
  end
  api(win)
end

--- @param win integer
--- @param count integer
function M.backward_WORD_start(win, count)
  vim.validate("win", win, "number")
  vim.validate("count", count, "number")
  local api = get_mode_api("backward_WORD_start")
  if not api then
    return
  end
  api(win)
end

--- @param win integer
--- @param count integer
function M.backward_word_end(win, count)
  vim.validate("win", win, "number")
  vim.validate("count", count, "number")
  local api = get_mode_api("backward_word_end")
  if not api then
    return
  end
  api(win)
end

--- @param win integer
--- @param count integer
function M.backward_WORD_end(win, count)
  vim.validate("win", win, "number")
  vim.validate("count", count, "number")
  local api = get_mode_api("backward_WORD_end")
  if not api then
    return
  end
  api(win)
end

return M
