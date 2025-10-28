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

return {
  ["j"] = { j, { "n", "x", "o" }, expr = true },
  ["k"] = { k, { "n", "x", "o" }, expr = true },
  ["<down>"] = { j, { "n", "x", "o" }, expr = true },
  ["<up>"] = { k, { "n", "x", "o" }, expr = true },
  ["gj"] = { gj, { "n", "x", "o" }, expr = true },
  ["gk"] = { gk, { "n", "x", "o" }, expr = true },
  ["gl"] = { gl, { "n", "x", "o" }, expr = true },
  ["<M-j>"] = { "<down>", { "i", "c", "s", "t" }, desc = "Down" },
  ["<M-k>"] = { "<up>", { "i", "c", "s", "t" }, desc = "Up" },
  ["<M-h>"] = { "<left>", { "i", "c", "s", "t" }, desc = "Left" },
  ["<M-l>"] = { "<right>", { "i", "c", "s", "t" }, desc = "Right" },
  ["<M-g><M-j>"] = { "<C-g><C-j>", "i", desc = "Down[insert start column]" },
  ["<M-g><M-k>"] = { "<C-g><C-k>", "i", desc = "Up[insert start column]" },
  ["<space>D"] = { "xd^", "n", noremap = true },
  ["<space>m"] = { "gM", { "n", "x", "o" } },
  ["<space>n"] = { "M", { "n", "x", "o" } },
  ["<M-space><M-m>"] = { "<C-o>gM", { "i" } },
  ["<M-space><M-n>"] = { "<C-o>gM", { "i" } },
  ["<space>G"] = { "<C-End>", { "n", "x", "o" } },
  ["<space><space>G"] = { "G0", { "n", "x", "o" } },
  ["<M-w><M-k>"] = { "<C-o>-", "i" },
  ["<M-e><M-k>"] = { "<Esc>kg_a", "i" },
  ["<M-w><M-j>"] = { "<C-o>+", "i" },
  ["<M-e><M-j>"] = { "<Esc>jg_a", "i" },
  ["<M-S-h>"] = {
    { "<C-o>3h", "i" },
    { "<left><left><left><left><left>", "t" },
  },
  ["<M-S-j>"] = {
    { "<C-o>3j", "i" },
    { "<down><down><down><down><down>", "t" },
  },
  ["<M-S-k>"] = {
    { "<C-o>3k", "i" },
    { "<up><up><up><up><up>", "t" },
  },
  ["<M-S-l>"] = {
    { "<C-o>3l", { "i" } },
    { "<right><right><right><right><right>", "t" },
  },
  ["<M-1><M-h>"] = { "<C-o>g0", "i" },
  ["<M-space>h"] = { "<C-o>g0", "i" },
  ["<M-1><M-l>"] = { "<C-o>g$", "i" },
  ["<M-space>l"] = { "<C-o>g$", "i" },
  ["<M-1><M-j>"] = { "<C-o>L", "i" },
  ["<M-space>j"] = { "<C-o>L", "i" },
  ["<M-1><M-k>"] = { "<C-o>H", "i" },
  ["<M-space>k"] = { "<C-o>H", "i" },
  ["<M-1><M-m>"] = { "<C-o>gm", "i" },
  ["<M-space>m"] = { "<C-o>gm", "i" },
  ["<M-1><M-n>"] = { "<C-o>M", "i" },
  ["<M-space>n"] = { "<C-o>M", "i" },
  ["<M-space><M-k>"] = { "<Up><End>", "i" },
  ["<M-space><M-j>"] = { { "<Down><End>", "i" } },
  ["<M-space><M-space><M-l>"] = { "<End>", { "i", "c", "s", "t" } },
  ["<M-space><M-space><M-h>"] = { "<Home>", { "i", "c", "s", "t" } },
  ["<M-space><M-space><M-k>"] = { "<Up><Home>", { "i" } },
  ["<M-space><M-space><M-j>"] = { "<Down><Home>", { "i" } },

  ["0m"] = {
    function()
      require("custom.plugins.move.magic-move").move()
    end,
    "n",
  },
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
    { "<Home>", "t" },
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
    { "<end>", "t" },
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
    desc = "Screen First Non Blank Character",
  },
  ["al"] = {
    function()
      require("builtin.screen-move").last_non_blank_character()
    end,
    { "n", "x", "o" },
    desc = "Screen Last Non Blank Character",
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
  ["H"] = {
    {
      function()
        require("builtin.screen-move").first_character()
      end,
      { "n", "x" },
    },
    { "g0", "o" },
    desc = "Screen First Character",
  },
  ["L"] = {
    {
      function()
        require("builtin.screen-move").last_character()
      end,
      { "n", "x" },
    },
    { "g$", "o" },
    desc = "Screen Last Character",
  },
  ["K"] = {
    {
      function()
        require("builtin.screen-move").top()
      end,
      { "n", "x", "o" },
    },
    desc = "Screen Top",
  },
  ["J"] = {
    {
      function()
        require("builtin.screen-move").bottom()
      end,
      { "n", "x", "o" },
    },
    { "L", "o" },
    desc = "Screen Bottom",
  },
  ["N"] = {
    "M",
    { "n", "x", "o" },
    desc = "To Middle line of window, on the first non-blank character (linewise)",
  },
  ["M"] = {
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
  ["<S-space>H"] = {
    function()
      local virt_col = vim.fn.virtcol(".")
      local line = vim.api.nvim_get_current_line()
      local display_width = vim.fn.strdisplaywidth(line)
      if virt_col <= display_width then
        return "zs"
      else
        local wininfo = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
        ---@diagnostic disable-next-line: undefined-field
        local leftcol = wininfo.leftcol
        if virt_col - leftcol > 1 then
          return (virt_col - leftcol - 1) .. "zl"
        end
      end
    end,
    { "n", "x" },
    expr = true,
    desc = "Scroll the text horizontally to position the cursor at the start (left side) of the screen.",
  },
  ["<S-space>L"] = {
    function()
      local virt_col = vim.fn.virtcol(".")
      local line = vim.api.nvim_get_current_line()
      local display_width = vim.fn.strdisplaywidth(line)
      if virt_col <= display_width then
        return "ze"
      else
        local wininfo = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
        local width = wininfo.width - wininfo.textoff
        ---@diagnostic disable-next-line: undefined-field
        local leftcol = wininfo.leftcol
        local win_virt_col = virt_col - leftcol
        local count = width - win_virt_col
        if count > 0 then
          return count .. "zh"
        end
      end
    end,
    { "n", "x" },
    expr = true,
    desc = "Scroll the text horizontally to position the cursor at the end (right side) of the screen.",
  },
  ["<S-space>K"] = {
    "zt",
    { "n", "x" },
    desc = "line [count] at top of window (default cursor line)(leave the cursor in the same column).",
  },
  ["<S-space>J"] = {
    "zb",
    { "n", "x" },
    desc = "line [count] at bottom of window (default cursor line)(leave the cursor in the same column).",
  },
  ["<S-space>N"] = {
    "zz",
    { "n", "x" },
    desc = "line [count] at center of window (default cursor line)(leave the cursor in the same column).",
  },
  ["<S-space>M"] = {
    function()
      local win_info = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
      local screen_width = win_info.width - win_info.textoff
      ---@diagnostic disable-next-line: undefined-field
      local leftcol = win_info.leftcol
      local screent_cursor_rol = vim.fn.virtcol(".") - leftcol
      local offset = math.ceil(screen_width / 2) - screent_cursor_rol + 1

      if offset > 0 then
        vim.api.nvim_feedkeys(offset .. "zh", "n", false)
      elseif offset < 0 then
        vim.api.nvim_feedkeys(-offset .. "zl", "n", false)
      end
    end,
    { "n" },
    desc = "col at center of window",
  },
}
