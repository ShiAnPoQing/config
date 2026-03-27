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

local o_mode_space_i = function()
  vim.api.nvim_feedkeys("vgeloh", "nx", false)
end

local o_mode_space_I = function()
  vim.api.nvim_feedkeys("vgEloh", "nx", false)
end

return {
  ["i"] = {
    {
      function()
        local function callback()
          vim.api.nvim_feedkeys(vim.v.count1 .. "b", "n", false)
          require("repeat").set_motion(callback)
        end
        callback()
      end,
      { "n", "x" },
    },
    {
      "b",
      "o",
    },
    desc = "Backward to the start of word[count]",
  },
  ["o"] = {
    {
      function()
        local function callback()
          vim.api.nvim_feedkeys(vim.v.count1 .. "e", "n", false)
          require("repeat").set_motion(callback)
        end
        callback()
      end,
      { "n", "x" },
    },
    {
      "e",
      "o",
    },
    desc = "Forword to the end of the word[count]",
  },
  ["I"] = {
    {
      function()
        local function callback()
          vim.api.nvim_feedkeys(vim.v.count1 .. "B", "n", false)
          require("repeat").set_motion(callback)
        end
        callback()
      end,
      { "n", "x" },
    },
    {
      "B",
      "o",
    },
    desc = "Backward to the start of WORD[count]",
  },
  ["O"] = {
    {
      function()
        local function callback()
          vim.api.nvim_feedkeys("E", "n", false)
          require("repeat").set_motion(callback)
        end
        callback()
      end,
      { "n", "x" },
    },
    {
      "E",
      "o",
    },
    desc = "Forword to the end of the WORD[count]",
  },
  ["<space>i"] = {
    {
      function()
        local function callback()
          vim.api.nvim_feedkeys(vim.v.count1 .. "ge", "n", false)
          require("repeat").set_motion(callback)
        end
        callback()
      end,
      "n",
    },
    { "hgel", "x", desc = "Backward to the end of word[count](left exclusion)" },
    { o_mode_space_i, "o", desc = "Backward to the end of word[count](left exclusion)" },
    desc = "Backward to the end of word[count]",
  },
  ["<space>o"] = {
    {
      function()
        local function callback()
          vim.api.nvim_feedkeys(vim.v.count1 .. "w", "n", false)
          require("repeat").set_motion(callback)
        end
        callback()
      end,
      "n",
    },
    {
      "w",
      "o",
    },
    { "lwh", "x", desc = "Forword to the start of the word[count](right exclusion)" },
    desc = "Forword to the start of the word[count]",
  },
  ["<S-space>I"] = {
    {
      function()
        local function callback()
          vim.api.nvim_feedkeys(vim.v.count1 .. "gE", "n", false)
          require("repeat").set_motion(callback)
        end
        callback()
      end,
      "n",
    },
    { "hgEl", "x", desc = "Backward to the end of WORD[count](left exclusion)" },
    { o_mode_space_I, "o", desc = "Backward to the end of WORD[count](left exclusion)" },
    desc = "Backward to the end of WORD[count]",
  },
  ["<space>I"] = {
    {
      function()
        local function callback()
          vim.api.nvim_feedkeys(vim.v.count1 .. "gE", "n", false)
          require("repeat").set_motion(callback)
        end
        callback()
      end,
      "n",
    },
    { "hgEl", "x", desc = "Backward to the end of WORD[count](left exclusion)" },
    { o_mode_space_I, "o", desc = "Backward to the end of WORD[count](left exclusion)" },
    desc = "Backward to the end of WORD[count]",
  },
  ["<S-space>O"] = {
    {
      function()
        local function callback()
          vim.api.nvim_feedkeys(vim.v.count1 .. "W", "n", false)
          require("repeat").set_motion(callback)
        end
        callback()
      end,
      "n",
    },
    {
      "W",
      "o",
      desc = "Forword to the start of the WORD[count](right exclusion)",
    },
    { "lWh", "x", desc = "Forword to the start of the WORD[count](right exclusion)" },
    desc = "Forword to the start of the WORD[count]",
  },
  ["<space>O"] = {
    {
      function()
        local function callback()
          vim.api.nvim_feedkeys(vim.v.count1 .. "W", "n", false)
          require("repeat").set_motion(callback)
        end
        callback()
      end,
      "n",
    },
    {
      "W",
      "o",
      desc = "Forword to the start of the WORD[count](right exclusion)",
    },
    { "lWh", "x", desc = "Forword to the start of the WORD[count](right exclusion)" },
    desc = "Forword to the start of the WORD[count]",
  },
  ["<M-i>"] = {
    { "bi", "n", desc = "Backward to the start of word[count] and start insert mode" },
    { "<S-left>", "i" },
    {
      function()
        require("builtin.expand-select").expand_select_left_word()
      end,
      "s",
      desc = "Expand word[left]",
    },
    { "<C-left>", "t" },
    {
      function()
        require("builtin.cmdline").prev_word_start()
      end,
      "c",
    },
    desc = "Backward to the start of word",
  },
  ["<M-o>"] = {
    { "ea", "n", desc = "Forword to the end of the word[count] and start insert mode" },
    { "<Esc>ea", "i" },
    { "<C-right>", "t" },
    {
      function()
        require("builtin.expand-select").expand_select_right_word()
      end,
      "s",
      desc = "Expand word[right]",
    },
    {
      function()
        require("builtin.cmdline").next_word_end()
      end,
      "c",
    },
    desc = "Forword to the end of the word",
  },
  ["<M-space><M-i>"] = {
    { "<Esc>gea", "i" },
    {
      function()
        require("builtin.cmdline").prev_word_end()
      end,
      "c",
    },
    {
      function()
        require("builtin.expand-select").expand_select_left_word_with_blank()
      end,
      "s",
    },
    desc = "Backward to the end of word",
  },
  ["<M-space><M-o>"] = {
    { "<S-right>", "i" },
    {
      function()
        require("builtin.cmdline").next_word_start()
      end,
      "c",
    },
    {
      function()
        require("builtin.expand-select").expand_select_right_word_with_blank()
      end,
      "s",
    },
    desc = "Forword to the start of the word",
  },
  ["<M-S-i>"] = {
    { "<Esc>Bi", "i", desc = "Backward to the start of WORD" },
    { "Bi", "n", desc = "Backward to the start of WORD and start insert mode" },
    {
      function()
        require("builtin.cmdline").prev_WORD_start()
      end,
      "c",
      desc = "Backward to the start of WORD",
    },
  },
  ["<M-S-o>"] = {
    { "<Esc>Ea", "i", desc = "Forword to the end of the WORD" },
    { "Ea", "n", desc = "Forword to the end of the WORD and start insert mode" },
    {
      function()
        require("builtin.cmdline").next_WORD_end()
      end,
      "c",
      desc = "Forword to the end of the WORD",
    },
  },
  ["<M-space><M-S-i>"] = {
    {
      "<Esc>gEa",
      "i",
    },
    {
      function()
        require("builtin.cmdline").prev_WORD_end()
      end,
      "c",
    },
    desc = "Backward to the end of WORD[count]",
  },
  ["<M-space><M-S-o>"] = {
    {
      "<C-o>W",
      "i",
    },
    {
      function()
        require("builtin.cmdline").next_WORD_start()
      end,
      "c",
    },
    desc = "Forword to the start of the word[count]",
  },
  ["<M-S-space><M-S-i>"] = {
    {
      "<Esc>gEa",
      "i",
    },
    {
      function()
        require("builtin.cmdline").prev_WORD_end()
      end,
      "c",
    },
    desc = "Backward to the end of WORD[count]",
  },
  ["<M-S-space><M-S-o>"] = {
    {
      "<C-o>W",
      "i",
    },
    {
      function()
        require("builtin.cmdline").next_WORD_start()
      end,
      "c",
    },
    desc = "Forword to the start of the word[count]",
  },
}
