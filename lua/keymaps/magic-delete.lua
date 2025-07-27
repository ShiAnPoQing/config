return {
	["0dew"] = {
		function()
			require("custom.plugins.delete.delete-word").magic_delete_word({
				keyword = "word_inner",
			})
		end,
		"n",
	},
	["0dww"] = {
		function()
			require("custom.plugins.delete.delete-word").magic_delete_word({
				keyword = "word_outer",
			})
		end,
		"n",
	},
	["0dwW"] = {
		function()
			require("custom.plugins.delete.delete-word").magic_delete_word({
				keyword = "WORD_outer",
			})
		end,
		"n",
	},
	["0deW"] = {
		function()
			require("custom.plugins.delete.delete-word").magic_delete_word({
				keyword = "WORD_inner",
			})
		end,
		"n",
	},
}
