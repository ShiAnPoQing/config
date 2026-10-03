-- :g/{pattern}/normal! zqn

--- @class my.multicursor
--- @field mouse my.multicursor.mouse
--- @field register my.multicursor.register
--- @field ns integer
--- @field cursor my.multicursor.cursor
--- @field visual my.multicursor.visual
local M = {
  _submodules = {
    mouse = true,
    register = true,
    cursor = true,
    visual = true,
  },
}

setmetatable(M, {
  --- @param t table<any,any>
  __index = function(t, key)
    if M._submodules[key] then
      t[key] = require("my.multicursor." .. key)
      return t[key]
    elseif key == "ns" then
      return vim.api.nvim_create_namespace("nvim.multicursor")
    end
  end,
})

--- @return boolean
function M.active()
  return #vim.api.nvim_buf_get_extmarks(0, M.ns, 0, -1, { limit = 1 }) > 0
end

--- @param buf integer
--- @param line integer
--- @param col integer
--- @param opts vim.api.keyset.set_extmark?
--- @return integer
function M.set(buf, line, col, opts)
  return vim.api.nvim_buf_set_extmark(buf, M.ns, line, col, opts or {})
end

--- @param buf integer
--- @param line_start integer?
--- @param line_end integer?
function M.clear(buf, line_start, line_end)
  if not line_start then
    line_start = 0
  end
  if not line_end then
    line_end = -1
  end
  vim.api.nvim_buf_clear_namespace(buf, M.ns, line_start, line_end)
end

--- @param buf integer
--- @param id integer
--- @return boolean
function M.del(buf, id)
  return vim.api.nvim_buf_del_extmark(buf, M.ns, id)
end

--- @param buf integer
--- @return vim.api.keyset.get_extmark_item[]
function M._all(buf)
  local cursor = vim.api.nvim_win_get_cursor(0)
  local items = M.get(buf, 0, -1)
  table.insert(items, 1, { 0, cursor[1] - 1, cursor[2] })
  return items
end

--- @param buf integer
--- @param start any
--- @param end_ any
--- @param opts? vim.api.keyset.get_extmarks
--- @return vim.api.keyset.get_extmark_item[]
function M.get(buf, start, end_, opts)
  opts = opts or {}
  return vim.api.nvim_buf_get_extmarks(buf, M.ns, start, end_, opts)
end

--- @param buf integer
--- @param id integer
--- @param opts vim.api.keyset.get_extmark?
--- @return [integer, integer, vim.api.keyset.extmark_details?]
function M.get_by_id(buf, id, opts)
  return vim.api.nvim_buf_get_extmark_by_id(buf, M.ns, id, opts or {})
end

--- @param buf integer
--- @param callback fun(id: integer, extmark: [integer,integer]): vim.api.keyset.get_extmark_item?
--- @param start integer?
--- @param end_ integer?
function M.transform(buf, callback, start, end_)
  vim.validate("buf", buf, "number")
  vim.validate("callback", callback, "function")
  vim.validate("start", start, "number", true)
  vim.validate("end_", end_, "number", true)
  start = start or 0
  end_ = end_ or -1
  for _, extmark in ipairs(M.get(buf, start, end_)) do
    local id, line, col = unpack(extmark)
    local new_extmark = callback(id, { line, col })
    if not new_extmark then
      M.del(buf, id)
    else
      if type(new_extmark) == "table" then
        if new_extmark[1] ~= line or new_extmark[2] ~= col then
          M.del(buf, id)
          M.set(buf, new_extmark[1], new_extmark[2])
        end
      end
    end
  end
end

local snapshots = {}

--- @param buf integer
function M.snapshot(buf)
  if buf == 0 then
    buf = vim.api.nvim_get_current_buf()
  end
  snapshots[tostring(buf)] = M._all(buf)
end

--- @param buf integer
function M.get_snapshot(buf)
  if buf == 0 then
    buf = vim.api.nvim_get_current_buf()
  end
  return snapshots[tostring(buf)]
end

function M.search_add()
  local mode = vim.api.nvim_get_mode().mode
  local ctx = {}
  if mode == "V" then
    vim.cmd("normal! V")
    ctx.topline = vim.api.nvim_buf_get_mark(0, "<")[1]
    ctx.botline = vim.api.nvim_buf_get_mark(0, ">")[1]
    local visual_ns = vim.api.nvim_create_namespace("my.search")
    vim.api.nvim_buf_set_extmark(0, visual_ns, ctx.topline - 1, 0, {
      hl_group = "Visual",
      end_row = ctx.botline,
      end_col = 0,
    })
    ctx.cleanup = function()
      vim.api.nvim_buf_clear_namespace(0, visual_ns, 0, -1)
    end
    ctx.matched = function(matches)
      local cursor = vim.api.nvim_win_get_cursor(0)
      local final_cursor
      local first_extmark_id
      for i, m in ipairs(matches) do
        if not final_cursor and ((m.line == cursor[1] and m.col >= cursor[2]) or m.line > cursor[1]) then
          final_cursor = { m.line, m.col }
        else
          local id = vim.api.nvim_buf_set_extmark(0, my.multicursor.ns, m.line - 1, m.col, {})
          if i == 1 then
            first_extmark_id = id
          end
        end
      end

      if final_cursor then
        vim.api.nvim_win_set_cursor(0, final_cursor)
        return
      end

      if #matches == 0 then
        return
      end
      vim.api.nvim_win_set_cursor(0, { matches[1].line, matches[1].col })
      vim.api.nvim_buf_del_extmark(0, my.multicursor.ns, first_extmark_id)
    end
  elseif mode == "n" then
    ctx.topline = 1
    ctx.botline = vim.api.nvim_buf_line_count(0)
    ctx.matched = function(matches)
      vim.api.nvim_feedkeys("n", "nx", false)
      local cursor = vim.api.nvim_win_get_cursor(0)
      for _, m in ipairs(matches) do
        if not (m.line == cursor[1] and m.col == cursor[2]) then
          vim.api.nvim_buf_set_extmark(0, my.multicursor.ns, m.line - 1, m.col, {})
        end
      end
    end
  end
  local buf = vim.api.nvim_get_current_buf()
  local prev_matches = {}
  local function step(pattern)
    local char = vim.fn.getchar(-1, { number = false })
    char = type(char) == "string" and vim.fn.keytrans(char) or ""
    if char == "<Esc>" then
      my.util.try(ctx.cleanup)
      return
    end
    if char == "<CR>" then
      my.util.try(ctx.matched, prev_matches)
      my.util.try(ctx.cleanup)
      return
    end
    pattern = pattern .. char
    local regex = vim.regex(pattern)
    local matches = {}
    for i = ctx.topline, ctx.botline do
      local start_pos = 0
      while true do
        local start, end_ = regex:match_line(buf, i - 1, start_pos)
        if not start or not end_ or (start == 0 and end_ == 0) then
          break
        end
        table.insert(matches, { line = i, col = start + start_pos, end_col = end_ + start_pos })
        start_pos = start_pos + end_
      end
    end
    prev_matches = matches
    vim.o.hlsearch = true
    vim.fn.setreg("/", pattern)
    vim.cmd.redraw()
    vim.api.nvim_echo({ { "/" .. pattern, "Normal" } }, false)

    step(pattern)
  end
  step("")
end

return M
