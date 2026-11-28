return {
  ["Y"] = {
    function()
      return my.operator.yank()
    end,
    "x",
    expr = true,
  },
  ["y"] = {
    function()
      return my.operator.yank()
    end,
    "x",
    expr = true,
  },
  ["d"] = {
    function()
      return my.operator.delete()
    end,
    "x",
    expr = true,
  },
  ["-"] = {
    function()
      return my.operator.join()
    end,
    "x",
    expr = true,
  },
  ["g-"] = {
    function()
      return my.operator.join({ only_join = true })
    end,
    "x",
    expr = true,
  },
  ["gU"] = {
    function()
      return my.operator.uppercase()
    end,
    "x",
    expr = true,
  },
  ["gu"] = {
    function()
      return my.operator.lowercase()
    end,
    "x",
    expr = true,
  },
}
