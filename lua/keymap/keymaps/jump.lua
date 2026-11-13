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
  ["<C-i>"] = {
    function()
      my.motion.jump(-1, { scope = "global" })
    end,
    { "n", "x" },
    desc = "Go to [count] older cursor position in jump list",
  },
  ["<C-o>"] = {
    function()
      my.motion.jump(1, { scope = "global" })
    end,
    { "n", "x" },
    desc = "Go to [count] newer cursor position in jump list",
  },
  ["<C-M-i>"] = {
    function() end,
    "n",
    desc = "Go to [count] older cursor position in jump list",
  },
  ["<C-M-o>"] = {
    function() end,
    "n",
    desc = "Go to [count] newer cursor position in jump list",
  },
  ["<C-S-i>"] = {
    function()
      my.motion.jump(-1, { scope = "local" })
    end,
    "n",
    desc = "Go to [count] older cursor position in jump list[buffer]",
  },
  ["<C-S-o>"] = {
    function()
      my.motion.jump(1, { scope = "local" })
    end,
    "n",
    desc = "Go to [count] newer cursor position in jump list[buffer]",
  },
}
