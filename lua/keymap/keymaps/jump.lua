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
  ["`'"] = {
    function() end,
    "n",
    desc = "Go to last position of jumplist",
  },
  ["<C-i>"] = {
    function()
      my.motion.jump(-vim.v.count1, { scope = "global" })
    end,
    { "n", "x" },
    desc = "Go to [count] older cursor position",
  },
  ["<C-o>"] = {
    function()
      my.motion.jump(vim.v.count1, { scope = "global" })
    end,
    { "n", "x" },
    desc = "Go to [count] newer cursor position",
  },
  ["<C-S-i>"] = {
    function()
      my.motion.jump.buffer(-vim.v.count1)
    end,
    "n",
    desc = "Go to [count] older buffer[last cursor position]",
  },
  ["<C-S-o>"] = {
    function()
      my.motion.jump.buffer(vim.v.count1)
    end,
    "n",
    desc = "Go to [count] newer buffer[first cursor position]",
  },
  ["<C-M-i>"] = {
    function()
      my.motion.jump(-vim.v.count1, { scope = "local" })
    end,
    "n",
    desc = "Go to [count] older cursor position[current buffer]",
  },
  ["<C-M-o>"] = {
    function()
      my.motion.jump(vim.v.count1, { scope = "local" })
    end,
    "n",
    desc = "Go to [count] newer cursor position[current buffer]",
  },
}
