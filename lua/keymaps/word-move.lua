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
  },
  ["o"] = {
    "e",
    { "n", "x", "o" },
  },
  ["I"] = {
    "B",
    { "n", "x", "o" },
  },
  ["O"] = {
    "E",
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
}
