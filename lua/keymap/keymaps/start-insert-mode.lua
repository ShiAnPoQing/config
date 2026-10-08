return {
  -- ["w"] = { "i", "n", desc = "Cursor left insert" },
  -- ["e"] = { "a", "n", desc = "Cursor right insert" },
  -- ["<space>w"] = {
  --   "<cmd>lua my.insert.first_non_blank()<cr>",
  --   { "n", "x" },
  --   desc = "Insert text before the first non-blank character [count]",
  -- },
  -- ["<space>e"] = {
  --   "<cmd>lua my.insert.last_non_blank()<cr>",
  --   { "n", "x" },
  --   desc = "Insert text after the last non-blank character [count]",
  -- },
  -- ["<space><space>w"] = {
  --   "<cmd>lua my.insert.first()<CR>",
  --   { "n", "x" },
  --   desc = "Insert text before the first character [count]",
  -- },
  -- ["<space><space>e"] = {
  --   "<cmd>lua my.insert.last()<CR>",
  --   { "n", "x" },
  --   desc = "Insert text after the last character [count]",
  -- },
  -- ["W"] = {
  --   "<cmd>lua my.insert.first()<CR>",
  --   { "n", "x" },
  --   desc = "Insert text before the first character [count]",
  -- },
  -- ["E"] = {
  --   "<cmd>lua my.insert.last()<CR>",
  --   { "n", "x" },
  --   desc = "Insert text before the first character [count]",
  -- },

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
  ["<space><space>W"] = {
    function()
      local count = vim.v.count1
      return "<esc>" .. count .. "gI"
    end,
    "x",
    expr = true,
  },
  ["<space><space>E"] = {
    function()
      local count = vim.v.count1
      return "<esc>$" .. count .. "a"
    end,
    "x",
    expr = true,
  },
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
  ["aw"] = {
    function()
      local count = vim.v.count1
      -- <Esc> used to clear count
      return "<esc>g^" .. count .. "i"
    end,
    "n",
    expr = true,
    desc = "insert: screen first non-blank character",
  },
  ["ae"] = {
    function()
      local count = vim.v.count1
      -- <Esc> used to clear count
      return "<esc>g<end>" .. count .. "a"
    end,
    "n",
    expr = true,
    desc = "insert: screen last non-blank character",
  },
  ["aaw"] = {
    function()
      local count = vim.v.count1
      -- <Esc> used to clear count(虽然 g0 不支持计数)
      return "<esc>g0" .. count .. "i"
    end,
    "n",
    expr = true,
    desc = "insert: screen first character",
  },
  ["aae"] = {
    function()
      local count = vim.v.count1
      -- <Esc> used to clear count
      return "<esc>g$" .. count .. "a"
    end,
    "n",
    expr = true,
    desc = "insert: screen last character",
  },
  ["aW"] = {
    function()
      local count = vim.v.count1
      -- <Esc> used to clear count(虽然 g0 不支持计数)
      return "<esc>g0" .. count .. "i"
    end,
    "n",
    expr = true,
    desc = "insert: screen first character",
  },
  ["aE"] = {
    function()
      local count = vim.v.count1
      -- <Esc> used to clear count
      return "<esc>g$" .. count .. "a"
    end,
    "n",
    expr = true,
    desc = "insert: screen last character",
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
