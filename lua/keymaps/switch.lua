return {
  [";ig"] = {
    function()
      require("switch-function").switch("ignorecase")
    end,
    { "n" },
  },
  -- toggle list icon
  [";li"] = {
    function()
      require("switch-function").switch("list")
    end,
    { "n" },
  },
  -- toggle hlsearch highlight
  [";hl"] = {
    function()
      require("switch-function").switch("hlsearch")
    end,
    { "n" },
  },
  -- toggle comment
  ["<C-\\>"] = {
    {
      function()
        local C = require("comment")
        local count = vim.v.count1
        C.toggleComment("n", count)
        require("repeat").Record(function()
          C.toggleComment("n", count)
        end)
      end,
      "n",
    },
    {
      function()
        local C = require("comment")
        local count = vim.v.count1
        C.toggleComment("v", count)
        require("repeat").Record(function()
          C.toggleComment("v", count)
        end)
      end,
      "x",
    },
    {
      function()
        local C = require("comment")
        local count = vim.v.count1
        C.toggleComment("n", count)
        require("repeat").Record(function()
          C.toggleComment("n", count)
        end)
      end,
      "i",
    },
  },
}
