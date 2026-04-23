return {
  name = "lsp-layer.nvim",
  config = function() end,
  key = {
    [",,1"] = {
      function()
        require("lsp-layer.code_action")
          :request({})
          :filter(function()
            return true
          end)
          :filter(function()
            return true
          end)
      end,
      "n",
    },
  },
}
