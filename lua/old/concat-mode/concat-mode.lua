return {
	dir = vim.fn.stdpath("config") .. "/lua/custom/plugins/concat-mode",
	name = "concat-mode",
	cmd = { "ConcatMode" },
	config = function(opt)
		require("custom.plugins.concat-mode").setup()
	end,
}
