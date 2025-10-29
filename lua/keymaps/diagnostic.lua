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
-- see /usr/share/nvim/runtime/lua/vim/_defaults.lua

return {
  ["<leader>da"] = {
    function()
      vim.diagnostic.setloclist()
    end,
    "n",
    desc = "Show diagnostic in location list",
  },
  ["<leader>dq"] = {
    function()
      vim.diagnostic.setqflist()
    end,
    "n",
    desc = "Show diagnostic in quickfix list",
  },
  ["<leader>df"] = {
    function()
      vim.diagnostic.open_float({})
    end,
    "n",
  },
  ["[w"] = {
    function()
      vim.diagnostic.jump({ severity = vim.diagnostic.severity.WARN, count = -1 })
      vim.api.nvim_feedkeys("zz", "n", false)
    end,
    "n",
    desc = "Goto prev WARN diagnostic",
  },
  -- Goto next WARN diagnostic
  ["]w"] = {
    function()
      vim.diagnostic.jump({ severity = vim.diagnostic.severity.WARN, count = 1 })
      vim.api.nvim_feedkeys("zz", "n", false)
    end,
    "n",
    desc = "Goto next WARN diagnostic",
  },
  -- Goto next error diagnostic
  ["]e"] = {
    function()
      vim.diagnostic.jump({ severity = vim.diagnostic.severity.ERROR, count = 1 })
      vim.api.nvim_feedkeys("zz", "n", false)
    end,
    "n",
    desc = "Goto next error diagnostic",
  },
  -- Goto previous error diagnostic
  ["[e"] = {
    function()
      vim.diagnostic.jump({ severity = vim.diagnostic.severity.ERROR, count = -1 })
      vim.api.nvim_feedkeys("zz", "n", false)
    end,
    "n",
    desc = "Goto prev ERROR diagnostic",
  },
  ["[d"] = {
    function()
      vim.diagnostic.jump({ count = -vim.v.count1 })
    end,
    "n",
    desc = "Goto prev diagnostic",
  },
  ["]d"] = {
    function()
      vim.diagnostic.jump({ count = vim.v.count1 })
    end,
    "n",
    desc = "Goto next diagnostic",
  },
  ["]D"] = {
    function()
      vim.diagnostic.jump({ count = vim._maxint, wrap = false })
    end,
    "n",
    desc = "Goto last diagnostic",
  },
  ["[D"] = {
    function()
      vim.diagnostic.jump({ count = -vim._maxint, wrap = false })
    end,
    "n",
    desc = "Goto first diagnostic",
  },
}
