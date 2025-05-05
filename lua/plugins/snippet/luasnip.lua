return {
  "L3MON4D3/LuaSnip",
  event = "InsertEnter",
  -- version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
  build = "make install_jsregexp",
  opts = {},
  dependencies = {
    "rafamadriz/friendly-snippets",
  },
  config = function()
    require("luasnip.loaders.from_lua").lazy_load({ paths = vim.fn.stdpath("config") .. "/lua/snippets/" })

    local ls = require("luasnip")

    local options = {
      history = true,
      updateevents = "TextChanged,TextChangedI",
      enable_autosnippets = true,
      cut_selection_keys = '<Tab>',
    }

    ls.config.set_config(options)
    ls.config.setup({ store_selection_keys = "<Tab>" })
  end,
}
