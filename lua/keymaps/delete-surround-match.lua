local M = require("custom.plugins.surround.delete-surround")

return {
  ["ds)"] = {
    function()
      M.delete_surround_match(")")
    end,
    "n",
  },
  ["ds("] = {
    function()
      M.delete_surround_match(")")
    end,
    "n",
  },
  ["ds["] = {
    function()
      M.delete_surround_match("[")
    end,
    "n",
  },
  ["ds]"] = {
    function()
      M.delete_surround_match("]")
    end,
    "n",
  },
  ["ds{"] = {
    function()
      M.delete_surround_match("}")
    end,
    "n",
  },
  ["ds}"] = {
    function()
      M.delete_surround_match("}")
    end,
    "n",
  },
  ['ds"'] = {
    function()
      M.delete_surround_match('"')
    end,
    "n",
  },
  ["ds'"] = {
    function()
      M.delete_surround_match("'")
    end,
    "n",
  },
  ["ds<"] = {
    function()
      M.delete_surround_match("<")
    end,
    "n",
  },
  ["ds>"] = {
    function()
      M.delete_surround_match("<")
    end,
    "n",
  },
}
