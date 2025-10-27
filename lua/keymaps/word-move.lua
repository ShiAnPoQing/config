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
  ["<space>i"] = {
    {
      "ge",
      "n",
    },
    {
      function()
        vim.api.nvim_feedkeys("vgeloh", "nx", false)
      end,
      "o",
      desc = "Backward to the end of word [count](Left Exclusion)",
    },
    {
      "hgel",
      "x",
      desc = "Backward to the end of word [count](Left Exclusion)",
    },
    desc = "Backward to the end of word [count]",
  },
  ["<space>o"] = {
    {
      "w",
      { "n", "o" },
    },
    {
      "lwh",
      "x",
      desc = "[count] words forward(Right Exclusion)",
    },
    desc = "[count] words forward",
  },
  ["<space>I"] = {
    {
      "gE",
      "n",
    },
    {
      function()
        vim.api.nvim_feedkeys("vgEloh", "nx", false)
      end,
      "o",
    },
    {
      "hgEl",
      "x",
    },
    desc = "Backward to the end of WORD [count]",
  },
  ["<space>O"] = {
    {
      "W",
      { "n", "o" },
    },
    {
      "lWh",
      "x",
    },
    desc = "[count] WORDS forward",
  },
}
