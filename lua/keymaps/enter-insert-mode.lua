return {
  -- ["e"] = { "a", { "n" } },
  -- ["w"] = { "i", { "n" } },
  ["w"] = {
    function()
      require("base-function").leftEnterInsertMode()
    end,
    "n",
    { desc = "left enter insert mode" },
  },
  ["e"] = {
    function()
      require("base-function").rightEnterInsertMode()
    end,
    "n",
    { desc = "right enter insert mode" },
  },
  ["W"] = { "I", { "n", "x" } },
  ["E"] = { "A", { "n", "x" } },
  -- normal mode cursor move: Home(without space)
  ["<space>w"] = {
    {
      function()
        return require("base-function").EnterInertMode("n", "left")
      end,
      { "n" },
    },
    {
      function()
        return require("base-function").EnterInertMode("v", "left")
      end,
      { "x" },
    },
    {
      function()
        return require("base-function").EnterInertMode("s", "left")
      end,
      { "s" },
    },
  },
  -- normal mode cursor move: End(without space)
  ["<space>e"] = {
    {
      function()
        return require("base-function").EnterInertMode("n", "right")
      end,
      { "n" },
    },
    {
      function()
        return require("base-function").EnterInertMode("v", "right")
      end,
      { "x" },
    },
    {
      function()
        return require("base-function").EnterInertMode("s", "right")
      end,
      { "s" },
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
