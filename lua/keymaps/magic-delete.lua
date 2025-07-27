return {
	["0dew"] = {
		function()
			require("custom.plugins.delete.delete-word").magic_delete_word({
				keyword = "word",
			})
		end,
		"n",
	},
	["0dww"] = {
		function()
			require("custom.plugins.delete.delete-word").magic_delete_word({
				keyword = "WORD",
			})
		end,
		"n",
	},
}
