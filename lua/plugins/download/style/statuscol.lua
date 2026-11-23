return {
  "luukvbaal/statuscol.nvim",
  lazy = false,
  config = function()
    local builtin = require("statuscol.builtin")
    require("statuscol").setup({
      setopt = true,
      ft_ignore = { "neo-tree", "neo-tagstack" },
      bt_ignore = { "neo-tree" },
      segments = {
        {
          sign = {
            namespace = { ".*" },
            name = { ".*" },
            colwidth = 1,
            maxwidth = 1,
          },
        },
        {
          text = {
            function(args)
              return "%=" .. (args.relnum == 0 and args.lnum or args.relnum)
            end,
            " ",
          },
          click = "v:lua.ScLa",
        },
        {
          text = { builtin.foldfunc, " " },
          click = "v:lua.ScFa",
          condition = {
            true,
            function(args)
              return args.fold.width ~= 0
            end,
          },
        },
      },
    })
  end,
}
