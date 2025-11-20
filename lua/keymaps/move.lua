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

local function switch_virtualedit()
  ---@diagnostic disable-next-line: undefined-field
  local virt = vim.opt_local.virtualedit:get()[1]
  if virt == "all" then
    vim.opt_local.virtualedit = "none"
  else
    vim.opt_local.virtualedit = "all"
  end
end

local j = function()
  return vim.v.count == 0 and "gj" or "j"
end

local k = function()
  return vim.v.count == 0 and "gk" or "k"
end

local gj = function()
  switch_virtualedit()
  return vim.v.count == 0 and "gj" or "j"
end

local gk = function()
  switch_virtualedit()
  return vim.v.count == 0 and "gk" or "k"
end

local gl = function()
  switch_virtualedit()
  return "l"
end

local gh = function()
  switch_virtualedit()
  return "h"
end

local c_mode_middle = function()
  require("builtin.cmdline").middle()
end

local H = function()
  vim.api.nvim_feedkeys(vim.v.count1 * 3 .. "h", "n", false)
end

local L = function()
  vim.api.nvim_feedkeys(vim.v.count1 * 3 .. "l", "n", false)
end

local J = function()
  vim.api.nvim_feedkeys(vim.v.count1 * 3 .. "j", "n", false)
end

local K = function()
  vim.api.nvim_feedkeys(vim.v.count1 * 3 .. "k", "n", false)
end

return {
  ["j"] = { j, { "n", "x", "o" }, expr = true },
  ["k"] = { k, { "n", "x", "o" }, expr = true },
  ["<down>"] = { j, { "n", "x", "o" }, expr = true },
  ["<up>"] = { k, { "n", "x", "o" }, expr = true },
  ["gj"] = { gj, { "n", "x", "o" }, expr = true },
  ["gk"] = { gk, { "n", "x", "o" }, expr = true },
  ["gl"] = { gl, { "n", "x", "o" }, expr = true },
  ["gh"] = { gl, { "n", "x", "o" }, expr = true },
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
  ["<M-S-h>"] = { "<left><left><left>", { "t", "c", "i" } },
  ["<M-S-j>"] = { "<down><down><down>", { "t", "i", "c" } },
  ["<M-S-k>"] = { "<up><up><up>", { "t", "i", "c" } },
  ["<M-S-l>"] = { "<right><right><right>", { "t", "c", "i" } },
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
  ["<space>h"] = {
    {
      function()
        require("builtin.start-end-move").first_non_blank_character()
      end,
      "n",
    },
    { "^", "x" },
    --- contains the character under the cursor
    { "v^", "o" },
    desc = "Move to the first non-blank character of the line",
  },
  ["<space>l"] = {
    {
      function()
        require("builtin.start-end-move").last_non_blank_character()
      end,
      "n",
    },
    { "g_", { "x", "o" } },
    desc = "Move to the last non-blank character of the line",
  },
  ["<space><M-h>"] = { "I", "n" },
  ["<space><M-l>"] = { "A", "n" },
  ["<M-space><M-h>"] = {
    {
      function()
        vim.cmd.stopinsert()
        vim.schedule(function()
          local cursor1 = vim.api.nvim_win_get_cursor(0)
          vim.api.nvim_feedkeys("^", "nx", false)
          local cursor2 = vim.api.nvim_win_get_cursor(0)
          if cursor1[2] + 1 == cursor2[2] then
            vim.api.nvim_feedkeys("0", "nx", false)
          end
          vim.api.nvim_feedkeys("i", "n", false)
        end)
      end,
      "i",
    },
    { "<C-G>^<C-G>", "s" },
    { "<Home><C-right>", "t" },
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
        vim.cmd.stopinsert()
        vim.schedule(function()
          local cursor1 = vim.api.nvim_win_get_cursor(0)
          vim.api.nvim_feedkeys("g_", "nx", false)
          local cursor2 = vim.api.nvim_win_get_cursor(0)
          if cursor1[2] == cursor2[2] then
            vim.api.nvim_feedkeys("$", "nx", false)
          end
          vim.api.nvim_feedkeys("a", "n", false)
        end)
      end,
      "i",
    },
    { "<C-G>g_<C-G>", "s" },
    {
      function()
        vim.cmd.stopinsert()
        vim.schedule(function()
          local line_count = vim.api.nvim_buf_line_count(0)
          local function run(line_count)
            if line_count == 0 then
              return
            end
            local line = vim.api.nvim_buf_get_lines(0, line_count - 1, line_count, false)[1]
            if #line > 0 then
              return line_count, line
            else
              return run(line_count - 1)
            end
          end
          local count, line = run(line_count)
          if count then
            vim.cmd.startinsert()
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<end>", true, false, true), "n", false)
            vim.schedule(function()
              local offset = #line - #line:gsub("%s*$", "")
              if offset == 0 then
                return
              end
              local key = "<left>"
              key = key:rep(offset)
              vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, false, true), "n", false)
            end)
          end
        end)
      end,
      "t",
    },
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
    --- contains the character under the cursor
    { "v0", "o" },
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
  ["<space><space>l"] = {
    {
      function()
        require("builtin.start-end-move").last_character()
      end,
      "n",
    },
    { "$h", "x" },
    { "$", "o" },
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
  ["<C-9>"] = { "-", { "n", "x", "o" }, desc = "[count] lines upward, on the first non-blank character (linewise)." },
  ["<C-0>"] = {
    "<up>g_",
    { "n", "x", "o" },
    desc = "[count] lines upward, on the last non-blank character (linewise).",
  },
  ["<M-9>"] = { "+", { "n", "x", "o" }, desc = "[count] lines downward, on the first non-blank character (linewise)." },
  ["<M-0>"] = {
    "<down>g_",
    { "n", "x", "o" },
    desc = "[count] lines downward, on the last non-blank character (linewise).",
  },
  ["ah"] = {
    function()
      require("builtin.screen-move").first_non_blank_character()
    end,
    { "n", "x", "o" },
    desc = "Screen First Character",
  },
  ["al"] = {
    function()
      require("builtin.screen-move").last_non_blank_character()
    end,
    { "n", "x", "o" },
    desc = "Screen Last Character",
  },
  ["ak"] = {
    function()
      require("builtin.screen-move").top()
    end,
    { "n", "x", "o" },
    desc = "Screen Top",
  },
  ["aj"] = {
    function()
      require("builtin.screen-move").bottom()
    end,
    { "n", "x", "o" },
    desc = "Screen Bottom",
  },
  ["am"] = {
    function()
      ---@diagnostic disable-next-line: undefined-field
      local virtualedit = vim.opt_local.virtualedit:get()
      if virtualedit[1] ~= "all" then
        return "gM"
      end
      return "gm"
    end,
    { "n", "x", "o" },
    expr = true,
  },
  ["an"] = {
    "M",
    { "n", "x", "o" },
    desc = "To Middle line of window, on the first non-blank character (linewise)",
  },
  ["ac"] = {
    "gmM",
    "n",
  },
  ["aah"] = {
    {
      function()
        require("builtin.screen-move").first_character()
      end,
      { "n", "x" },
    },
    { "g0", "o" },
    desc = "Screen First Character",
  },
  ["aal"] = {
    {
      function()
        require("builtin.screen-move").last_character()
      end,
      { "n", "x" },
    },
    { "g$", "o" },
    desc = "Screen Last Character",
  },
  ["aak"] = {
    function()
      require("builtin.screen-move").top()
    end,
    { "n", "x", "o" },
    desc = "Screen Top",
  },
  ["aaj"] = {
    function()
      require("builtin.screen-move").bottom()
    end,
    { "n", "x", "o" },
    desc = "Screen Bottom",
  },
  ["sh"] = {
    function()
      require("builtin.scroll-cursor").scroll_left()
    end,
    { "n", "x" },
    expr = true,
    desc = "Scroll the text horizontally to position the cursor at the start (left side) of the screen.",
  },
  ["sl"] = {
    function()
      require("builtin.scroll-cursor").scroll_right()
    end,
    { "n", "x" },
    expr = true,
    desc = "Scroll the text horizontally to position the cursor at the end (right side) of the screen.",
  },
  ["sk"] = {
    "zt",
    { "n", "x" },
    desc = "line [count] at top of window (default cursor line)(leave the cursor in the same column).",
  },
  ["sj"] = {
    "zb",
    { "n", "x" },
    desc = "line [count] at bottom of window (default cursor line)(leave the cursor in the same column).",
  },
  ["sn"] = {
    "zz",
    { "n", "x" },
    desc = "line [count] at center of window (default cursor line)(leave the cursor in the same column).",
  },
  -- TODO: Fix virtualedit=none
  ["sm"] = {
    function()
      return require("builtin.scroll-cursor").scroll_row_center()
    end,
    { "n" },
    expr = true,
    desc = "col at center of window",
  },
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
}

-- ["H"] = {
--   {
--     function()
--       require("builtin.screen-move").first_character()
--     end,
--     { "n", "x" },
--   },
--   { "g0", "o" },
--   desc = "Screen First Character",
-- },
-- ["L"] = {
--   {
--     function()
--       require("builtin.screen-move").last_character()
--     end,
--     { "n", "x" },
--   },
--   { "g$", "o" },
--   desc = "Screen Last Character",
-- },
-- ["K"] = {
--   {
--     function()
--       require("builtin.screen-move").top()
--     end,
--     { "n", "x", "o" },
--   },
--   desc = "Screen Top",
-- },
-- ["J"] = {
--   {
--     function()
--       require("builtin.screen-move").bottom()
--     end,
--     { "n", "x", "o" },
--   },
--   { "L", "o" },
--   desc = "Screen Bottom",
-- },
-- ["N"] = {
--   "M",
--   { "n", "x", "o" },
--   desc = "To Middle line of window, on the first non-blank character (linewise)",
-- },
-- ["M"] = {
--   function()
--     ---@diagnostic disable-next-line: undefined-field
--     local virtualedit = vim.opt_local.virtualedit:get()
--     if virtualedit[1] ~= "all" then
--       return "gM"
--     end
--     return "gm"
--   end,
--   { "n", "x", "o" },
--   expr = true,
-- },
-- ["0m"] = {
--   function()
--     require("custom.plugins.move.magic-move").move()
--   end,
--   "n",
-- },
