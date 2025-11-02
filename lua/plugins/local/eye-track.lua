return {
  name = "eye-track.nvim",
  keys = {
    ["<leader>2"] = {
      function()
        require("eye-track.keyword").main({
          keyword = function(context)
            return context.word_inner
          end,
        })
      end,
      "n",
    },
  },
  config = function(opt)
    require("eye-track").setup({})
  end,
}
