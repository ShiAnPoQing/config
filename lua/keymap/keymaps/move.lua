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

local j = function()
  return vim.v.count == 0 and "gj" or "j"
end

local k = function()
  return vim.v.count == 0 and "gk" or "k"
end

local c_mode_middle = function()
  require("builtin.cmdline").middle()
end

--- Don't use 'expr=true'
--- because if user press count, the final count will be spliced with 3.
--- like: user press '3H', the final count will be '33H'
local H = function()
  vim.api.nvim_feedkeys(vim.v.count1 * 3 .. "h", "n", false)
end

local L = function()
  vim.api.nvim_feedkeys(vim.v.count1 * 3 .. "l", "n", false)
end

local J = function()
  vim.api.nvim_feedkeys(vim.v.count1 * 3 .. "gj", "n", false)
end

local K = function()
  vim.api.nvim_feedkeys(vim.v.count1 * 3 .. "gk", "n", false)
end

return {
  ["G"] = {
    function()
      -- :keepjumps
      if vim.v.register == "_" then
        vim.api.nvim_win_set_cursor(0, { vim.fn.line("$"), vim.fn.col(".") - 1 })
        return
      end
      vim.cmd("normal! G")
    end,
    "n",
    desc = "G",
  },
  ["X"] = {
    function()
      vim.cmd("normal! xh")
    end,
    "n",
  },
  -- ["l"] = {
  --   function()
  --     vim.cmd("normal! v" .. vim.v.count1 .. "lol")
  --   end,
  --   "o",
  -- },
  ["j"] = { j, { "n", "x", "o" }, expr = true, desc = "Move down [count] lines" },
  ["k"] = { k, { "n", "x", "o" }, expr = true, desc = "Move up [count] lines" },
  ["<down>"] = { j, { "n", "x", "o" }, expr = true, desc = "Move down [count] lines" },
  ["<up>"] = { k, { "n", "x", "o" }, expr = true, desc = "Move up [count] lines" },
  ["[k"] = { "-", { "n", "x", "o" }, desc = "[count] lines upward, on the first non-blank character [linewise]" },
  ["]k"] = { "kg_", { "n", "x", "o" }, desc = "[count] lines upward, on the last non-blank character [linewise]" },
  ["[j"] = { "+", { "n", "x", "o" }, desc = "[count] lines downward, on the first non-blank character [linewise]" },
  ["]j"] = { "jg_", { "n", "x", "o" }, desc = "[count] lines downward, on the last non-blank character [linewise]" },
  ["H"] = {
    { H, { "n", "x" } },
    {
      function()
        vim.cmd("normal! " .. vim.v.count1 * 3 .. "h")
      end,
      "o",
    },
  },
  ["J"] = {
    { J, { "n", "x" } },
    {
      function()
        vim.cmd("normal! " .. vim.v.count1 * 3 .. "gj")
      end,
      "o",
    },
  },
  ["K"] = {
    { K, { "n", "x" } },
    {
      function()
        vim.cmd("normal! " .. vim.v.count1 * 3 .. "gk")
      end,
      "o",
    },
  },
  ["L"] = {
    { L, { "n", "x" } },
    {
      function()
        vim.cmd("normal! " .. vim.v.count1 * 3 .. "l")
      end,
      "o",
    },
  },
  ["<M-space><M-m>"] = { { "<C-o>gM", "i" }, { c_mode_middle, "c" }, desc = "Line Middle" },
  ["<M-space><M-n>"] = { "<C-o>gM", "i" },
  ["<space>m"] = { "gM", { "n", "x", "o" } },
  ["<space>n"] = { "M", { "n", "x", "o" } },
  ["<space>k"] = {
    {
      "<cmd>lua my.motion.NORMAL.backward_paragraph_start()<cr>",
      { "n", "x" },
    },
    {
      "<cmd>lua my.motion.OPERATOR.backward_paragraph_start()<cr>",
      "o",
    },
  },
  ["<space>j"] = {
    {
      "<cmd>lua my.motion.NORMAL.forward_paragraph_end()<cr>",
      { "n", "x" },
    },
    {
      "<cmd>lua my.motion.OPERATOR.forward_paragraph_end()<cr>",
      "o",
    },
  },
  ["<space><space>k"] = {
    {
      "<cmd>lua my.motion.NORMAL.backward_paragraph_end()<cr>",
      { "n", "x" },
    },
    {
      "<cmd>lua my.motion.OPERATOR.backward_paragraph_end()<cr>",
      "o",
    },
  },
  ["<space><space>j"] = {
    {
      "<cmd>lua my.motion.NORMAL.forward_paragraph_start()<cr>",
      { "n", "x" },
    },
    {
      "<cmd>lua my.motion.OPERATOR.forward_paragraph_start()<cr>",
      "o",
    },
  },
  -- ["<space><M-h>"] = { "I", "n" },
  -- ["<space><M-l>"] = { "A", "n" },

  ["<M-space><M-h>"] = {
    {
      "<cmd>lua my.motion.first_non_blank()<cr>",
      "c",
    },
    { "<C-G>^<C-G>", "s" },
    desc = "Move to the first non-blank character",
  },
  ["<M-space><M-l>"] = {
    {
      "<cmd>lua my.motion.last_non_blank()<cr>",
      "c",
    },
    { "<C-G>g_<C-G>", "s" },
    desc = "Move to the last non-blank character",
  },
  ["<M-space><M-space><M-l>"] = { "<End>", "c" },
  ["<M-space><M-space><M-h>"] = { "<Home>", "c" },
  ["<space>H"] = {
    {
      function()
        require("builtin.start-end-move").first_character()
      end,
      "n",
    },
    { "0", "x" },
    --- contains the character under the cursor
    { "v0", "o" },
    desc = "Move to the first character of the line",
  },
  ["<S-Space>H"] = {
    {
      function()
        require("builtin.start-end-move").first_character()
      end,
      "n",
    },
    { "0", "x" },
    --- contains the character under the cursor
    { "v0", "o" },
    desc = "Move to the first character of the line",
  },
  ["<space>L"] = {
    {
      function()
        require("builtin.start-end-move").last_character()
      end,
      "n",
    },
    { "$", "o" },
    { "$h", "x" },
    desc = "Move to the last character of the line",
  },
  ["<S-space>L"] = {
    {
      function()
        require("builtin.start-end-move").last_character()
      end,
      "n",
    },
    { "$", "o" },
    { "$h", "x" },
    desc = "Move to the last character of the line",
  },

  [my.keymap.keys.CTRL_9] = {
    {
      "-",
      { "n", "x", "o" },
      desc = "[count] lines upward, on the first non-blank character (linewise).",
    },
    {
      "<C-o>-",
      "i",
      desc = "line upward, on the first non-blank character (linewise).",
    },
  },
  [my.keymap.keys.CTRL_0] = {
    {
      "<up>g_",
      { "n", "x", "o" },
      desc = "[count] lines upward, on the last non-blank character (linewise).",
    },
    {
      "<up><esc>g_a",
      "i",
      desc = "line upward, on the last non-blank character (linewise).",
    },
  },
  ["<M-9>"] = {
    {
      "+",
      { "n", "x", "o" },
      desc = "[count] lines downward, on the first non-blank character (linewise).",
    },
    {
      "<C-o>+",
      "i",
      desc = "line downward, on the first non-blank character (linewise).",
    },
  },
  ["<M-0>"] = {
    {
      "<down>g_",
      { "n", "x", "o" },
      desc = "[count] lines downward, on the last non-blank character (linewise).",
    },
    {
      "<down><esc>g_a",
      "i",
      desc = "line downward, on the last non-blank character (linewise).",
    },
  },
  ["<C-,>"] = {
    function()
      return vim.v.count == 0 and "gk^" or "k^"
    end,
    "n",
    expr = true,
  },
  ["<M-,>"] = {
    function()
      return vim.v.count == 0 and "gj^" or "j^"
    end,
    "n",
    expr = true,
  },
  ["<C-.>"] = {
    function()
      return vim.v.count == 0 and "gkg_" or "kg_"
    end,
    "n",
    expr = true,
  },
  ["<M-.>"] = {
    function()
      return vim.v.count == 0 and "gjg_" or "jg_"
    end,
    "n",
    expr = true,
  },
}
