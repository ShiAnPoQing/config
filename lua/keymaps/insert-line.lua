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
    "o",
    {
      { "n", desc = "Begin a new line below the cursor and insert text" },
      { "x", desc = "Go to Other end of highlighted text" },
    },
  },
  ["B"] = {
    "O",
    {
      { "n", desc = "Begin a new line above the cursor and insert text" },
      { "x", desc = "Go to Other end of highlighted text" },
    },
  },
  ["<space>b"] = { "o^<C-d>", "n", desc = "Begin a new line below the cursor and insert text(non-blank)(non-comment)" },
  ["<space>B"] = { "O^<C-d>", "n", desc = "Begin a new line above the cursor and insert text(non-blank)(non-comment)" },
  ["<space><space>b"] = {
    function()
      return "o^<C-d>" .. vim.fn["repeat"](" ", vim.fn.virtcol(".") - 1)
    end,
    "n",
    expr = true,
    desc = "Begin a new line below the cursor, indent same cursor col",
  },
  ["<space><space>B"] = {
    function()
      return "O^<C-d>" .. vim.fn["repeat"](" ", vim.fn.virtcol(".") - 1)
    end,
    "n",
    expr = true,
    desc = "Begin a new line above the cursor, indent same cursor col",
  },
  ["<C-b>"] = {
    insert_line.above_no_follow,
    { "n", "i" },
    desc = "Add empty line above cursor[no follow]",
  },
  ["<M-b>"] = {
    insert_line.below_no_follow,
    { "n", "i" },
    desc = "Add empty line below cursor[no follow]",
  },
  ["<C-S-b>"] = { insert_line.above, { "n", "i" }, desc = "Add empty line above cursor[follow]" },
  ["<M-S-b>"] = { insert_line.below, { "n", "i" }, desc = "Add empty line below cursor[follow]" },
  ["<C-space><C-b>"] = {
    insert_line.above_no_follow_no_indent,
    "i",
    desc = "Add empty line above cursor[no follow][no indent]",
  },
  ["<M-space><M-b>"] = {
    insert_line.below_no_follow_no_indent,
    "i",
    desc = "Add empty line below cursor[no follow][no indent]",
  },
  ["<C-space><C-space><C-b>"] = {
    function()
      return "<esc>O^<C-d>" .. vim.fn["repeat"](" ", vim.fn.virtcol(".") - 1)
    end,
    "i",
    expr = true,
    desc = "Begin a new line below the cursor, indent same cursor col",
  },
  ["<M-space><M-space><M-b>"] = {
    function()
      return "<esc>o^<C-d>" .. vim.fn["repeat"](" ", vim.fn.virtcol(".") - 1)
    end,
    "i",
    expr = true,
    desc = "Begin a new line above the cursor, indent same cursor col",
  },
  ["[<space>"] = { insert_line.above, "n", desc = "Add empty line above cursor[follow]" },
  ["]<space>"] = { insert_line.below, "n", desc = "Add empty line below cursor[follow]" },
  ["<space>["] = { insert_line.above_no_follow, "n", desc = "Add empty line above cursor[no follow]" },
  ["<space>]"] = { insert_line.below_no_follow, "n", desc = "Add empty line below cursor[no follow]" },
  ["<M-[><M-space>"] = { insert_line.above, "i", desc = "Add empty line above cursor[follow]" },
  ["<M-]><M-space>"] = { insert_line.below, "i", desc = "Add empty line below cursor[follow]" },
  ["<M-space><M-[>"] = { insert_line.above_no_follow, "i", desc = "Add empty line above cursor[no follow]" },
  ["<M-space><M-]>"] = { insert_line.below_no_follow, "i", desc = "Add empty line below cursor[no follow]" },
  ["<M-space><M-space><M-[>"] = {
    insert_line.above_no_follow_no_indent,
    "i",
    desc = "Add empty line above cursor[no follow][no indent]",
  },
  ["<M-space><M-space><M-]>"] = {
    insert_line.below_no_follow_no_indent,
    "i",
    desc = "Add empty line below cursor[no follow][no indent]",
  },
  ["<S-CR>"] = { "<CR><C-U>", "i", desc = "Begin new line(non-blank)" },
}
