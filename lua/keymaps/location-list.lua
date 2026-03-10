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
  -- ["<leader>lo"] = { "<cmd>lopen<cr>zz", "n", desc = "Open location list" },
  ["<leader>lc"] = { "<cmd>lclose<cr>zz", "n", desc = "Close location list" },
  ["<leader>lo"] = {
    function()
      ---@diagnostic disable-next-line: param-type-mismatch
      pcall(vim.cmd, "lnewer" .. vim.v.count1)
    end,
    "n",
    desc = "Newer location list",
  },
  ["<leader>li"] = {
    function()
      ---@diagnostic disable-next-line: param-type-mismatch
      pcall(vim.cmd, "lolder" .. vim.v.count1)
    end,
    "n",
    desc = "Older location list",
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
        local count = vim.v.count
        if count == 0 then
          count = 10
        end
        vim.cmd("lopen" .. count)
      else
        vim.notify("No location list found", vim.log.levels.WARN)
      end
    end,
    "n",
    desc = "Toggle Location List",
  },
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
  -- "[L"
  -- "]L"
  ["[fl"] = {
    function()
      local count = vim.v.count1
      --- @diagnostic disable-next-line
      local ok = pcall(vim.cmd, count .. "lpfile")
      if not ok then
        vim.cmd("llast")
      end
    end,
    "n",
    desc = "Display the last location in the [count] previous file in the list that includes a file name.",
  },
  ["]fl"] = {
    function()
      local count = vim.v.count1
      --- @diagnostic disable-next-line
      local ok = pcall(vim.cmd, count .. "lnfile")
      if not ok then
        vim.cmd("lfirst")
      end
    end,
    "n",
    desc = "Display the first location in the [count] next file in the list that includes a file name.",
  },
}
