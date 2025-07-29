return {
	["<space>y"] = {
		function()
			require("custom.plugins.register").copy("y")
		end,
		{ "n", "x" },
	},
	["<space>Y"] = {
		function()
			require("custom.plugins.register").copy("Y")
		end,
		{ "n", "x" },
	},
	["<space>p"] = {
		function()
			require("custom.plugins.register").paste("p")
		end,
		{ "n", "x" },
	},
	["<space>P"] = {
		function()
			require("custom.plugins.register").paste("P")
		end,
		{ "n", "x" },
	},
	["<space>d"] = {
		function()
			require("custom.plugins.register").delete("d")
		end,
		{ "n", "x" },
	},
	["<space>D"] = {
		function()
			require("custom.plugins.register").delete("D")
		end,
		{ "n", "x" },
	},
}
