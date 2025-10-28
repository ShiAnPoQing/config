local o_mode_space_i = function()
  vim.api.nvim_feedkeys("vgeloh", "nx", false)
end

local o_mode_space_I = function()
  vim.api.nvim_feedkeys("vgEloh", "nx", false)
end

return {
  ["i"] = { "b", { "n", "x", "o" }, desc = "Backward to the start of word[count]" },
  ["o"] = { "e", { "n", "x", "o" }, desc = "Forword to the end of the word[count]" },
  ["I"] = { "B", { "n", "x", "o" }, desc = "Backward to the start of WORD[count]" },
  ["O"] = { "E", { "n", "x", "o" }, desc = "Forword to the end of the WORD[count]" },
  ["<space>i"] = {
    { "ge", "n" },
    { "hgel", "x", desc = "Backward to the end of word[count](left exclusion)" },
    { o_mode_space_i, "o", desc = "Backward to the end of word[count](left exclusion)" },
    desc = "Backward to the end of word[count]",
  },
  ["<space>o"] = {
    { "w", { "n", "o" } },
    { "lwh", "x", desc = "Forword to the start of the word[count](right exclusion)" },
    desc = "Forword to the start of the word[count]",
  },
  ["<space>I"] = {
    { "gE", "n" },
    { "hgEl", "x", desc = "Backward to the end of WORD[count](left exclusion)" },
    { o_mode_space_I, "o", desc = "Backward to the end of WORD[count](left exclusion)" },
    desc = "Backward to the end of WORD[count]",
  },
  ["<space>O"] = {
    { "W", { "n", { "o", desc = "Forword to the start of the WORD[count](right exclusion)" } } },
    { "lWh", "x", desc = "Forword to the start of the WORD[count](right exclusion)" },
    desc = "Forword to the start of the WORD[count]",
  },
  ["<M-i>"] = {
    { "bi", "n", desc = "Backward to the start of word[count] and start insert mode" },
    { "<S-left>", "i", desc = "Backward to the start of word" },
    { "<C-left>", "t", desc = "Backward to the start of word" },
  },
  ["<M-o>"] = {
    { "<Esc>ea", "i", desc = "Forword to the end of the word" },
    { "ea", "n", desc = "Forword to the end of the word and start insert mode" },
    { "<C-right>", "t", desc = "Forword to the end of the word[count]" },
  },
  ["<M-space><M-i>"] = { "<Esc>gea", "i", desc = "Backward to the end of word" },
  ["<M-space><M-o>"] = { "<S-right>", "i", desc = "Forword to the start of the word" },
  ["<M-S-i>"] = {
    { "<Esc>Bi", "i", desc = "Backward to the start of WORD" },
    { "Bi", "n", desc = "Backward to the start of WORD and start insert mode" },
  },
  ["<M-S-o>"] = {
    { "<Esc>Ea", "i", desc = "Forword to the end of the WORD" },
    { "Ea", "n", desc = "Forword to the end of the WORD and start insert mode" },
  },
  ["<M-space><M-S-i>"] = { "<C-o>gE", "i", desc = "Backward to the end of WORD[count]" },
  ["<M-space><M-S-o>"] = { "<C-o>W", "i", desc = "Forword to the start of the word[count]" },
}
