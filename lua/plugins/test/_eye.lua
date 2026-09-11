return {
  {
    name = "_eye.nvim",
    lazy = false,
    key = {
      ["<leader>8"] = {
        function()
          require("_eye.plugin.word").eye({
            regex = function(ctx)
              return ctx["word.inner"]
            end,
            position = -1,
            matched = function(ctx)
              -- vim.print(ctx)
            end,
          })
        end,
        "n",
      },
    },
    config = function() end,
  },
  {
    name = "eye-multicursor.nvim",
    lazy = false,
    depend = { "_eye.nvim" },
    key = {
      ["0Q"] = {
        function()
          require("eye-multicursor").delete(true)
        end,
        "n",
        desc = "eye-multicursor.nvim: delete which[0] cursor",
      },
      ["0c"] = {
        function()
          if vim.v.operator == "d" then
            require("eye-multicursor").delete()
            return "<esc>"
          end
          return "0c"
        end,
        "o",
        expr = true,
        desc = "eye-multicursor.nvim: delete which[0] cursor, continue",
      },
    },
  },
}
