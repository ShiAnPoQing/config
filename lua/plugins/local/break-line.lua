return {
  name = "break-line",
  keys = {
    ["<space><CR>"] = {
      function()
        local function callback()
          require("break-line").break_line(vim.v.count1)
          require("repeat"):set(callback)
        end
        callback()
      end,
      { "n", "x" },
      expr = true,
    },
  },
  config = function(opt)
    require("break-line").setup()
  end,
}
