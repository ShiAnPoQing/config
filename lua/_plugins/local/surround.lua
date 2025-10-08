local function surround_delete(match)
  require("surround").delete(match)
  require("repeat"):set(function()
    require("surround").delete(match)
  end)
end

local function surround_exchange(match)
  require("surround").exchange(match)
  require("repeat"):set(function()
    require("surround").exchange(match)
  end)
end

return {
  name = "surround",
  keys = {
    ["ds)"] = {
      function()
        surround_delete(")")
      end,
      "n",
    },
    -- {
    ["ds("] = {
      function()
        surround_delete("(")
      end,
      "n",
    },
    -- {
    --   "ds]",
    --   function()
    --     surround_delete("]")
    --   end,
    --   "n"
    -- },
    -- {
    --   "ds[",
    --   function()
    --     surround_delete("[")
    --   end,
    --   "n"
    -- },
    -- {
    --   "ds{",
    --   function()
    --     surround_delete("{")
    --   end,
    --   "n"
    -- },
    -- {
    --   "ds}",
    --   function()
    --     surround_delete("}")
    --   end,
    --   "n"
    -- },
    -- {
    --   "ds'",
    --   function()
    --     surround_delete("'")
    --   end,
    --   "n"
    -- },
    -- {
    --   'ds"',
    --   function()
    --     surround_delete('"')
    --   end,
    --   "n"
    -- },
    -- {
    --   "ds<",
    --   function()
    --     surround_delete("<")
    --   end,
    --   "n"
    -- },
    -- {
    --   "ds>",
    --   function()
    --     surround_delete(">")
    --   end,
    --   "n"
    -- },
    -- {
    --   "cs)",
    --   function()
    --     surround_exchange(")")
    --   end,
    --   "n"
    -- },
    -- {
    --   "cs(",
    --   function()
    --     surround_exchange("(")
    --   end,
    --   "n"
    -- },
    -- {
    --   "cs{",
    --   function()
    --     surround_exchange("{")
    --   end,
    --   "n"
    -- },
    -- {
    --   "cs}",
    --   function()
    --     surround_exchange("}")
    --   end,
    --   "n"
    -- },
    -- {
    --   "cs[",
    --   function()
    --     surround_exchange("[")
    --   end,
    --   "n"
    -- },
    -- {
    --   "cs]",
    --   function()
    --     surround_exchange("]")
    --   end,
    --   "n"
    -- },
    -- {
    --   "cs<",
    --   function()
    --     surround_exchange("<")
    --   end,
    --   "n"
    -- },
    -- {
    --   "cs>",
    --   function()
    --     surround_exchange(">")
    --   end,
    --   "n"
    -- },
    -- {
    --   "cs'",
    --   function()
    --     surround_exchange("'")
    --   end,
    --   "n"
    -- },
    -- {
    --   'cs"',
    --   function()
    --     surround_exchange('"')
    --   end,
    --   "n"
    -- },
  },
  config = function(opt)
    require("surround").setup()
  end,
}
