return {
  -- For insert mode: like <M-d><M-o>
  -- ["<M-o>"] = {
  --   "e",
  --   "o",
  -- },
  -- -- For insert mode: like <M-d><M-i>
  -- ["<M-i>"] = {
  --   "b",
  --   "o",
  -- },
  ["i"] = {
    "b",
    { "n", "x", "o" },
    desc = "Move to the beginning of the word(left)",
  },
  ["o"] = {
    "e",
    { "n", "x", "o" },
    desc = "Move to the end of the word(right)",
  },
  ["I"] = {
    "B",
    { "n", "x", "o" },
    desc = "Move to the beginning of the WORD(left)",
  },
  ["O"] = {
    "E",
    { "n", "x", "o" },
    desc = "Move to the end of the WORD(right)",
  },
  ["<C-i>"] = {
    "ge",
    { "n", "x", "o" },
  },
  ["<C-o>"] = {
    "w",
    { "n", "x", "o" },
  },
  ["<space>i"] = {
    "ge",
    { "n", "x", "o" },
  },
  ["<space>o"] = {
    "w",
    { "n", "x", "o" },
  },
  ["<space>I"] = {
    "gE",
    { "n", "x", "o" },
  },
  ["<space>O"] = {
    "W",
    { "n", "x", "o" },
  },
  -- ["<C-S-i>"] = {
  --   "gE",
  --   { "n", "x", "o" },
  -- },
  -- ["<C-S-o>"] = {
  --   "W",
  --   { "n", "x", "o" },
  -- },
}
