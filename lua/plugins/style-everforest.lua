-- style
return {
	"sainnhe/everforest",
	lazy = false,
	enabled = false,
	priority = 1000,
	config = function()
		-- Optionally configure and load the colorscheme
		-- directly inside the plugin declaration.
		vim.opt.background = "light"
		vim.g.everforest_enable_italic = true
		vim.g.everforest_background = "soft"
		vim.cmd.colorscheme("everforest")
	end,
}
