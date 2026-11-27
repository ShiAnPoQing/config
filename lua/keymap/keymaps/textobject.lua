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

-- {motion}
--    1.string/expr: "h", "j", "k", "l", "<cmd>normal! v{textobject}<cr>"
--    2.feedkeys("viw", "nx", false)

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

return {
  ["ei"] = { "aw", { "x", "o" }, desc = "[textobject]: outer word" },
  ["wi"] = { "iw", { "x", "o" }, desc = "[textobject]: inner word" },
  ["eI"] = { "aW", { "x", "o" }, desc = "[textobject]: outer WORD" },
  ["wI"] = { "iW", { "x", "o" }, desc = "[textobject]: inner WORD" },
  ["eo"] = { "aw", { "x", "o" }, desc = "[textobject]: outer word" },
  ["wo"] = { "iw", { "x", "o" }, desc = "[textobject]: inner word" },
  ["eO"] = { "aW", { "x", "o" }, desc = "[textobject]: outer WORD" },
  ["wO"] = { "iW", { "x", "o" }, desc = "[textobject]: inner WORD" },
  ["es"] = {
    {
      function()
        visual_mode_textobject("as")
      end,
      "x",
    },
    desc = "[textobject]: outer sentence",
  },
  ["ws"] = {
    {
      function()
        visual_mode_textobject("is")
      end,
      "x",
    },
    desc = "[textobject]: inner sentence",
  },
  ["ep"] = {
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
  ["wp"] = {
    {
      function()
        visual_mode_textobject("ip")
      end,
      "x",
    },
    desc = "[textobject]: inner paragraph",
  },
  ["e["] = { "a[", { "x", "o" }, desc = "[textobject]: outer []" },
  ["w["] = { "i[", { "x", "o" }, desc = "[textobject]: inner []" },
  ["e]"] = { "a]", { "x", "o" }, desc = "[textobject]: outer []" },
  ["w]"] = { "i]", { "x", "o" }, desc = "[textobject]: inner []" },
  ["e{"] = { "a}", { "x", "o" }, desc = "[textobject]: outer {}" },
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
  ["w{"] = { "i}", { "x", "o" }, desc = "[textobject]: inner {}" },
  ["e}"] = { "a}", { "x", "o" }, desc = "[textobject]: outer {}" },
  ["w}"] = { "i}", { "x", "o" }, desc = "[textobject]: inner {}" },
  ["e("] = { "a)", { "x", "o" }, desc = "[textobject]: outer ()" },
  ["w("] = { "i)", { "x", "o" }, desc = "[textobject]: inner ()" },
  ["e)"] = { "a)", { "x", "o" }, desc = "[textobject]: outer ()" },
  ["w)"] = { "i)", { "x", "o" }, desc = "[textobject]: inner ()" },
  ["e>"] = { "a>", { "x", "o" }, desc = "[textobject]: outer <>" },
  ["w>"] = { "i>", { "x", "o" }, desc = "[textobject]: inner <>" },
  ["e<"] = { "a>", { "x", "o" }, desc = "[textobject]: outer <>" },
  ["w<"] = { "i>", { "x", "o" }, desc = "[textobject]: inner <>" },
  ['e"'] = { 'a"', { "x", "o" }, desc = '[textobject]: outer ""' },
  ['w"'] = { 'i"', { "x", "o" }, desc = '[textobject]: inner ""' },
  ["e'"] = { "a'", { "x", "o" }, desc = "[textobject]: outer ''" },
  ["w'"] = { "i'", { "x", "o" }, desc = "[textobject]: inner ''" },
  ["e`"] = { "a`", { "x", "o" }, desc = "[textobject]: outer ``" },
  ["w`"] = { "i`", { "x", "o" }, desc = "[textobject]: inner ``" },
  ["wl"] = {
    { "^og_", "x" },
    desc = "[textobject]: inner line",
  },
  ["et"] = { "at", { "x", "o" }, desc = "[textobject]: outer tag block" },
  ["wt"] = { "it", { "x", "o" }, desc = "[textobject]: inner tag block" },
  ["ea"] = {
    { "vggVG", "x" },
    {
      function()
        vim.api.nvim_feedkeys("ggVG", "nx", false)
      end,
      "o",
    },
    desc = "[textobject]: all buffer",
  },
  ["wa"] = {
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
  ["en"] = {
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
  ["wn"] = {
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
  ["sh"] = {
    "<cmd>lua my.motion.OPERATOR.line_lead_whitespace()<CR>",
    "o",
    desc = "[textobject]: line leading whitespace",
  },
  ["ss"] = {
    function()
      if vim.v.operator == "d" or my.operator.is_delete_operator() then
        return "<esc><Cmd>lua my.trim_current_line()<cr>"
      end
      return "<esc>"
    end,
    "o",
    expr = true,
    desc = "[textobject]: line leading and trailing whitespace",
  },
  ["sl"] = {
    "<cmd>lua my.motion.OPERATOR.line_trail_whitespace()<CR>",
    "o",
    desc = "[textobject]: line trailing whitespace",
  },
  ["sk"] = {
    "<cmd>lua my.motion.OPERATOR.paragraph_lead_whitespace()<CR>",
    "o",
    desc = "[textobject]: paragraph leading whitespace",
  },
  ["sj"] = {
    "<cmd>lua my.motion.OPERATOR.paragraph_trail_whitespace()<CR>",
    "o",
    desc = "[textobject]: paragraph trailing whitespace",
  },
}
