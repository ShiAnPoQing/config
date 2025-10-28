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

local o_mode_space_i = function()
  vim.api.nvim_feedkeys("vgeloh", "nx", false)
end

local o_mode_space_I = function()
  vim.api.nvim_feedkeys("vgEloh", "nx", false)
end

local c_mode_space_i = function()
  require("builtin.cmdline").word_end_backward()
end

local c_mode_space_o = function()
  require("builtin.cmdline").word_start_forward()
end

local c_mode_i = function()
  require("builtin.cmdline").word_start_backward()
end

local c_mode_o = function()
  require("builtin.cmdline").word_end_forward()
end

return {
  ["i"] = { "b", { "n", "x", "o" }, desc = "Backward to the start of word[count]" },
  ["o"] = { "e", { "n", "x", "o" }, desc = "Forword to the end of the word[count]" },
  ["I"] = { "B", { "n", "x", "o" }, desc = "Backward to the start of WORD[count]" },
  ["O"] = { "E", { "n", "x", "o" }, desc = "Forword to the end of the WORD[count]" },
  ["<space>i"] = {
    { "ge", "n" },
    { "hgel", "x", desc = "Backward to the end of word[count](left exclusion)" },
    { o_mode_space_i, "o", desc = "Backward to the end of word[count](left exclusion)" },
    desc = "Backward to the end of word[count]",
  },
  ["<space>o"] = {
    { "w", { "n", "o" } },
    { "lwh", "x", desc = "Forword to the start of the word[count](right exclusion)" },
    desc = "Forword to the start of the word[count]",
  },
  ["<space>I"] = {
    { "gE", "n" },
    { "hgEl", "x", desc = "Backward to the end of WORD[count](left exclusion)" },
    { o_mode_space_I, "o", desc = "Backward to the end of WORD[count](left exclusion)" },
    desc = "Backward to the end of WORD[count]",
  },
  ["<space>O"] = {
    { "W", { "n", { "o", desc = "Forword to the start of the WORD[count](right exclusion)" } } },
    { "lWh", "x", desc = "Forword to the start of the WORD[count](right exclusion)" },
    desc = "Forword to the start of the WORD[count]",
  },
  ["<M-i>"] = {
    { "bi", "n", desc = "Backward to the start of word[count] and start insert mode" },
    { "<S-left>", { "i", "s" } },
    { "<C-left>", "t" },
    { c_mode_i, "c" },
    desc = "Backward to the start of word",
  },
  ["<M-o>"] = {
    { "ea", "n", desc = "Forword to the end of the word[count] and start insert mode" },
    { "<Esc>ea", "i" },
    { "<C-right>", "t" },
    { "<C-G>e<C-G>", "s" },
    { c_mode_o, "c" },
    desc = "Forword to the end of the word",
  },
  ["<M-space><M-i>"] = {
    { "<Esc>gea", "i" },
    { c_mode_space_i, "c" },
    { "<C-G>ge<C-G>", "s" },
    desc = "Backward to the end of word",
  },
  ["<M-space><M-o>"] = {
    { "<S-right>", "i" },
    { c_mode_space_o, "c" },
    { "<C-G>w<C-G>", "s" },
    desc = "Forword to the start of the word",
  },
  ["<M-S-i>"] = {
    { "<Esc>Bi", "i", desc = "Backward to the start of WORD" },
    { "Bi", "n", desc = "Backward to the start of WORD and start insert mode" },
  },
  ["<M-S-o>"] = {
    { "<Esc>Ea", "i", desc = "Forword to the end of the WORD" },
    { "Ea", "n", desc = "Forword to the end of the WORD and start insert mode" },
  },
  ["<M-space><M-S-i>"] = { "<C-o>gE", "i", desc = "Backward to the end of WORD[count]" },
  ["<M-space><M-S-o>"] = { "<C-o>W", "i", desc = "Forword to the start of the word[count]" },
}
