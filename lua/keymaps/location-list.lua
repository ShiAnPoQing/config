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
  ["<leader>lo"] = { "<cmd>lopen<cr>zz", "n", desc = "Open location list" },
  ["]l"] = {
    function()
      local fq = vim.fn.getloclist(0, { idx = 0, size = 0 })
      local current_idx = fq.idx
      local total = fq.size
      local count = vim.v.count1

      if current_idx < total then
        vim.cmd(count .. "lnext")
      else
        vim.cmd("lfirst")
      end
      vim.cmd("normal! zz")
    end,
    "n",
    desc = "Next location list",
  },
  ["[l"] = {
    function()
      local current_idx = vim.fn.getloclist(0, { idx = 0 }).idx
      local count = vim.v.count1

      if current_idx > 1 then
        vim.cmd(count .. "lprev")
      else
        vim.cmd("llast")
      end
      vim.cmd("normal! zz")
    end,
    "n",
    desc = "Previous location list",
  },
  ["<leader>ll"] = {
    function()
      for _, win in pairs(vim.api.nvim_tabpage_list_wins(0)) do
        if vim.api.nvim_win_is_valid(win) and vim.fn.win_gettype(win) == "loclist" then
          vim.api.nvim_win_close(win, false)
          return
        end
      end
      local has_loclist = not vim.tbl_isempty(vim.fn.getloclist(0))
      if has_loclist then
        vim.cmd("lopen")
      else
        vim.notify("No location list found", vim.log.levels.WARN)
      end
    end,
    "n",
    desc = "Toggle Location List",
  },
}
