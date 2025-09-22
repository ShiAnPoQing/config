return {
  dir = vim.fn.stdpath("config") .. "/lua/custom/plugins/break-line",
  name = "break-line",
  keys = {
    {
      "<space><CR>",
      function()
        require("break-line").break_line(vim.v.count1)
        require("repeat"):set(function()
          require("break-line").break_line(vim.v.count1)
        end)
      end,
      mode = { "n", "x" },
      expr = true,
    },
  },
  config = function(opt)
    require("break-line").setup()
  end,
}
