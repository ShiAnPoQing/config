return {
	"L3MON4D3/LuaSnip",
	event = "InsertEnter",
	version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
	build = "make install_jsregexp",
	dependencies = {
		"rafamadriz/friendly-snippets",
		config = function()
			require("luasnip.loaders.from_vscode").lazy_load()
			require("luasnip.loaders.from_lua").lazy_load({ paths = vim.fn.stdpath("config") .. "/lua/snippets/" })

			local ls = require("luasnip")

			local options = {
				history = true,
				updateevents = "TextChanged,TextChangedI",
				enable_autosnippets = true,
			}

			ls.config.set_config(options)
			ls.config.setup({ store_selection_keys = "<Tab>" })
		end,
	},
}
