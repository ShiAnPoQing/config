return {
	["<leader>sl"] = {
		{
			function()
				local S = require("custom.plugins.line-sort")
				S.line_sort("n")
				require("repeat").Record(function()
					S.line_sort("n")
				end)
			end,
			"n",
		},
		{
			function()
				local S = require("custom.plugins.line-sort")
				S.line_sort("v")
				require("repeat").Record(function()
					S.line_sort("v")
				end)
			end,
			"x",
		},
	},

	["Q"] = {
		{ "gwap", { "n" } },
		{ "gw", { "x" } },
	},
}
