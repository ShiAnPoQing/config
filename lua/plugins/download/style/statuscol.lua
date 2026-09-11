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
            namespace = { "gitsigns.*" },
            name = { "gitsigns.*" },
            colwidth = 1,
            maxwidth = 1,
            auto = true
          },
        },
        {
          sign = {
            namespace = { ".*" },
            name = { ".*" },
          },
        },
        {
          text = {
            builtin.lnumfunc,
            " ",
          },
          condition = { true, builtin.not_empty },
          click = "v:lua.ScLa",
        },
        { text = { builtin.foldfunc, " " }, click = "v:lua.ScFa" },
      },
    })
  end,
}
