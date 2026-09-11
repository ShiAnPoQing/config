---------------------------------------------------------------------------------------------------+
-- Commands \ Modes | Normal | Insert | Command | Visual | Select | Operator | Terminal | Lang-Arg |
-- ================================================================================================+
-- map  / noremap   |    @   |   -    |    -    |   @    |   @    |    @     |    -     |    -     |
-- nmap / nnoremap  |    @   |   -    |    -    |   -    |   -    |    -     |    -     |    -     |
-- map! / noremap!  |    -   |   @    |    @    |   -    |   -    |    -     |    -     |    -     |
-- imap / inoremap  |    -   |   @    |    -    |   -    |   -    |    -     |    -     |    -     |
-- cmap / cnoremap  |    -   |   -    |    @    |   -    |   -    |    -     |    -     |    -     |
-- vmap / vnoremap  |    -   |   -    |    -    |   @    |   @    |    -     |    -     |    -     |
-- xmap / xnoremap  |    -   |   -    |    -    |   @    |   -    |    -     |    -     |    -     |
-- smap / snoremap  |    -   |   -    |    -    |   -    |   @    |    -     |    -     |    -     |
-- omap / onoremap  |    -   |   -    |    -    |   -    |   -    |    @     |    -     |    -     |
-- tmap / tnoremap  |    -   |   -    |    -    |   -    |   -    |    -     |    @     |    -     |
-- lmap / lnoremap  |    -   |   @    |    @    |   -    |   -    |    -     |    -     |    @     |
---------------------------------------------------------------------------------------------------+

--- 兼容 visual block 模式
local function visual_mode_textobject(textobject)
  local mode = vim.api.nvim_get_mode().mode
  if mode == "" then
    local cursor = vim.api.nvim_win_get_cursor(0)
    vim.api.nvim_feedkeys(textobject .. vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "nx", false)
    local start_row = unpack(vim.api.nvim_buf_get_mark(0, "<"))
    local end_row = unpack(vim.api.nvim_buf_get_mark(0, ">"))

    vim.api.nvim_win_set_cursor(0, { start_row, cursor[2] })
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-v>", true, false, true), "nx", false)
    vim.api.nvim_win_set_cursor(0, { end_row, cursor[2] })
  else
    vim.api.nvim_feedkeys(textobject, "nx", false)
  end
end

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
  ["wi"] = { "aw", { "x", "o" }, desc = "[textobject]: outer word" },
  ["ei"] = { "iw", { "x", "o" }, desc = "[textobject]: inner word" },
  ["wI"] = { "aW", { "x", "o" }, desc = "[textobject]: outer WORD" },
  ["eI"] = { "iW", { "x", "o" }, desc = "[textobject]: inner WORD" },
  ["wo"] = { "aw", { "x", "o" }, desc = "[textobject]: outer word" },
  ["eo"] = { "iw", { "x", "o" }, desc = "[textobject]: inner word" },
  ["wO"] = { "aW", { "x", "o" }, desc = "[textobject]: outer WORD" },
  ["eO"] = { "iW", { "x", "o" }, desc = "[textobject]: inner WORD" },
  ["ws"] = {
    { "as", "o" },
    {
      function()
        visual_mode_textobject("as")
      end,
      "x",
    },
    desc = "[textobject]: outer sentence",
  },
  ["es"] = {
    { "is", "o" },
    {
      function()
        visual_mode_textobject("is")
      end,
      "x",
    },
    desc = "[textobject]: inner sentence",
  },
  ["wp"] = {
    {
      "ap",
      "o",
    },
    {
      function()
        visual_mode_textobject("ap")
      end,
      "x",
    },
    desc = "[textobject]: outer paragraph",
  },
  -- ["yep"] = {
  --   function()
  --
  --     local old_cursor = vim.api.nvim_win_get_cursor(0)
  --     vim.api.nvim_feedkeys("yip", "nx", false)
  --     vim.api.nvim_win_set_cursor(0, old_cursor)
  --
  --   end,
  --   "n"
  -- },
  ["ep"] = {
    {
      "ip",
      "o",
    },
    {
      function()
        visual_mode_textobject("ip")
      end,
      "x",
    },
    desc = "[textobject]: inner paragraph",
  },
  ["w["] = { "a[", { "x", "o" }, desc = "[textobject]: outer []" },
  ["e["] = { "i[", { "x", "o" }, desc = "[textobject]: inner []" },
  ["w]"] = { "a]", { "x", "o" }, desc = "[textobject]: outer []" },
  ["e]"] = { "i]", { "x", "o" }, desc = "[textobject]: inner []" },
  ["w{"] = { "a}", { "x", "o" }, desc = "[textobject]: outer {}" },
  -- ["W{"] = {
  --   function()
  --     if vim.v.operator == "d" then
  --       vim.schedule(function()
  --         vim.fn.searchpos("}", "bcW")
  --         vim.api.nvim_feedkeys("va}", "n", false)
  --       end)
  --       return "<esc>"
  --     end
  --   end,
  --   "o",
  --   expr = true,
  -- },
  ["e{"] = { "i}", { "x", "o" }, desc = "[textobject]: inner {}" },
  ["w}"] = { "a}", { "x", "o" }, desc = "[textobject]: outer {}" },
  ["e}"] = { "i}", { "x", "o" }, desc = "[textobject]: inner {}" },
  ["w("] = { "a)", { "x", "o" }, desc = "[textobject]: outer ()" },
  ["e("] = { "i)", { "x", "o" }, desc = "[textobject]: inner ()" },
  ["w)"] = { "a)", { "x", "o" }, desc = "[textobject]: outer ()" },
  ["e)"] = { "i)", { "x", "o" }, desc = "[textobject]: inner ()" },
  ["w>"] = { "a>", { "x", "o" }, desc = "[textobject]: outer <>" },
  ["e>"] = { "i>", { "x", "o" }, desc = "[textobject]: inner <>" },
  ["w<"] = { "a>", { "x", "o" }, desc = "[textobject]: outer <>" },
  ["e<"] = { "i>", { "x", "o" }, desc = "[textobject]: inner <>" },
  ['w"'] = { 'a"', { "x", "o" }, desc = '[textobject]: outer ""' },
  ['e"'] = { 'i"', { "x", "o" }, desc = '[textobject]: inner ""' },
  ["w'"] = { "a'", { "x", "o" }, desc = "[textobject]: outer ''" },
  ["e'"] = { "i'", { "x", "o" }, desc = "[textobject]: inner ''" },
  ["w`"] = { "a`", { "x", "o" }, desc = "[textobject]: outer ``" },
  ["e`"] = { "i`", { "x", "o" }, desc = "[textobject]: inner ``" },
  ["el"] = {
    { "^og_", "x" },
    {
      function()
        vim.api.nvim_feedkeys("^vg_", "nx", false)
      end,
      "o",
    },
    desc = "[textobject]: inner line",
  },
  ["wl"] = {
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
  ["wt"] = { "at", { "x", "o" }, desc = "[textobject]: outer tag block" },
  ["et"] = { "it", { "x", "o" }, desc = "[textobject]: inner tag block" },
  ["wa"] = {
    { "vggVG", "x" },
    {
      function()
        vim.api.nvim_feedkeys("ggVG", "nx", false)
      end,
      "o",
    },
    desc = "[textobject]: all buffer",
  },
  ["ea"] = {
    { "vgovG$", "x" },
    {
      function()
        vim.api.nvim_feedkeys("goVG", "nx", false)
      end,
      "o",
    },
    desc = "[textobject]: all buffer",
  },
  --- /usr/share/nvim/runtime/lua/vim/_core/defaults.lua
  --- an
  ["wn"] = {
    function()
      if vim.treesitter.get_parser(nil, nil, { error = false }) then
        require("vim.treesitter._select").select_parent(vim.v.count1)
      else
        vim.lsp.buf.selection_range(vim.v.count1)
      end
    end,
    { "x", "o" },
    desc = "[textobject]: outer treesitter node",
  },
  ["en"] = {
    function()
      if vim.treesitter.get_parser(nil, nil, { error = false }) then
        require("vim.treesitter._select").select_child(vim.v.count1)
      else
        vim.lsp.buf.selection_range(-vim.v.count1)
      end
    end,
    { "x", "o" },
    desc = "[textobject]: inner treesitter node",
  },
}
