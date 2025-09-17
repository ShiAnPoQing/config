local function first_non_blank_line_start_insert_mode()
  local count = vim.v.count1
  local line = vim.api.nvim_get_current_line()
  if #line == 0 then
    vim.api.nvim_feedkeys(count .. "I" .. vim.api.nvim_replace_termcodes("<C-f>", true, true, true), "n", false)
  else
    vim.api.nvim_feedkeys(count .. "I", "n", false)
  end
end

local function last_non_blank_line_start_insert_mode()
  local count = vim.v.count1
  local line = vim.api.nvim_get_current_line()
  if #line == 0 then
    vim.api.nvim_feedkeys(count .. "A" .. vim.api.nvim_replace_termcodes("<C-f>", true, true, true), "n", false)
  else
    vim.api.nvim_feedkeys(count .. "A", "n", false)
  end
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

local function W()
  local mode = vim.api.nvim_get_mode().mode
  local count = vim.v.count1

  if mode == "n" then
    vim.api.nvim_feedkeys(count .. "I", "n", false)
  elseif mode == "V" or mode == "v" then
    local esc = vim.api.nvim_replace_termcodes("<Esc>", true, true, true)
    vim.api.nvim_feedkeys(esc .. count .. "I", "n", true)
  end
end

local function E()
  local mode = vim.api.nvim_get_mode().mode
  local count = vim.v.count1

  if mode == "n" then
    vim.api.nvim_feedkeys(count .. "A", "n", false)
  elseif mode == "V" or mode == "v" then
    local esc = vim.api.nvim_replace_termcodes("<Esc>", true, true, true)
    vim.api.nvim_feedkeys(esc .. count .. "A", "n", true)
  elseif mode == "" then
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
    W,
    { "n", "x" },
    desc = "Start enter insert mode",
  },
  ["E"] = {
    E,
    { "n", "x" },
    desc = "End enter insert mode",
  },
  ["<space>w"] = {
    {
      function()
        first_non_blank_line_start_insert_mode()
      end,
      "n",
      desc = "Start insert mode to the left of the first non-blank character in the current line",
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
      function()
        last_non_blank_line_start_insert_mode()
      end,
      "n",
      desc = "Start insert mode to the right of the last non-blank character in the current line",
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
      function()
        local count = vim.v.count1
        vim.api.nvim_feedkeys("$" .. count .. "a", "n", false)
      end,
      "n",
      desc = "Start insert mode to the right of the last character in the current line",
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
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, true, true), "nx", true)
      local start_row, start_col = unpack(vim.api.nvim_buf_get_mark(0, "<"))
      vim.api.nvim_win_set_cursor(0, { start_row, start_col })
      vim.api.nvim_feedkeys(count .. "I", "n", false)
    end,
    "x",
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
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, true, true), "nx", true)
      vim.api.nvim_feedkeys(count .. "gI", "n", false)
    end,
    "x",
  },
  ["<space><space>E"] = {
    function()
      local count = vim.v.count1
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, true, true), "nx", true)
      vim.api.nvim_feedkeys("$" .. count .. "a", "n", false)
    end,
    "x",
  },
  ["<S-space>w"] = {
    function()
      local count = vim.v.count1
      vim.api.nvim_feedkeys("g^" .. count .. "i", "n", true)
    end,
    "n",
    desc = "Start insert mode to the left of the first non-blank character in the screen line",
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
      vim.api.nvim_feedkeys("g0" .. count .. "i", "nx", true)
    end,
    "n",
    desc = "Start insert mode to the left of the first character in the screen line",
  },
  ["<S-space><S-space>e"] = {
    function()
      local count = vim.v.count1
      vim.api.nvim_feedkeys("g$" .. count .. "a", "n", false)
    end,
    "n",
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

  ["zw"] = {
    function()
      local count = vim.v.count1
      local esc = vim.api.nvim_replace_termcodes("<Esc>", true, true, true)
      vim.api.nvim_feedkeys(esc .. "g0" .. count .. "i", "n", false)
    end,
    "n",
    desc = "Start insert mode to the far left character of the screen window",
  },
  ["ze"] = {
    function()
      local count = vim.v.count1
      local esc = vim.api.nvim_replace_termcodes("<Esc>", true, true, true)
      vim.api.nvim_feedkeys(esc .. "g$" .. count .. "a", "n", false)
    end,
    "n",
    desc = "Start insert mode to the far right character of the screen window",
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
