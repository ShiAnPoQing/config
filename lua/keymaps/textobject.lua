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

return {
  ["ww"] = { "aw", { "x", "o" }, desc = "outer word" },
  ["ew"] = { "iw", { "x", "o" }, desc = "inner word" },
  ["wW"] = { "aW", { "x", "o" }, desc = "outer WORD" },
  ["eW"] = { "iW", { "x", "o" }, desc = "inner WORD" },
  ["ws"] = {
    { "as", "o" },
    {
      function()
        visual_mode_textobject("as")
      end,
      "x",
    },
    desc = "outer sentence",
  },
  ["es"] = {
    { "is", "o" },
    {
      function()
        visual_mode_textobject("is")
      end,
      "x",
    },
    desc = "inner sentence",
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
    desc = "outer paragraph",
  },
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
    desc = "inner paragraph",
  },
  ["w["] = { "a[", { "x", "o" }, desc = "outer []" },
  ["e["] = { "i[", { "x", "o" }, desc = "inner []" },
  ["w]"] = { "a]", { "x", "o" }, desc = "outer []" },
  ["e]"] = { "i]", { "x", "o" }, desc = "inner []" },
  ["w{"] = { "a}", { "x", "o" }, desc = "outer {}" },
  ["e{"] = { "i}", { "x", "o" }, desc = "inner {}" },
  ["w}"] = { "a}", { "x", "o" }, desc = "outer {}" },
  ["e}"] = { "i}", { "x", "o" }, desc = "inner {}" },
  ["w("] = { "a)", { "x", "o" }, desc = "outer ()" },
  ["e("] = { "i)", { "x", "o" }, desc = "inner ()" },
  ["w)"] = { "a)", { "x", "o" }, desc = "outer ()" },
  ["e)"] = { "i)", { "x", "o" }, desc = "inner ()" },
  ["w>"] = { "a>", { "x", "o" }, desc = "outer <>" },
  ["e>"] = { "i>", { "x", "o" }, desc = "inner <>" },
  ["w<"] = { "a>", { "x", "o" }, desc = "outer <>" },
  ["e<"] = { "i>", { "x", "o" }, desc = "inner <>" },
  ['w"'] = { 'a"', { "x", "o" }, desc = 'outer ""' },
  ['e"'] = { 'i"', { "x", "o" }, desc = 'inner ""' },
  ["w'"] = { "a'", { "x", "o" }, desc = "outer ''" },
  ["e'"] = { "i'", { "x", "o" }, desc = "inner ''" },
  ["w`"] = { "a`", { "x", "o" }, desc = "outer ``" },
  ["e`"] = { "i`", { "x", "o" }, desc = "inner ``" },
  ["el"] = {
    { "^og_", "x" },
    {
      function()
        vim.api.nvim_feedkeys("^vg_", "nx", false)
      end,
      "o",
    },
    desc = "inner line",
  },
  ["wl"] = {
    { "0o$h", "x" },
    {
      function()
        vim.api.nvim_feedkeys("0v$h", "nx", false)
      end,
      "o",
    },
    desc = "outer line",
  },
  ["wt"] = { "at", { "x", "o" }, desc = "outer tag block" },
  ["et"] = { "it", { "x", "o" }, desc = "inner tag block" },
  ["wa"] = {
    { "vggVG", "x" },
    {
      function()
        vim.api.nvim_feedkeys("ggVG", "nx", false)
      end,
      "o",
    },
    desc = "all(line)",
  },
  ["ea"] = {
    { "vgovG$", "x" },
    {
      function()
        vim.api.nvim_feedkeys("goVG", "nx", false)
      end,
      "o",
    },
    desc = "all",
  },
  ["wn"] = {
    function()
      vim.lsp.buf.selection_range(vim.v.count1)
    end,
    "x",
    desc = "vim.lsp.buf.selection_range(vim.v.count1)",
  },
  ["en"] = {
    function()
      vim.lsp.buf.selection_range(-vim.v.count1)
    end,
    "x",
    desc = "vim.lsp.buf.selection_range(-vim.v.count1)",
  },
}
