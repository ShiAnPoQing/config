local function set_textobject_range(buf, start_line, start_col, end_line, end_col)
  vim.api.nvim_buf_set_mark(buf, "[", start_line, start_col, {})
  vim.api.nvim_buf_set_mark(buf, "]", end_line, end_col, {})
end

--- (1, 0) 索引
local function get_visual_range()
  local v_start_line, v_start_col = unpack(vim.api.nvim_win_get_cursor(0))
  local _, v_end_line, v_end_col = unpack(vim.fn.getpos("v"))
  v_end_col = v_end_col - 1
  return v_start_line, v_start_col, v_end_line, v_end_col
end

local function is_same_pos(start_line, start_col, end_line, end_col)
  return start_line == end_line and start_col == end_col
end

local function is_forward_visual(start_line, start_col, end_line, end_col)
  return start_line < end_line or (start_line == end_line and start_col <= end_col)
end

local function line_outer_movement(count)
  vim.validate("count", count, "number")
  local line_text = vim.api.nvim_get_current_line()
  local v_start_line, v_start_col, v_end_line, v_end_col = get_visual_range()
  local is_same = is_same_pos(v_start_line, v_start_col, v_end_line, v_end_col)
  if #line_text == 0 and is_same then
    return
  end
  local offset = count - 1

  local start_line, start_col, end_line, end_col
  local expand_select_key = ""
  if #line_text ~= 1 and is_same then
    start_line, start_col, end_line = v_start_line, 0, v_start_line + offset
    end_line = math.min(end_line, vim.api.nvim_buf_line_count(0))
    end_col = #vim.api.nvim_buf_get_lines(0, end_line - 1, end_line, false)[1] - 1
    expand_select_key = "`[o`]"
  else
    if is_forward_visual(v_start_line, v_start_col, v_end_line, v_end_col) then
      start_line, start_col, end_line, end_col = v_start_line - offset, 0, v_end_line, v_end_col
      if v_start_col == 0 then
        start_line = start_line - 1
      end
      start_line = math.max(start_line, 1)
      expand_select_key = "`]o`["
    else
      start_line, start_col, end_line = v_end_line, v_end_col, v_start_line + offset
      if #line_text == 0 or (v_start_col == #line_text - 1) then
        end_line = end_line + 1
      end
      end_line = math.min(end_line, vim.api.nvim_buf_line_count(0))
      end_col = #vim.api.nvim_buf_get_lines(0, end_line - 1, end_line, false)[1] - 1
      expand_select_key = "`[o`]"
    end
  end
  set_textobject_range(0, start_line, start_col, end_line, end_col)
  return expand_select_key
end

return {
  ["sI"] = {
    function()
      if vim.v.operator == "d" or my.operator.is_delete_operator() then
        return "<esc><Cmd>lua my.trim_cWORD_lead()<cr>"
      end
      return "<esc>"
    end,
    "o",
    expr = true,
  },
  ["sO"] = {
    function()
      if vim.v.operator == "d" or my.operator.is_delete_operator() then
        return "<esc><Cmd>lua my.trim_cWORD_trail()<cr>"
      end
      return "<esc>"
    end,
    "o",
    expr = true,
  },
  ["si"] = {
    function()
      if vim.v.operator == "d" or my.operator.is_delete_operator() then
        return "<esc><Cmd>lua my.trim_cword_lead()<cr>"
      end
      return "<esc>"
    end,
    "o",
    expr = true,
  },
  ["so"] = {
    function()
      if vim.v.operator == "d" or my.operator.is_delete_operator() then
        return "<esc><Cmd>lua my.trim_cword_trail()<cr>"
      end
      return "<esc>"
    end,
    "o",
    expr = true,
  },
  ["sw"] = {
    function()
      if vim.v.operator == "d" or my.operator.is_delete_operator() then
        return "<esc><Cmd>lua my.trim_cword()<cr>"
      end
      return "<esc>"
    end,
    "o",
    expr = true,
  },
  ["sW"] = {
    function()
      if vim.v.operator == "d" or my.operator.is_delete_operator() then
        return "<esc><Cmd>lua my.trim_cWORD()<cr>"
      end
      return "<esc>"
    end,
    "o",
    expr = true,
  },
  ["es"] = {
    "as",
    "o",
  },
  ["ws"] = {
    "is",
    "o",
  },
  ["ep"] = {
    "ap",
    "o",
  },
  ["wp"] = {
    "ip",
    "o",
  },
  ["<Plug>(textobject-line-inner)"] = {
    function()
      vim.api.nvim_feedkeys("^vg_", "nx", false)
    end,
    "o",
  },
  ["wl"] = {
    "<Plug>(textobject-line-inner)",
    "o",
    desc = "[textobject]: inner line",
  },
  ["el"] = {
    {
      function()
        return line_outer_movement(vim.v.count1)
      end,
      "x",
      expr = true,
    },
    {
      function()
        local count = vim.v.count1
        vim.api.nvim_feedkeys("v", "nx", false)
        vim.api.nvim_feedkeys(line_outer_movement(count) or "", "nx", false)
      end,
      "o",
    },
    desc = "[textobject]: outer line",
  },
  ['"'] = {
    function()
      if vim.v.operator == "d" and my.operator.is_delete_operator() then
        ---@diagnostic disable-next-line: param-type-mismatch
        local char = vim.fn.nr2char(vim.fn.getchar())
        local other_regs = '"#*+_/'
        if char:match("%w") or other_regs:find(char) then
          vim.fn.setreg(char, "")
          vim.schedule(function()
            vim.notify("Cleared register: " .. char)
          end)
        end
      end
    end,
    "o",
    desc = "[Object] register",
  },

  --- Edit
  ["<BS>"] = { "<esc>", "o" },
}
