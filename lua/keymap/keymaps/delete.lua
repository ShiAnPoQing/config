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

return {
  ["<BS>"] = {
    { "s", "n", desc = "same as 's'" },
    { "d", "x", desc = "same as 'd'" },
  },
  ["<S-BS>"] = {
    { "x", "n" },
    desc = "Delete character after the cursor",
  },
  ["<C-bs>"] = {
    { '"_ciw', "n" },
    desc = "Delete cword(before)",
  },
  ["<M-BS>"] = {
    { '"_ciw', "n" },
    desc = "Delete the cword(after)",
  },
  ["<C-S-BS>"] = {
    { '"_ciW', "n" },
    desc = "Delete the CWORD(before)",
  },
  ["<M-S-BS>"] = {
    { '"_ciW', "n" },
    desc = "Delete the CWORD(after)",
  },
}
