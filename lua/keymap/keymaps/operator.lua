---------------------------------------------------------------------------------------------------+
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
-- local cursor
-- local cursors
-- local mc = vim.api.nvim_create_namespace("nvim.multicursor")
--
-- vim.api.nvim_create_autocmd("TextYankPost", {
--   callback = function()
--     if vim.v.event.operator == "y" and cursor then
--       vim.schedule(function()
--         if cursors then
--           for _, c in ipairs(cursors) do
--             vim.api.nvim_buf_set_extmark(0, mc, c[2], c[3], { id = c[1] })
--           end
--           cursors = nil
--         end
--         vim.api.nvim_win_set_cursor(0, cursor)
--       end)
--     end
--   end,
-- })
-- ["y"] = {
--   function()
--     cursor = vim.api.nvim_win_get_cursor(0)
--     if my.multicursor.active() then
--       cursors = my.multicursor.get(0, 0, -1)
--     end
--     return "y"
--   end,
--   "n",
--   expr = true,
-- },

return {
  ["y"] = {
    {
      function()
        my.operator.yank()
      end,
      { "n", "x" },
    },
    {
      function()
        if my.operator.is_yank_operator() then
          return "_"
        end
      end,
      "o",
      expr = true,
    },
  },
  ["d"] = {
    {
      function()
        my.operator.delete()
      end,
      { "n", "x" },
    },
    {
      function()
        if my.operator.is_delete_operator() then
          return "_"
        end
      end,
      "o",
      expr = true,
    },
  },
  ["<M-c>"] = { "<C-o>c", "i", desc = "c" },
  ["<M-x>"] = { "<C-o>x", "i", desc = "x" },
  ["<M-S-`>"] = { "<C-o>~", "i", desc = "`" },
  ["<M-d>"] = { "<C-o>d", "i", desc = "d" },
  ["<M-y>"] = { "<C-o>y", "i", desc = "y" },
  ["<M-f>"] = { "<C-o>f", "i", desc = "f" },
  ["<M-t>"] = { "<C-o>t", "i", desc = "t" },
}
