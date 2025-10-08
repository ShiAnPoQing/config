local function first_non_blank_line_start_insert_mode()
  local line = vim.api.nvim_get_current_line()
  local key
  if #line == 0 then
    key = "I<C-f>"
  else
    key = "I"
  end
  return key
end

local function last_non_blank_line_start_insert_mode()
  local line = vim.api.nvim_get_current_line()
  local key
  local count = vim.v.count1
  if #line == 0 then
    key = "<Esc>g_" .. count .. "a<C-f>"
  else
    key = "<Esc>g_" .. count .. "a"
  end
  return key
end

local function last_line_start_insert_mode()
  local line = vim.api.nvim_get_current_line()
  local key
  if #line == 0 then
    key = "A<C-f>"
  else
    key = "A"
  end
  return key
end

local function visual_first_non_blank_start_insert_mode()
  local count = vim.v.count1
  local mode = vim.api.nvim_get_mode().mode

  if mode == "V" or mode == "v" or mode == "s" or mode == "S" then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, true, true), "nx", true)
    local start_row, start_col = unpack(vim.api.nvim_buf_get_mark(0, "<"))
    local end_row, end_col = unpack(vim.api.nvim_buf_get_mark(0, ">"))
    local text = vim.api.nvim_buf_get_text(0, start_row - 1, start_col, end_row - 1, end_col + 1, {})
    local first_text = text[1]
    local sc = first_text:find("%S") - 1
    vim.api.nvim_win_set_cursor(0, { start_row, sc + start_col })
    vim.api.nvim_feedkeys(count .. "i", "n", false)
    return
  end

  if mode == "" then
    vim.api.nvim_feedkeys(count .. "I", "n", false)
    return
  end

  if mode == "" then
    local ctrl_g = vim.api.nvim_replace_termcodes("<C-g>", true, true, true)
    vim.api.nvim_feedkeys(ctrl_g .. count .. "I", "n", false)
    return
  end
end

local function visual_last_non_blank_start_insert_mode()
  local count = vim.v.count1
  local mode = vim.api.nvim_get_mode().mode

  if mode == "v" or mode == "V" or mode == "s" or mode == "S" then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, true, true), "nx", true)
    local start_row, start_col = unpack(vim.api.nvim_buf_get_mark(0, "<"))
    local end_row, end_col = unpack(vim.api.nvim_buf_get_mark(0, ">"))
    local text = vim.api.nvim_buf_get_text(0, start_row - 1, start_col, end_row - 1, end_col + 1, {})
    local last_text = text[#text]
    local sc = last_text:reverse():find("%S") - 1
    vim.api.nvim_win_set_cursor(0, { end_row, end_col - sc })
    vim.api.nvim_feedkeys(count .. "a", "n", false)
  end

  if mode == "" then
    vim.api.nvim_feedkeys(count .. "A", "n", false)
    return
  end

  if mode == "" then
    local ctrl_g = vim.api.nvim_replace_termcodes("<C-g>", true, true, true)
    vim.api.nvim_feedkeys(ctrl_g .. count .. "A", "n", false)
  end
end

local function visual_first_character_start_insert_mode()
  local count = vim.v.count1
  local mode = vim.api.nvim_get_mode().mode

  if mode == "V" or mode == "v" or mode == "s" or mode == "S" then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, true, true), "nx", true)
    local start_row, start_col = unpack(vim.api.nvim_buf_get_mark(0, "<"))
    vim.api.nvim_win_set_cursor(0, { start_row, start_col })
    vim.api.nvim_feedkeys(count .. "i", "n", false)
    return
  end

  if mode == "" then
    vim.api.nvim_feedkeys(count .. "I", "n", false)
    return
  end

  if mode == "" then
    local ctrl_g = vim.api.nvim_replace_termcodes("<C-g>", true, true, true)
    vim.api.nvim_feedkeys(ctrl_g .. count .. "I", "n", false)
    return
  end
end

local function visual_last_character_start_insert_mode()
  local count = vim.v.count1
  local mode = vim.api.nvim_get_mode().mode

  if mode == "v" or mode == "V" or mode == "s" or mode == "S" then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, true, true), "nx", true)
    local end_row, end_col = unpack(vim.api.nvim_buf_get_mark(0, ">"))
    vim.api.nvim_win_set_cursor(0, { end_row, end_col })
    vim.api.nvim_feedkeys(count .. "a", "n", false)
    return
  end

  if mode == "" then
    vim.api.nvim_feedkeys(count .. "A", "n", false)
    return
  end

  if mode == "" then
    local ctrl_g = vim.api.nvim_replace_termcodes("<C-g>", true, true, true)
    vim.api.nvim_feedkeys(ctrl_g .. count .. "A", "n", false)
    return
  end
end

return {
  ["w"] = {
    "i",
    "n",
    desc = "Cursor left start insert mode",
  },
  ["e"] = {
    "a",
    "n",
    desc = "Cursor right start insert mode",
  },
  ["W"] = {
    {
      function()
        return "I"
      end,
      "n",
    },
    {
      function()
        local count = vim.v.count1
        return "<Esc>" .. count .. "I"
      end,
      "x",
    },
    desc = "Start enter insert mode",
    expr = true,
  },
  ["E"] = {
    {
      function()
        return "A"
      end,
      "n",
    },
    {
      function()
        local count = vim.v.count1
        return "<esc>" .. count .. "A"
      end,
      "x",
    },
    desc = "End enter insert mode",
    expr = true,
  },
  ["<space>w"] = {
    {
      first_non_blank_line_start_insert_mode,
      "n",
      desc = "Start insert mode to the left of the first non-blank character in the current line",
      expr = true,
    },
    {
      function()
        visual_first_non_blank_start_insert_mode()
      end,
      { "x", "s" },
    },
  },
  ["<space>e"] = {
    {
      last_non_blank_line_start_insert_mode,
      "n",
      desc = "Start insert mode to the right of the last non-blank character in the current line",
      expr = true,
    },
    {
      function()
        visual_last_non_blank_start_insert_mode()
      end,
      { "x", "s" },
    },
  },
  ["<space><space>w"] = {
    {
      "gI",
      "n",
      desc = "Start insert mode to the left of the first character in the current line",
    },
    {
      function()
        visual_first_character_start_insert_mode()
      end,
      { "x", "s" },
    },
  },
  ["<space><space>e"] = {
    {
      last_line_start_insert_mode,
      "n",
      desc = "Start insert mode to the right of the last character in the current line",
      expr = true,
    },
    {
      function()
        visual_last_character_start_insert_mode()
      end,
      { "x", "s" },
    },
  },
  ["<space>W"] = {
    function()
      local count = vim.v.count1
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, false, true), "nx", true)
      local start_row, start_col = unpack(vim.api.nvim_buf_get_mark(0, "<"))
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
  ["<S-space>w"] = {
    function()
      local count = vim.v.count1
      return "g^" .. count .. "i"
    end,
    "n",
    desc = "Start insert mode to the left of the first non-blank character in the screen line",
    expr = true,
  },
  ["<S-space>e"] = {
    function()
      local count = vim.v.count1
      if vim.opt.virtualedit:get()[1] == "all" then
        vim.opt.virtualedit = "none"
        vim.api.nvim_feedkeys("g" .. vim.api.nvim_replace_termcodes("<end>", true, false, true), "nx", true)
        vim.opt.virtualedit = "all"
        vim.api.nvim_feedkeys(count .. "a", "n", true)
        return
      end
      vim.api.nvim_feedkeys(
        "g" .. vim.api.nvim_replace_termcodes("<end>", true, false, true) .. count .. "a",
        "n",
        true
      )
    end,
    "n",
    desc = "Start insert mode to the right of the last non-blank character in the screen line",
  },
  ["<S-space><S-space>w"] = {
    function()
      local count = vim.v.count1
      return "g0" .. count .. "i"
    end,
    "n",
    expr = true,
    desc = "Start insert mode to the left of the first character in the screen line",
  },
  ["<S-space><S-space>e"] = {
    function()
      local count = vim.v.count1
      return "<esc>g$" .. count .. "a"
    end,
    "n",
    expr = true,
    desc = "Start insert mode to the right of the last character in the screen line",
  },
  -- normal mode into insert mode ea
  ["<space><M-i>"] = {
    { "gea", { "n" } },
  },
  -- normal mode into insert mode Ea
  ["<space><M-S-i>"] = {
    { "gEa", { "n" } },
  },
  -- normal mode into insert mode: wi
  ["<space><M-o>"] = {
    { "wi", { "n" } },
  },
  -- normal mode into insert mode: Wi
  ["<space><M-S-o>"] = {
    { "Wi", { "n" } },
  },
  -- normal mode into insert mode: ei
  ["<M-o>"] = {
    { "<Esc>ea", "i" },
    { "ea", "n" },
    { "<C-right>", "t" },
  },
  -- normal mode into insert mode: Ei
  ["<M-S-o>"] = {
    { "<Esc>Ea", "i" },
    { "Ea", "n" },
  },
  -- normal mode into insert mode: bi
  ["<M-i>"] = {
    { "<Esc>bi", { "i" } },
    { "bi", { "n" } },
    { "<C-left>", "t" },
  },
  ["<M-S-i>"] = {
    { "<Esc>Bi", { "i" } },
    { "Bi", { "n" } },
  },
  ["<M-C-o>"] = {
    { "<C-o>w", "i" },
    { "wi", "n" },
  },
  ["<M-C-i>"] = {
    { "<Esc>gea", "i" },
    { "gea", "n" },
  },
  ["<M-C-S-i>"] = {
    { "<Esc>gEa", "i" },
    { "gEa", "n" },
  },
  ["<M-C-S-o>"] = {
    { "<C-o>W", "i" },
    { "Wi", "n" },
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
