return {
  name = "op-register.nvim",
  keys = {
    ["<space>y"] = {
      function()
        require("op-register").copy("y")
      end,
      { "n", "x" },
      desc = "Yank to register",
    },
    ["<space>Y"] = {
      function()
        require("op-register").copy("Y")
      end,
      { "n", "x" },
      desc = "Yank to register",
    },
    ["<space>yy"] = {
      function()
        require("op-register").copy("yy")
      end,
      "n",
      desc = "Yank to register",
    },
    ["<space>p"] = {
      function()
        require("op-register").paste("p")
      end,
      { "n", "x" },
      desc = "Paste from register",
    },
    ["<space>P"] = {
      function()
        require("op-register").paste("P")
      end,
      { "n", "x" },
      desc = "Paste from register",
    },
    ["<space>d"] = {
      function()
        require("op-register").delete("d")
      end,
      { "n", "x" },
      desc = "Delete into register",
    },
    ["<space>D"] = {
      function()
        require("op-register").delete("D")
      end,
      { "n", "x" },
      desc = "Delete into register",
    },
    ["<space>dd"] = {
      function()
        require("op-register").delete("dd")
      end,
      { "n" },
      desc = "Delete into register",
    },
    ["<space>x"] = {
      function()
        require("op-register").delete_x("x")
      end,
      { "n", "x" },
      desc = "Delete into register",
    },
    ["<space>X"] = {
      function()
        require("op-register").delete_x("X")
      end,
      { "n", "x" },
      desc = "Delete into register",
    },
    ["<space>c"] = {
      function()
        require("op-register").change("c")
      end,
      { "n", "x" },
      desc = "Change into register",
    },
    ["<space>C"] = {
      function()
        require("op-register").change("C")
      end,
      { "n", "x" },
      desc = "Change into register",
    },
    ["<space>cc"] = {
      function()
        require("op-register").change("cc")
      end,
      { "n" },
      desc = "Change into register",
    },
  },
  config = function() end,
}
