return {
	["0ywi"] = {
		function()
			require("custom.plugins.magic-yank.yank-word").magic_yank_word({
				keyword = "word_inner",
			})
		end,
		"n",
	},
	["0ywo"] = {
		function()
			require("custom.plugins.magic-yank.yank-word").magic_yank_word({
				keyword = "word_outer",
			})
		end,
		"n",
	},
	["0yWi"] = {
		function()
			require("custom.plugins.magic-yank.yank-word").magic_yank_word({
				keyword = "WORD_inner",
			})
		end,
		"n",
	},
	["0yWo"] = {
		function()
			require("custom.plugins.magic-yank.yank-word").magic_yank_word({
				keyword = "WORD_outer",
			})
		end,
		"n",
	},
}
