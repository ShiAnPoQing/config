return {
  name = "ring.nvim",
  config = function()
    require("ring").setup({
      registers = {
        ["s("] = { "w(", { "%(", "%)" }, name = "()" },
        ["s)"] = { "w(", { "%(", "%)" } },
        ["s["] = { "w[", { "[", "]" } },
        ["s]"] = { "w]", { "[", "]" } },
        ["s{"] = { "w{", { "{", "}" } },
        ["s}"] = { "w}", { "{", "}" } },
        ["s'"] = { "w'", { "'", "'" } },
        ['s"'] = { 'w"', { '"', '"' } },
        ["s`"] = { "w`", { "`", "`" } },
        ["sf"] = {
          function()
            local a, b, c, d = require("treesitter-textobject.select").range({
              language = "lua",
              query = "function.outer",
              scm = "textobjects",
            })
            return { { a, b }, { c, d } }
          end,
          { "function", "end" },
        },
      },
    })
  end,
}
