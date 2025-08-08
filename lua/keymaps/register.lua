return {
  ["<space>y"] = {
    function()
      require("custom.plugins.register").copy("y")
    end,
    { "n", "x" },
  },
  ["<space>Y"] = {
    function()
      require("custom.plugins.register").copy("Y")
    end,
    { "n", "x" },
  },
  ["<space>yy"] = {
    function()
      require("custom.plugins.register").copy("yy")
    end,
    { "n" },
  },
  ["<space>p"] = {
    function()
      require("custom.plugins.register").paste("p")
    end,
    { "n", "x" },
  },
  ["<space>P"] = {
    function()
      require("custom.plugins.register").paste("P")
    end,
    { "n", "x" },
  },
  ["<space>d"] = {
    function()
      require("custom.plugins.register").delete("d")
    end,
    { "n", "x" },
  },
  ["<space>D"] = {
    function()
      require("custom.plugins.register").delete("D")
    end,
    { "n", "x" },
  },
  ["<space>dd"] = {
    function()
      require("custom.plugins.register").delete("dd")
    end,
    { "n" },
  },
  ["<space>x"] = {
    function()
      require("custom.plugins.register").delete_x("x")
    end,
    { "n", "x" },
  },
  ["<space>X"] = {
    function()
      require("custom.plugins.register").delete_x("X")
    end,
    { "n", "x" },
  },
  ["<space>c"] = {
    function()
      require("custom.plugins.register").change("c")
    end,
    { "n", "x" },
  },
  ["<space>C"] = {
    function()
      require("custom.plugins.register").change("C")
    end,
    { "n", "x" },
  },
  ["<space>cc"] = {
    function()
      require("custom.plugins.register").change("cc")
    end,
    { "n" },
  },
}
