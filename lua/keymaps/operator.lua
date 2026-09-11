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

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    if vim.v.event.operator == "y" and vim.b.cursorPreYank then
      vim.api.nvim_win_set_cursor(0, vim.b.cursorPreYank)
    end
  end,
})

return {
  ["gU"] = {
    function()
      vim.b.cursorPreYank = vim.api.nvim_win_get_cursor(0)
      return "gU"
    end,
    { "n", "x" },
    expr = true,
  },
  ["gu"] = {
    function()
      vim.b.cursorPreYank = vim.api.nvim_win_get_cursor(0)
      return "gu"
    end,
    { "n", "x" },
    expr = true,
  },
  ["g~"] = {
    function()
      vim.b.cursorPreYank = vim.api.nvim_win_get_cursor(0)
      return "g~"
    end,
    { "n", "x" },
    expr = true,
  },
  ["y"] = {
    function()
      vim.b.cursorPreYank = vim.api.nvim_win_get_cursor(0)
      return "y"
    end,
    { "n", "x" },
    expr = true,
  },
  ["Y"] = {
    function()
      vim.b.cursorPreYank = vim.api.nvim_win_get_cursor(0)
      return "y$"
    end,
    { "n", "x" },
    expr = true,
  },
  ["<M-c>"] = { "<C-o>c", "i", desc = "c" },
  ["<M-x>"] = { "<C-o>x", "i", desc = "x" },
  ["<M-S-`>"] = { "<C-o>~", "i", desc = "`" },
  ["<M-d>"] = { "<C-o>d", "i", desc = "d" },
  ["<M-y>"] = { "<C-o>y", "i", desc = "y" },
  ["<M-f>"] = { "<C-o>f", "i", desc = "f" },
  ["<M-t>"] = { "<C-o>t", "i", desc = "t" },
}
