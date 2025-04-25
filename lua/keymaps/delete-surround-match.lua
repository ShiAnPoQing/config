local M = require("custom.plugins.delete-surround-match")

return {
  ["ds)"] = {
    function()
      M.delete_surround_match(")")
    end,
    "n"
  },
  ["ds("] = {
    function()
      M.delete_surround_match(")")
    end,
    "n"
  },
  ["ds["] = {
    function()
      M.delete_surround_match("[")
    end,
    "n"
  },
  ["ds]"] = {
    function()
      M.delete_surround_match("]")
    end,
    "n"
  },
  ["ds{"] = {
    function()
      M.delete_surround_match("}")
    end,
    "n"
  },
  ["ds}"] = {
    function()
      M.delete_surround_match("}")
    end,
    "n"
  },
  ['ds"'] = {
    function()
      M.delete_surround_match('"')
    end,
    "n"
  },
  ["ds'"] = {
    function()
      M.delete_surround_match("'")
    end,
    "n"
  },
  ["ds<"] = {
    function()
      M.delete_surround_match("<")
    end,
    "n"
  },
  ["ds>"] = {
    function()
      M.delete_surround_match("<")
    end,
    "n"
  }
}
