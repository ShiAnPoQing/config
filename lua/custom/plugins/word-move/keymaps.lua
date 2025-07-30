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
