return {
  "L3MON4D3/LuaSnip",
  dependencies = {
    "rafamadriz/friendly-snippets",
  },
  event = "InsertEnter",
  -- version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
  build = "mark install_jsregexp",
  config = function()
    require("luasnip.loaders.from_lua").lazy_load({ paths = vim.fn.stdpath("config") .. "/lua/snippets/" })

    local ls = require("luasnip")

    local options = {
      history = true,
      updateevents = "TextChanged,TextChangedI",
      enable_autosnippets = true,
      cut_selection_keys = "<Tab>",
    }

    ls.config.set_config(options)
    ls.config.setup({ store_selection_keys = "<Tab>" })

    require("simple-keymap").add({
      ["<leader>sc"] = {
        function()
          require("luasnip").cleanup()
        end,
        "n",
      },
      ["<C-space><C-n>"] = {
        function()
          local luasnip = require("luasnip")
          if luasnip.choice_active() and luasnip.in_snippet() then
            luasnip.change_choice(1)
          end
        end,
        "i",
      },
      ["<C-space><C-p>"] = {
        function()
          local luasnip = require("luasnip")
          if luasnip.choice_active() and luasnip.in_snippet() then
            luasnip.change_choice(-1)
          end
        end,
        "i",
      },
    })
  end,
}
