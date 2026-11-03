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
          text = { builtin.foldfunc, " " },
          click = "v:lua.ScFa",
          condition = {
            true,
            function(args)
              return args.fold.width ~= 0
            end,
          },
        },
        {
          text = {
            function(args)
              if args.relnum == 0 then
                return "%=" .. args.lnum
              end
              return "%=" .. args.relnum
            end,
            " ",
          },
          click = "v:lua.ScLa",
        },
      },
    })
  end,
}
