local utils = require("utils.mark")

local function w()
  local count = vim.v.count1
  vim.api.nvim_feedkeys(count .. "i", "n", false)
end

local function e()
  local count = vim.v.count1
  vim.api.nvim_feedkeys(count .. "a", "n", false)
end

local function normal_mode_start_end_enter_insert_mode(dir)
  local count = vim.v.count1
  if dir == "left" then
    vim.api.nvim_feedkeys(count .. "I", "n", false)
  else
    vim.api.nvim_feedkeys(count .. "A", "n", false)
  end
end

local function visual_mode_start_end_enter_insert_mode(dir)
  local count = vim.v.count1
  local mode = vim.api.nvim_get_mode().mode

  if mode == "V" or mode == "v" then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, true, true), "nx", true)
    local start_row, start_col, end_row, end_col = utils.get_visual_mark(true)

    if dir == "left" then
      vim.api.nvim_win_set_cursor(0, { start_row, start_col })
      vim.schedule(function()
        vim.api.nvim_feedkeys(count .. "i", "n", false)
      end)
    else
      vim.api.nvim_win_set_cursor(0, { end_row, end_col })
      vim.schedule(function()
        vim.api.nvim_feedkeys(count .. "a", "n", false)
      end)
    end
  elseif mode == "" then
    if dir == "left" then
      vim.api.nvim_feedkeys(count .. "I", "n", false)
    else
      vim.api.nvim_feedkeys(count .. "A", "n", false)
    end
  elseif mode == "s" or mode == "" then
    local key = vim.api.nvim_replace_termcodes("<C-g>", true, true, true)
    vim.api.nvim_feedkeys(key, "nx", true)
    visual_mode_start_end_enter_insert_mode(dir)
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
  ["w"] = { w, "n", { desc = "left enter insert mode" }, },
  ["e"] = { e, "n", { desc = "right enter insert mode" }, },
  ["W"] = { W, { "n", "x" }, { desc = "start enter insert mode" }, },
  ["E"] = { E, { "n", "x" }, { desc = "end enter insert mode" }, },
  -- normal mode cursor move: Home(without space)
  ["<space>w"] = {
    {
      function()
        normal_mode_start_end_enter_insert_mode("left")
      end,
      "n",
    },
    {
      function()
        visual_mode_start_end_enter_insert_mode("left")
      end,
      { "x", "s" },
    },
  },
  -- normal mode cursor move: End(without space)
  ["<space>e"] = {
    {
      function()
        normal_mode_start_end_enter_insert_mode("right")
      end,
      "n",
    },
    {
      function()
        visual_mode_start_end_enter_insert_mode("right")
      end,
      { "x", "s" },
    },
  },
  -- ["<space><space>w"] = { "0i", { "n" } },
  ["<space><space>w"] = { "gI", { "n" } },
  ["<space><space>e"] = { "$a", { "n" } },
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
    { "<Esc>ea",   { "i" } },
    { "<S-right>", { "c" } },
    { "ea",        { "n" } },
    { "<C-right>", "t" }
  },
  -- normal mode into insert mode: Ei
  ["<M-S-o>"] = {
    { "<Esc>Ea", { "i" } },
    { "Ea",      { "n" } },
  },
  -- normal mode into insert mode: bi
  ["<M-i>"] = {
    { "<Esc>bi",  { "i" } },
    { "<S-left>", { "c" } },
    { "bi",       { "n" } },
    { "<C-left>", "t" }
  },
  -- normal mode into insert mode: Bi
  ["<M-S-i>"] = {
    { "<Esc>Bi", { "i" } },
    { "Bi",      { "n" } },
  },
  -- normal mode into insert mode: cursor at screen left
  ["aw"] = { "<Esc>g0i", { "n" } },
  -- normal mode into insert mode: cursor at screen right
  ["ae"] = { "<Esc>g$i", { "n" } },

}
