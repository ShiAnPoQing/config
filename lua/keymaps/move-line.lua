local move_line = require("custom.plugins.move-line")

return {
	-- move line(s): Down
	["<C-down>"] = {
		{
			function()
				move_line.move_line("down")
				require("repeat").Record(function()
					move_line.move_line("down")
				end)
			end,
			{ "n", "i", "x" },
		},
	},
	-- move line(s): Up
	["<C-up>"] = {
		{
			function()
				move_line.move_line("up")
				require("repeat").Record(function()
					move_line.move_line("up")
				end)
			end,
			{ "n", "i", "x" },
		},
	},
}
