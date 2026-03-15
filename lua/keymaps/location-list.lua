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
      require("builtin.location").toggle()
    end,
    "n",
    desc = "Toggle Location List",
  },
  ["]l"] = {
    function()
      local function callback()
        require("builtin.location").goto_next_location()
        require("repeat").set_motion(callback)
      end
      callback()
    end,
    "n",
    desc = "Next location list",
  },
  ["[l"] = {
    function()
      local function callback()
        require("builtin.location").goto_prev_location()
        require("repeat").set_motion(callback)
      end
      callback()
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
