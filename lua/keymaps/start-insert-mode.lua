local first_non_blank_character = {
  {
    function()
      return require("builtin.start-insert-mode.normal-mode").first_non_blank_character()
    end,
    "n",
    desc = "Start insert mode to the left of the first non-blank character in the current line",
    expr = true,
  },
  {
    function(context)
      require("builtin.start-insert-mode.visual-mode").first_non_black_character(function()
        if type(context.after) == "function" then
          context.after()
        end
      end)
    end,
    { "x", "s" },
    after = true,
    context = true,
    desc = "Start insert mode to the left of the first non-blank character in the visual area",
  },
}

local last_non_blank_character = {
  {
    function()
      return require("builtin.start-insert-mode.normal-mode").last_non_blank_character()
    end,
    "n",
    desc = "Start insert mode to the right of the last non-blank character in the current line",
    expr = true,
  },
  {
    function(context)
      require("builtin.start-insert-mode.visual-mode").last_non_black_character(function()
        if type(context.after) == "function" then
          context.after()
        end
      end)
    end,
    { "x", "s" },
    after = true,
    context = true,
    desc = "Start insert mode to the right of the last non-blank character in the visual area",
  },
}

return {
  ["w"] = {
    "i",
    "n",
    desc = "Cursor left start insert mode",
  },
  ["e"] = {
    "a",
    "n",
    desc = "Cursor right start in  sert mode",
  },
  ["W"] = first_non_blank_character,
  ["E"] = last_non_blank_character,
  ["<space>w"] = first_non_blank_character,
  ["<space>e"] = last_non_blank_character,
  ["<space><space>w"] = {
    {
      "gI",
      "n",
      desc = "Start insert mode to the left of the first character in the current line",
    },
    {
      function()
        require("builtin.start-insert-mode.visual-mode").first_character()
      end,
      { "x", "s" },
      desc = "Start insert mode to the left of the first character in the visual area",
    },
  },
  ["<space><space>e"] = {
    {
      function()
        return require("builtin.start-insert-mode.normal-mode").last_character()
      end,
      "n",
      desc = "Start insert mode to the right of the last character in the current line",
      expr = true,
    },
    {
      function()
        require("builtin.start-insert-mode.visual-mode").last_character()
      end,
      desc = "Start insert mode to the right of the last character in the visual area",
      { "x", "s" },
    },
  },
  ["<space>W"] = {
    function()
      local count = vim.v.count1
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, false, true), "nx", true)
      local start_row = unpack(vim.api.nvim_buf_get_mark(0, "<"))
      return start_row .. "G" .. count .. "I"
    end,
    "x",
    expr = true,
  },
  ["<space>E"] = {
    function()
      local count = vim.v.count1
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, true, true), "nx", true)
      local end_row, end_col = unpack(vim.api.nvim_buf_get_mark(0, ">"))
      vim.api.nvim_win_set_cursor(0, { end_row, end_col })
      vim.api.nvim_feedkeys(count .. "A", "n", false)
    end,
    "x",
  },
  -- ["<space><space>W"] = {
  --   function()
  --     local count = vim.v.count1
  --     return "<esc>" .. count .. "gI"
  --   end,
  --   "x",
  --   expr = true,
  -- },
  -- ["<space><space>E"] = {
  --   function()
  --     local count = vim.v.count1
  --     return "<esc>$" .. count .. "a"
  --   end,
  --   "x",
  --   expr = true,
  -- },
  -- screen line
  -- ["<S-space>W"] = {
  --   function()
  --     local count = vim.v.count1
  --     return "g^" .. count .. "i"
  --   end,
  --   "n",
  --   desc = "Start insert mode to the left of the first non-blank character in the screen line",
  --   expr = true,
  -- },
  -- ["<S-space>E"] = {
  --   function()
  --     local count = vim.v.count1
  --     ---@diagnostic disable-next-line: undefined-field
  --     if vim.opt.virtualedit:get()[1] == "all" then
  --       vim.opt.virtualedit = "none"
  --       vim.api.nvim_feedkeys("g" .. vim.api.nvim_replace_termcodes("<end>", true, false, true), "nx", true)
  --       vim.opt.virtualedit = "all"
  --       vim.api.nvim_feedkeys(count .. "a", "n", true)
  --       return
  --     end
  --     vim.api.nvim_feedkeys(
  --       "g" .. vim.api.nvim_replace_termcodes("<end>", true, false, true) .. count .. "a",
  --       "n",
  --       true
  --     )
  --   end,
  --   "n",
  --   desc = "Start insert mode to the right of the last non-blank character in the screen line",
  -- },
  -- ["<S-space><S-space>W"] = {
  --   function()
  --     local count = vim.v.count1
  --     return "g0" .. count .. "i"
  --   end,
  --   "n",
  --   expr = true,
  --   desc = "Start insert mode to the left of the first character in the screen line",
  -- },
  -- ["<S-space><S-space>E"] = {
  --   function()
  --     local count = vim.v.count1
  --     return "<esc>g$" .. count .. "a"
  --   end,
  --   "n",
  --   expr = true,
  --   desc = "Start insert mode to the right of the last character in the screen line",
  -- },
  -- normal mode into insert mode ea
  ["<space><M-i>"] = {
    { "gea", "n", desc = "Start insert mode at previous word end" },
  },
  -- normal mode into insert mode Ea
  ["<space><M-S-i>"] = {
    { "gEa", "n", desc = "Start insert mode at previous WORD end" },
  },
  -- normal mode into insert mode: wi
  ["<space><M-o>"] = {
    { "wi", "n", desc = "Start insert mode at next word start" },
  },
  -- normal mode into insert mode: Wi
  ["<space><M-S-o>"] = {
    { "Wi", "n", desc = "Start insert mode at next WORD start" },
  },
  -- normal mode into insert mode: ei
  ["<M-o>"] = {
    { "<Esc>ea", "i", desc = "Move to the current word or next word end" },
    { "ea", "n", desc = "Start insert mode at the current word or next word end" },
    { "<C-right>", "t", desc = "Move to the current word or next word end" },
  },
  -- normal mode into insert mode: Ei
  ["<M-S-o>"] = {
    { "<Esc>Ea", "i", desc = "Move to the current WORD or next WORD end" },
    { "Ea", "n", desc = "Start insert mode at the current WORD or next WORD end" },
  },
  -- normal mode into insert mode: bi
  ["<M-i>"] = {
    { "<Esc>bi", "i", desc = "Move to the current word or previous word start" },
    { "bi", "n", desc = "Start insert mode at the current word or previous word start" },
    { "<C-left>", "t", desc = "Move to the current word or previous word start" },
  },
  ["<M-S-i>"] = {
    { "<Esc>Bi", "i", desc = "Move to the current WORD or previous WORD start" },
    { "Bi", "n", desc = "Start insert mode at the current WORD or previous WORD start" },
  },
  ["<M-C-o>"] = {
    { "<C-o>w", "i", desc = "Move to the next word start" },
    { "wi", "n", desc = "Start insert mode at the next word start" },
  },
  ["<M-C-i>"] = {
    { "<Esc>gea", "i", desc = "Move to the previous word end" },
    { "gea", "n", desc = "Start insert mode at the previous word end" },
  },
  ["<M-C-S-i>"] = {
    { "<Esc>gEa", "i", desc = "Move to the previous WORD end" },
    { "gEa", "n", desc = "Start insert mode at the previous WORD end" },
  },
  ["<M-C-S-o>"] = {
    { "<C-o>W", "i", desc = "Move to the next WORD start" },
    { "Wi", "n", desc = "Start insert mode at the next WORD start" },
  },
  ["aw"] = {
    function()
      local count = vim.v.count1
      -- <Esc> used to clear count(虽然 g0 不支持计数)
      return "<esc>g0" .. count .. "i"
    end,
    "n",
    desc = "Start insert mode to the far left character of the screen window",
    expr = true,
  },
  ["ae"] = {
    function()
      local count = vim.v.count1
      -- <Esc> used to clear count
      return "<esc>g$" .. count .. "a"
    end,
    "n",
    desc = "Start insert mode to the far right character of the screen window",
    expr = true,
  },
  ["gw"] = {
    "gi",
    "n",
    desc = "Insert text in the same position as where Insert mode was stopped last time in the current buffer.",
  },
  ["ge"] = {
    "gi",
    "n",
    desc = "Insert text in the same position as where Insert mode was stopped last time in the current buffer.",
  },
}
