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
  ["j"] = { j, { "n", "x", "o" }, expr = true, desc = "Move down [count] lines" },
  ["k"] = { k, { "n", "x", "o" }, expr = true, desc = "Move up [count] lines" },
  ["<down>"] = { j, { "n", "x", "o" }, expr = true, desc = "Move down [count] lines" },
  ["<up>"] = { k, { "n", "x", "o" }, expr = true, desc = "Move up [count] lines" },
  ["[k"] = { "-", { "n", "x", "o" }, desc = "[count] lines upward, on the first non-blank character [linewise]" },
  ["]k"] = { "kg_", { "n", "x", "o" }, desc = "[count] lines upward, on the last non-blank character [linewise]" },
  ["[j"] = { "+", { "n", "x", "o" }, desc = "[count] lines downward, on the first non-blank character [linewise]" },
  ["]j"] = { "jg_", { "n", "x", "o" }, desc = "[count] lines downward, on the last non-blank character [linewise]" },
  ["H"] = { H, { "n", "x", "o" } },
  ["J"] = { J, { "n", "x", "o" } },
  ["K"] = { K, { "n", "x", "o" } },
  ["L"] = { L, { "n", "x", "o" } },
  ["<M-j>"] = { "<down>", { "i", "c", "s", "t" }, desc = "Down" },
  ["<M-k>"] = { "<up>", { "i", "c", "s", "t" }, desc = "Up" },
  ["<M-h>"] = { "<left>", { "i", "c", "s", "t" }, desc = "Left" },
  ["<M-l>"] = { "<right>", { "i", "c", "s", "t" }, desc = "Right" },
  ["<M-g><M-j>"] = { "<C-g><C-j>", "i", desc = "Down[insert start column]" },
  ["<M-g><M-k>"] = { "<C-g><C-k>", "i", desc = "Up[insert start column]" },
  ["<M-S-h>"] = { "<left><left><left>", { "t", "c", "i", "s" } },
  ["<M-S-j>"] = { "<down><down><down>", { "t", "i", "c", "s" } },
  ["<M-S-k>"] = { "<up><up><up>", { "t", "i", "c", "s" } },
  ["<M-S-l>"] = { "<right><right><right>", { "t", "c", "i", "s" } },
  ["<M-space><M-m>"] = { { "<C-o>gM", "i" }, { c_mode_middle, "c" }, desc = "Line Middle" },
  ["<M-space><M-n>"] = { "<C-o>gM", "i" },
  ["<M-space>j"] = { "<C-o>L", "i" },
  ["<M-space>k"] = { "<C-o>H", "i" },
  ["<M-space>m"] = { "<C-o>gm", "i" },
  ["<M-space>n"] = { "<C-o>M", "i" },
  ["<M-space><M-k>"] = { "<up><end>", "i" },
  ["<M-space><M-j>"] = { { "<down><end>", "i" } },
  ["<M-space><M-space><M-k>"] = { "<up><home>", { "i" } },
  ["<M-space><M-space><M-j>"] = { "<down><home>", { "i" } },
  ["<space>m"] = { "gM", { "n", "x", "o" } },
  ["<space>n"] = { "M", { "n", "x", "o" } },
  ["<space>k"] = { "{", { "n", "x", "o" } },
  ["<space>j"] = { "}", { "n", "x", "o" } },
  ["<space>h"] = {
    {
      function()
        require("builtin.start-end-move").first_non_blank_character()
      end,
      "n",
    },
    { "^", "x" },
    {
      "^",
      -- function()
      --   if my.cursor.is_word_end() then
      --     return "v^"
      --   end
      --   return "^"
      -- end,
      "o",
      -- expr = true,
    },
    desc = "Move to the first non-blank character of the line",
  },
  ["<space>l"] = {
    {
      function()
        my.motion.line_last_non_blank()
      end,
      "n",
    },
    { "g_", "x" },
    {
      "g_",
      -- function()
      --   if my.cursor.is_word_end() then
      --     return "<cmd>normal! lvg_<cr>"
      --   end
      --   return "g_"
      -- end,
      "o",
      -- expr = true,
    },
    desc = "Move to the last non-blank character of the line",
  },
  ["<space><M-h>"] = { "I", "n" },
  ["<space><M-l>"] = { "A", "n" },
  ["<M-space><M-h>"] = {
    {
      function()
        -- vim.keymap.set("n", "<F1000>", function()
        --   --- like native: insert mode motion auto follow
        --   vim.bo.follow = true
        --   my.motion.line_last_non_blank()
        --   vim.bo.follow = false
        -- end)
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<F1000>", true, false, true), "mt", false)
        vim.api.nvim_feedkeys("i", "nt", false)
      end,
      "i",
    },
    { "<C-G>^<C-G>", "s" },
    -- { "<Home><C-right>", "t" },
    {
      function()
        require("builtin.cmdline").first_non_blank_character()
      end,
      "c",
    },
    desc = "Move to the first non-blank character",
  },
  ["<M-space><M-l>"] = {
    {
      function()
        --- 创建临时 keymap 使其进入 feedkeys 流: <esc><F1000>a,
        --- CmdAtom 删除临时 keymap
        vim.keymap.set("n", "<F1000>", function()
          --- like native: insert mode motion auto follow
          vim.bo.follow = true
          my.motion.line_last_non_blank()
          vim.bo.follow = false
        end)
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<F1000>", true, false, true), "mt", false)
        vim.api.nvim_feedkeys("a", "nt", false)

        vim.api.nvim_create_autocmd("CmdAtom", {
          callback = function(ev)
            if ev.data.lhs == "<F1000>" then
              vim.keymap.del("n", "<F1000>")
              return true
            end
          end,
        })
      end,
      "i",
    },
    { "<C-G>g_<C-G>", "s" },
    {
      function()
        require("builtin.cmdline").last_non_blank_character()
      end,
      "c",
    },
    desc = "Move to the last non-blank character",
  },
  ["<space><space>h"] = {
    {
      function()
        require("builtin.start-end-move").first_character()
      end,
      "n",
    },
    { "0", "x" },
    {
      "0",
      -- function()
      --   if my.cursor.is_word_end() then
      --     return "v0"
      --   end
      --   return "0"
      -- end,
      "o",
      -- expr = true,
    },
    desc = "Move to the first character of the line",
  },
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
  ["<space><space>l"] = {
    { "<End>", "n" },
    { "$h", "x" },
    {
      "$",
      -- function()
      --   if my.cursor.is_word_end() then
      --     return "<cmd>normal! lv$h<cr>"
      --   end
      --   return "$"
      -- end,
      "o",
      -- expr = true,
    },
    desc = "Move to the last character of the line",
  },
  ["<M-space><M-space><M-l>"] = { "<End>", { "i", "c", "s", "t" } },
  ["<M-space><M-space><M-h>"] = { "<Home>", { "i", "c", "s", "t" } },
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
  ["<M-a><M-h>"] = { "<C-o>g^", "i", desc = "Screen First Character" },
  ["<M-a><M-l>"] = { "<esc>g<end>a", "i", desc = "Screen Last Character" },
  ["<M-a><M-a><M-h>"] = { "<C-o>g0", "i", desc = "Screen First Character" },
  ["<M-a><M-a><M-l>"] = { "<esc>g$a", "i", desc = "Screen Last Character" },
  ["<M-2><M-l>"] = {
    "<C-o>ze",
    "i",
    desc = "Scroll the text horizontally to position the cursor at the end (right side) of the screen.",
  },
  ["<M-2><M-h>"] = {
    "<C-o>zs",
    "i",
    desc = "Scroll the text horizontally to position the cursor at the start (left side) of the screen.",
  },
  ["<M-2><M-k>"] = {
    "<C-o>zt",
    "i",
    desc = "line [count] at top of window (default cursor line)(leave the cursor in the same column).",
  },
  ["<M-2><M-j>"] = {
    "<C-o>zb",
    "i",
    desc = "line [count] at bottom of window (default cursor line)(leave the cursor in the same column).",
  },
  ["<M-2><M-n>"] = {
    "<C-o>zz",
    "i",
    desc = "line [count] at center of window (default cursor line)(leave the cursor in the same column).",
  },
  ["<M-1><M-j>"] = { "<C-o>L", "i" },
  ["<M-1><M-k>"] = { "<C-o>H", "i" },
  ["<M-1><M-h>"] = { "<C-o>g^", "i" },
  ["<M-1><M-l>"] = { "<esc>g<end>a", "i" },
  ["<M-1><M-1><M-j>"] = { "<C-o>L", "i" },
  ["<M-1><M-1><M-k>"] = { "<C-o>H", "i" },
  ["<M-1><M-1><M-h>"] = { "<C-o>g0", "i" },
  ["<M-1><M-1><M-l>"] = { "<C-o>g$", "i" },
  ["<M-w><M-k>"] = { "<C-o>-", "i" },
  ["<M-e><M-k>"] = { "<Esc>kg_a", "i" },
  ["<M-w><M-j>"] = { "<C-o>+", "i" },
  ["<M-e><M-j>"] = { "<Esc>jg_a", "i" },
  ["<M-w><M-w><M-k>"] = { "<Esc>k0i", "i" },
  ["<M-e><M-e><M-k>"] = { "<Esc>k$a", "i" },
  ["<M-w><M-w><M-j>"] = { "<C-o>j0i", "i" },
  ["<M-e><M-e><M-j>"] = { "<Esc>j$a", "i" },
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

-- vim.keymap.set("n", "<F1000>", function()
--   vim.bo.follow = true
--   local cursor = vim.api.nvim_win_get_cursor(0)
--   local line = vim.api.nvim_get_current_line()
--   local s = line:reverse():find("%S") or 0
--   local col = #line - s
--   if cursor[2] + 1 == #line:sub(1, col + 1) then
--     vim.api.nvim_win_set_cursor(0, { cursor[1], #line })
--   else
--     vim.api.nvim_win_set_cursor(0, { cursor[1], col })
--   end
--   vim.bo.follow = false
-- end)
--
-- vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
-- vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<F1000>", true, false, true), "mt", false)
-- vim.api.nvim_feedkeys("a", "nt", false)
--
-- vim.cmd.stopinsert()
-- vim.schedule(function()
--   local cursor1 = vim.api.nvim_win_get_cursor(0)
--   vim.api.nvim_feedkeys("g_", "nx", false)
--   local cursor2 = vim.api.nvim_win_get_cursor(0)
--   if cursor1[2] == cursor2[2] then
--     vim.api.nvim_feedkeys("$", "nx", false)
--   end
--   vim.api.nvim_feedkeys("a", "n", false)
-- end)
