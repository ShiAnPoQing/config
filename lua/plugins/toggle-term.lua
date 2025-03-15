return {
	"akinsho/toggleterm.nvim",
	version = "*",
	config = function()
		require("toggleterm").setup({
			open_mapping = [[;tm]],
			close_on_exit = true,
			shell = vim.o.shell,
		})
	end,
}
