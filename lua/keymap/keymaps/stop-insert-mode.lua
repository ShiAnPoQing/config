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

local left_esc = {
  { "<Esc>", "i" },
  { "<C-u><ESC>", "c" },
  { "<C-\\><C-N>", "t", exclude_ft = { "yazi" } },
  desc = "Quit insert mode quickly",
}

local right_esc = {
  { "<Esc>l", "i" },
  { "<C-u><ESC>", "c" },
  { "<C-\\><C-N>", "t", exclude_ft = { "yazi" } },
  desc = "Quit insert mode quickly",
}

return {
  ["jk"] = left_esc,
  ["jj"] = left_esc,
  ["JK"] = left_esc,
  ["JJ"] = left_esc,
  ["kj"] = right_esc,
  ["kk"] = right_esc,
  ["KJ"] = right_esc,
  ["KK"] = right_esc,
  ["<C-0>"] = { "<C-o>", "i", desc = "CTRL-O" },
}
