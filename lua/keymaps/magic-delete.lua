return {
	["0dwi"] = {
		function()
			require("custom.plugins.delete.delete-word").magic_delete_word({
				keyword = "word_inner",
			})
		end,
		"n",
	},
	["0dwo"] = {
		function()
			require("custom.plugins.delete.delete-word").magic_delete_word({
				keyword = "word_outer",
			})
		end,
		"n",
	},
	["0dWo"] = {
		function()
			require("custom.plugins.delete.delete-word").magic_delete_word({
				keyword = "WORD_outer",
			})
		end,
		"n",
	},
	["0dWi"] = {
		function()
			require("custom.plugins.delete.delete-word").magic_delete_word({
				keyword = "WORD_inner",
			})
		end,
		"n",
	},
}
