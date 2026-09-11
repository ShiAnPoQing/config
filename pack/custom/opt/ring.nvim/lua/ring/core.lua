local M = {}

local pair_map = {
  ["("] = { "(", ")" },
  [")"] = { "(", ")" },
  ["["] = { "[", "]" },
  ["]"] = { "[", "]" },
  ["{"] = { "{", "}" },
  ["}"] = { "{", "}" },
  ["'"] = { "'", "'" },
  ['"'] = { '"', '"' },
  ["`"] = { "`", "`" },
}

--- @param count integer
--- @param textobject string|fun(ctx: any):[ [integer, integer], [integer, integer]]
--- @return integer|nil, integer|nil, integer|nil, integer|nil
local function get_range(buf, count, textobject)
  if type(textobject) == "string" then
    vim.api.nvim_feedkeys(
      "v" .. count .. vim.api.nvim_replace_termcodes(textobject, true, false, true) .. "v",
      "mx",
      true
    )
    local start_line, start_col = unpack(vim.api.nvim_buf_get_mark(buf, "<"))
    local end_line, end_col = unpack(vim.api.nvim_buf_get_mark(buf, ">"))
    return start_line, start_col, end_line, end_col
  elseif type(textobject) == "function" then
    local range = textobject({ buf = buf, count = count })
    return range[1][1], range[1][2], range[2][1], range[2][2]
  end
  return nil
end

--- @param textobject string|fun():Ring.Range
--- @return { range: nil|Ring.Range, count: integer, cursor: [integer, integer], win:integer, buf:integer }
local function get_context(textobject)
  local count = vim.v.count1
  local win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_get_current_buf()
  local cursor = vim.api.nvim_win_get_cursor(win)
  local start_line, start_col, end_line, end_col = get_range(buf, count, textobject)
  return {
    count = count,
    cursor = cursor,
    win = win,
    buf = buf,
    range = start_line and { { start_line, start_col }, { end_line, end_col } },
  }
end

--- @param textobject string|fun():[ [integer, integer], [integer, integer]]
--- @param pair Ring.Pair
local function delete(textobject, pair)
  pair = pair or { "", "" }
  local ctx = get_context(textobject)
  if not ctx.range then
    return
  end
  local start_line, start_col, end_line, end_col = ctx.range[1][1], ctx.range[1][2], ctx.range[2][1], ctx.range[2][2]
  if start_line == end_line and start_col == end_col then
    return
  end
  local texts = vim.api.nvim_buf_get_text(ctx.buf, start_line - 1, start_col, end_line - 1, end_col + 1, {})
  texts[1] = texts[1]:gsub("^" .. pair[1], "")
  texts[#texts] = texts[#texts]:gsub(pair[2] .. "$", "")
  vim.schedule(function()
    vim.api.nvim_buf_set_text(ctx.buf, start_line - 1, start_col, end_line - 1, end_col + 1, texts)
    if
      (ctx.cursor[1] == start_line and ctx.cursor[2] > start_col)
      or (ctx.cursor[1] == end_line and ctx.cursor[2] > end_col)
    then
      vim.api.nvim_win_set_cursor(0, { ctx.cursor[1], ctx.cursor[2] - #pair[1] })
    end
    require("repeat").set_operation(function()
      delete(textobject, pair)
    end, ctx.count)
  end)
end

local function change(textobject, pair)
  local ctx = get_context(textobject)
  local start_line, start_col, end_line, end_col = ctx.range[1][1], ctx.range[1][2], ctx.range[2][1], ctx.range[2][2]
  if start_line == end_line and start_col == end_col then
    return
  end

  local on_confirm = function(input)
    if not input then
      return
    end
    local new_pair = { input, input }
    if pair_map[input] then
      new_pair[1] = pair_map[input][1]
      new_pair[2] = pair_map[input][2]
    end
    local texts = vim.api.nvim_buf_get_text(ctx.buf, start_line - 1, start_col, end_line - 1, end_col + 1, {})
    texts[1] = texts[1]:gsub("^" .. pair[1], new_pair[1])
    texts[#texts] = texts[#texts]:gsub(pair[2] .. "$", new_pair[2])
    vim.api.nvim_buf_set_text(ctx.buf, start_line - 1, start_col, end_line - 1, end_col + 1, texts)
    if
      (ctx.cursor[1] == start_line and ctx.cursor[2] > start_col)
      or (ctx.cursor[1] == end_line and ctx.cursor[2] > end_col)
    then
      local offset = #new_pair[1] - #pair[1]
      pcall(vim.api.nvim_win_set_cursor, 0, { ctx.cursor[1], ctx.cursor[2] + offset })
      require("repeat").set_operation(function()
        change(textobject, pair)
      end, ctx.count)
    end
  end

  vim.schedule(function()
    vim.ui.input({
      prompt = "Change " .. pair[1] .. pair[2] .. " to:",
    }, on_confirm)
  end)
end

local function add()
  _G.ring_add = function(type)
    vim.ui.input({
      prompt = "Add surround:",
    }, function(input)
      if not input then
        return
      end
      local pair = { input, input }
      if pair_map[input] then
        pair[1] = pair_map[input][1]
        pair[2] = pair_map[input][2]
      end
      local start_line, start_col = unpack(vim.api.nvim_buf_get_mark(0, "["))
      local end_line, end_col = unpack(vim.api.nvim_buf_get_mark(0, "]"))
      if type == "line" then
        local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
        lines[1] = pair[1] .. lines[1]
        lines[#lines] = lines[#lines] .. pair[2]
        vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, lines)
      elseif type == "char" or type == "block" then
        local texts = vim.api.nvim_buf_get_text(0, start_line - 1, start_col, end_line - 1, end_col + 1, {})
        texts[1] = pair[1] .. texts[1]
        texts[#texts] = texts[#texts] .. pair[2]
        vim.api.nvim_buf_set_text(0, start_line - 1, start_col, end_line - 1, end_col + 1, texts)
      end
      require("repeat").set_operation(function()
        add()
        vim.api.nvim_feedkeys("g@", "n", true)
      end)
    end)
  end
  vim.o.operatorfunc = "v:lua.ring_add"
end

vim.keymap.set("n", "sa", function()
  add()
  return "g@"
end, {
  expr = true,
})

--- @param registers table<string, Ring.Register>
function M.register(registers)
  for lhs, register in pairs(registers) do
    local textobject = register[1]
    local pair = register[2]
    vim.keymap.set("o", lhs, function()
      local operator = vim.v.operator
      if operator == "d" then
        delete(textobject, pair)
      elseif operator == "c" then
        change(textobject, pair)
      end
      return "<esc>"
    end, {
      expr = true,
    })
  end
end

return M
