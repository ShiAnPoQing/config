local W = require("custom.plugins.word-move")

return {
  ["<M-o>"] = {
    W.o,
    "o",
  },
  ["<M-i>"] = {
    W.i,
    "o",
  },
  ["<M-space><M-o>"] = {
    W.space_o,
    "o",
  },
  ["<M-space><M-i>"] = {
    W.space_i,
    "o",
  },
  ["<M-space><M-O>"] = {
    W.space_O,
    "o",
  },
  ["<M-space><M-I>"] = {
    W.space_I,
    "o",
  },
  ["i"] = {
    W.i,
    { "n", "x", "o" },
  },
  ["o"] = {
    W.o,
    { "n", "x", "o" },
  },
  ["I"] = {
    W.I,
    { "n", "x", "o" },
  },
  ["O"] = {
    W.O,
    { "n", "x", "o" },
  },
  ["<space>i"] = {
    function()
      W.space_i()
    end,
    { "n", "x", "o" },
  },
  ["<space>o"] = {
    function()
      W.space_o()
    end,
    { "n", "x", "o" },
  },
  ["<space>I"] = {
    W.space_I,
    { "n", "x", "o" },
  },
  ["<space>O"] = {
    W.space_O,
    { "n", "x", "o" },
  },
}
