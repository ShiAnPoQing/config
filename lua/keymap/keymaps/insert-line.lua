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
local insert_line = require("builtin.insert-line")

return {
  ["b"] = {
    {
      "o",
      {
        { "n", desc = "Begin a new line below the cursor and start [count] insert " },
        { "x", desc = "Goto other side of visual selection" },
      },
    },
  },
  ["B"] = {
    "O",
    {
      { "n", desc = "Begin a new line above the cursor and start [count] insert" },
      { "x", desc = "Goto other side of visual selection" },
    },
  },
  ["<space>b"] = {
    "o^<C-d>",
    "n",
    desc = "Begin a new line(non-indent & non-comment) below the cursor and start [count] insert",
  },
  ["<space>B"] = {
    "O^<C-d>",
    "n",
    desc = "Begin a new line(non-indent & non-comment) above the cursor and start [count] insert",
  },
  ["<space><space>b"] = {
    function()
      return "o^<C-d>" .. vim.fn["repeat"](" ", vim.fn.virtcol(".") - 1)
    end,
    "n",
    expr = true,
    desc = "Begin a new line below the cursor and start [count] insert, but indent same as cursor col",
  },
  ["<space><space>B"] = {
    function()
      return "O^<C-d>" .. vim.fn["repeat"](" ", vim.fn.virtcol(".") - 1)
    end,
    "n",
    expr = true,
    desc = "Begin a new line above the cursor and start [count] insert and the indent same as cursor col",
  },
  ["<C-b>"] = {
    insert_line.above_no_follow,
    {
      { "n", desc = "Begin [count] new line above the cursor, but not start insert" },
      { "i", desc = "Begin a new line above the cursor" },
    },
  },
  ["<M-b>"] = {
    insert_line.below_no_follow,
    {
      { "n", desc = "Begin [count] new line below the cursor, but not start insert" },
      { "i", desc = "Begin a new line below the cursor" },
    },
  },
  ["<C-S-b>"] = {
    insert_line.above,
    {

      { "n", desc = "Add [count] new line above the cursor" },
      { "i", desc = "Add a new line above the cursor" },
    },
  },
  ["<M-S-b>"] = {
    insert_line.below,
    {
      { "n", desc = "Add [count] new line below the cursor" },
      { "i", desc = "Add a new line below the cursor" },
    },
  },
  ["<M-C-b>"] = {
    insert_line.above_and_below,
    "n",
    desc = "Add [count] new line above the cursor and [count] new line below the cursor",
  },
  ["<C-space><C-b>"] = {
    insert_line.above_no_follow_no_indent,
    "i",
    desc = "Add a new line(non-indent & non-comment) above the cursor",
  },
  ["<M-space><M-b>"] = {
    insert_line.below_no_follow_no_indent,
    "i",
    desc = "Add a new line(non-indent & non-comment) below the cursor",
  },
  ["<C-space><C-space><C-b>"] = {
    function()
      return "<esc>O^<C-d>" .. vim.fn["repeat"](" ", vim.fn.virtcol(".") - 1)
    end,
    "i",
    expr = true,
    desc = "Begin a new line below the cursor, but the indent same as cursor col",
  },
  ["<M-space><M-space><M-b>"] = {
    function()
      return "<esc>o^<C-d>" .. vim.fn["repeat"](" ", vim.fn.virtcol(".") - 1)
    end,
    "i",
    expr = true,
    desc = "Begin a new line above the cursor, but the indent same as cursor col",
  },
  ["[<space>"] = { insert_line.above, "n", desc = "Add [count] new line above the cursor" },
  ["]<space>"] = { insert_line.below, "n", desc = "Add [count] new line below the cursor" },
  ["<space>["] = {
    insert_line.above_no_follow,
    "n",
    desc = "Begin [count] new line above the cursor, but not start insert",
  },
  ["<space>]"] = {
    insert_line.below_no_follow,
    "n",
    desc = "Being [count] new line below the cursor, but not start insert",
  },
  ["<M-[><M-space>"] = { insert_line.above, "i", desc = "Add a new line above the cursor" },
  ["<M-]><M-space>"] = { insert_line.below, "i", desc = "Add a new line below the cursor" },
  ["<M-space><M-[>"] = { insert_line.above_no_follow, "i", desc = "Begin a new line above the cursor" },
  ["<M-space><M-]>"] = { insert_line.below_no_follow, "i", desc = "Begin a new line below the cursor" },
  ["<M-space><M-space><M-[>"] = {
    insert_line.above_no_follow_no_indent,
    "i",
    desc = "Begin a new line(non-indent & non-comment) above the cursor",
  },
  ["<M-space><M-space><M-]>"] = {
    insert_line.below_no_follow_no_indent,
    "i",
    desc = "Begin a new line(non-indent & non-comment) below the cursor",
  },
  ["<S-CR>"] = { "<CR><Space><C-U>", "i", desc = "Begin new line(non-blank)", exclude_ft = "prompt" },
  ["<C-CR>"] = { "<CR><C-o>k<C-o>$", "i", desc = "Begin new line(keep cursor)" },
  ["<M-CR>"] = { "<CR><C-o>O", "i", desc = "insert new line(line break)" },
}
