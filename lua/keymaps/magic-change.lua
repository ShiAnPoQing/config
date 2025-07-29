return {
	["0cwi"] = {
		function()
			require("custom.plugins.magic-change.change-word").magic_change_word({
				keyword = "word_inner",
			})
		end,
		"n",
	},
	["0cwo"] = {
		function()
			require("custom.plugins.magic-change.change-word").magic_change_word({
				keyword = "word_outer",
			})
		end,
		"n",
	},
	["0cWo"] = {
		function()
			require("custom.plugins.magic-change.change-word").magic_change_word({
				keyword = "WORD_outer",
			})
		end,
		"n",
	},
	["0cWi"] = {
		function()
			require("custom.plugins.magic-change.change-word").magic_change_word({
				keyword = "WORD_inner",
			})
		end,
		"n",
	},
}
