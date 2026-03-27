return {
  "luukvbaal/statuscol.nvim",
  lazy = false,
  config = function()
    local builtin = require("statuscol.builtin")
    require("statuscol").setup({
      setopt = true,
      segments = {
        {
          sign = {
            namespace = { ".*" },
            name = { ".*" },
          },
        },
        {
          text = {
            function(args)
              return ("%3d %2d "):format(args.lnum, args.relnum)
            end,
            " ",
          },
          condition = { true, builtin.not_empty },
          click = "v:lua.ScLa",
        },
        {
          sign = {
            namespace = { "gitsigns.*" },
            name = { "gitsigns.*" },
            auto = true,
          },
        },
        { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
      },
    })
  end,
}
