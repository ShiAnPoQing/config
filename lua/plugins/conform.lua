return {
	"stevearc/conform.nvim",
	enabled = true,
	opts = {},
	config = function()
		local conform = require("conform")
		conform.setup({
			formatters_by_ft = {
				javascript = { "prettier" },
				typescript = { "prettier" },
				javascriptreact = { "prettier" },
				typescriptreact = { "prettier" },
				svelte = { "prettier" },
				css = { "prettier" },
				html = { "prettier" },
				json = { "prettier" },
				yaml = { "prettier" },
				markdown = { "prettier" },
				graphql = { "prettier" },
				liquid = { "prettier" },
				lua = { "stylua" },
				python = { "isort", "black" },
				-- json = { "jq" },
				vue = { "prettier" },
			},

			format_on_save = {
				-- These options will be passed to conform.format()
				timeout_ms = 500,
				lsp_fallback = true,
			},
		})
		require("parse-keymap").addKeymap({
			["<leader>="] = {
				function()
					conform.format({ async = true, lsp_fallback = true })
				end,
				{ "n", "x" },
				{ desc = "Format the current buffer" },
			},
		})
	end,
}
