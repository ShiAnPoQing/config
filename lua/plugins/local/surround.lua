local function surround_delete(match)
  require("surround").delete(match)
  require("repeat").set_operation(surround_delete)
end

local function surround_exchange(match)
  require("surround").exchange(match)
  require("repeat").set_operation(surround_exchange)
end

return {
  name = "surround",
  keys = {
    -- ["ds)"] = {
    --   function()
    --     surround_delete(")")
    --   end,
    --   "n",
    -- },
    -- -- {
    -- ["ds("] = {
    --   function()
    --     surround_delete("(")
    --   end,
    --   "n",
    -- },
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
