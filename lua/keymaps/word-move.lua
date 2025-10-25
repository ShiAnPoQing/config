return {
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
  -- ["<C-i>"] = {
  --   "ge",
  --   { "n", "x", "o" },
  --   desc = "Backward to the end of word [count]",
  -- },
  -- ["<C-o>"] = {
  --   "w",
  --   { "n", "x", "o" },
  --   desc = "[count] words forward",
  -- },
  ["<space>i"] = {
    "ge",
    { "n", "x", "o" },
    desc = "Backward to the end of word [count]",
  },
  ["<space>o"] = {
    "w",
    { "n", "x", "o" },
    desc = "[count] words forward",
  },
  ["<space>I"] = {
    "gE",
    { "n", "x", "o" },
    desc = "Backward to the end of WORD [count]",
  },
  ["<space>O"] = {
    "W",
    { "n", "x", "o" },
    desc = "[count] WORDS forward",
  },
  -- ["<C-S-i>"] = {
  --   "gE",
  --   { "n", "x", "o" },
  --   desc = "Backward to the end of WORD [count]",
  -- },
  -- ["<C-S-o>"] = {
  --   "W",
  --   { "n", "x", "o" },
  --   desc = "[count] WORDS forward",
  -- },
}
