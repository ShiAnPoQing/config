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
  -- no blank
  ["<space>b"] = { "o^<C-d>", "n", desc = "Begin a new line below the cursor and insert text(non-blank)" },
  -- no blank
  ["<space>B"] = { "O^<C-d>", "n", desc = "Begin a new line above the cursor and insert text(non-blank)" },
  -- no blank
  ["<S-CR>"] = { "<CR><C-U>", "i", desc = "Begin new line(non-blank)" },
  ["<C-b>"] = { insert_line.above, { "n", "i" }, desc = "Add empty line above cursor[follow]" },
  ["<C-space><C-b>"] = {
    insert_line.above_no_follow_no_indent,
    "i",
    desc = "Add empty line above cursor[no follow][no indent]",
  },
  ["<M-b>"] = { insert_line.below, { "n", "i" }, desc = "Add empty line below cursor[follow]" },
  ["<M-space><M-b>"] = {
    insert_line.below_no_follow_no_indent,
    "i",
    desc = "Add empty line below cursor[no follow][no indent]",
  },
  ["<C-S-b>"] = {
    insert_line.above_no_follow,
    { "n", "i" },
    desc = "Add empty line above cursor[no follow]",
  },
  ["<M-S-b>"] = {
    insert_line.below_no_follow,
    { "n", "i" },
    desc = "Add empty line below cursor[no follow]",
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
}
