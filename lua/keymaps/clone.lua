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

local clone = require("custom.plugins.clone-word")

return {
  -- clone up line with word step
  ["<M-S-w>"] = {
    {
      function()
        local count = vim.v.count1
        clone.copy_line_word("up", count)
      end,
      { "i", "n" },
    },
  },
  -- clone down line with word step
  ["<M-S-e>"] = {
    {
      function()
        local count = vim.v.count1
        clone.copy_line_word("down", count)
      end,
      { "i", "n" },
    },
  },
  -- clone up line with single letter
  ["<M-w>"] = {
    {
      "<C-y>",
      "i",
    },
    {
      function() end,
      "n",
    },
  },
  -- clone down line with single letter
  ["<M-e>"] = {
    {
      "<C-e>",
      "i",
    },
    {
      function() end,
      "n",
    },
  },
}
