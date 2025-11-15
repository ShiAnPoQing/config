return {
  "BrokenSunny/paradox.nvim",
  priority = 1000,
  -- colorscheme = "paradox",
  config = function(opt)
    require("paradox").setup()
    local time = tonumber(os.date("%H"))
    if time >= 17 or time < 7 then
      vim.o.background = "dark"
    else
      vim.o.background = "light"
    end
    vim.cmd([[colorscheme paradox]])
  end,
}
