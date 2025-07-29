return {
	["0vwi"] = {
		function()
			require("custom.plugins.magic-visual.visual-word").magic_visual_word({
				keyword = "word_inner",
			})
		end,
		"n",
	},
	["0vwo"] = {
		function()
			require("custom.plugins.magic-visual.visual-word").magic_visual_word({
				keyword = "word_outer",
			})
		end,
		"n",
	},
	["0vWo"] = {
		function()
			require("custom.plugins.magic-visual.visual-word").magic_visual_word({
				keyword = "WORD_outer",
			})
		end,
		"n",
	},
	["0vWi"] = {
		function()
			require("custom.plugins.magic-visual.visual-word").magic_visual_word({
				keyword = "WORD_inner",
			})
		end,
		"n",
	},
}
