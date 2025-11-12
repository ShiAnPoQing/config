return {
  name = "concat-line",
  keys = {
    ["-"] = {
      function()
        require("concat-line").line_concat({ join_char = " " })
        return "g@"
      end,
      { "n", "x" },
      expr = true,
    },
    ["g-"] = {
      function()
        local function callback()
          require("concat-line").line_concat({ trim_blank = false })
          vim.api.nvim_feedkeys("g@", "nx", false)
          require("repeat").set_operation(callback)
        end
        callback()
      end,
      { "n", "x" },
    },
    ["g--"] = {
      function()
        local function callback()
          require("concat-line").line_concat({ trim_blank = false })
          vim.api.nvim_feedkeys("g@_", "nx", false)
          require("repeat").set_operation(callback)
        end
        callback()
      end,
      { "n" },
    },
  },
  config = function()
    require("concat-line").setup()
  end,
}
