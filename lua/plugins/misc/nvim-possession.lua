return {
	"gennaro-tedesco/nvim-possession",
	dependencies = {
		"ibhagwan/fzf-lua",
	},
	config = true,
	keys = {
		{
			"<leader><leader>sl",
			function()
				require("nvim-possession").list()
			end,
			desc = "📌list sessions",
		},
		{
			"<leader><leader>sn",
			function()
				require("nvim-possession").new()
			end,
			desc = "📌create new session",
		},
		{
			"<leader><leader>su",
			function()
				require("nvim-possession").update()
			end,
			desc = "📌update current session",
		},
		{
			"<leader><leader>sd",
			function()
				require("nvim-possession").delete()
			end,
			desc = "📌delete selected session",
		},
	},
}
