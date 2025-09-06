return {
  ["<space>y"] = {
    function()
      require("custom.plugins.register").copy("y")
    end,
    { "n", "x" },
    desc = "Yank to register",
  },
  ["<space>Y"] = {
    function()
      require("custom.plugins.register").copy("Y")
    end,
    { "n", "x" },
    desc = "Yank to register",
  },
  ["<space>yy"] = {
    function()
      require("custom.plugins.register").copy("yy")
    end,
    "n",
    desc = "Yank to register",
  },
  ["<space>p"] = {
    function()
      require("custom.plugins.register").paste("p")
    end,
    { "n", "x" },
    desc = "Paste from register",
  },
  ["<space>P"] = {
    function()
      require("custom.plugins.register").paste("P")
    end,
    { "n", "x" },
    desc = "Paste from register",
  },
  ["<space>d"] = {
    function()
      require("custom.plugins.register").delete("d")
    end,
    { "n", "x" },
    desc = "Delete into register",
  },
  ["<space>D"] = {
    function()
      require("custom.plugins.register").delete("D")
    end,
    { "n", "x" },
    desc = "Delete into register",
  },
  ["<space>dd"] = {
    function()
      require("custom.plugins.register").delete("dd")
    end,
    { "n" },
    desc = "Delete into register",
  },
  ["<space>x"] = {
    function()
      require("custom.plugins.register").delete_x("x")
    end,
    { "n", "x" },
    desc = "Delete into register",
  },
  ["<space>X"] = {
    function()
      require("custom.plugins.register").delete_x("X")
    end,
    { "n", "x" },
    desc = "Delete into register",
  },
  ["<space>c"] = {
    function()
      require("custom.plugins.register").change("c")
    end,
    { "n", "x" },
    desc = "Change into register",
  },
  ["<space>C"] = {
    function()
      require("custom.plugins.register").change("C")
    end,
    { "n", "x" },
    desc = "Change into register",
  },
  ["<space>cc"] = {
    function()
      require("custom.plugins.register").change("cc")
    end,
    { "n" },
    desc = "Change into register",
  },
}
