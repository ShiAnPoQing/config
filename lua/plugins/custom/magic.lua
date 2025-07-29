return {
	dir = vim.fn.stdpath("config") .. "/lua/custom/plugins/magic",
	name = "magic",
	keys = {
		{
			"0vwi",
			function()
				require("custom.plugins.magic").magic_visual_word({
					keyword = "word_inner",
				})
			end,
		},
		{
			"0vwo",
			function()
				require("custom.plugins.magic").magic_visual_word({
					keyword = "word_outer",
				})
			end,
		},
		{
			"0vWi",
			function()
				require("custom.plugins.magic").magic_visual_word({
					keyword = "WORD_inner",
				})
			end,
		},
		{
			"0vWo",
			function()
				require("custom.plugins.magic").magic_visual_word({
					keyword = "WORD_outer",
				})
			end,
		},
		{
			"0ywi",
			function()
				require("custom.plugins.magic").magic_yank_word({
					keyword = "word_inner",
				})
			end,
		},
		{
			"0ywo",
			function()
				require("custom.plugins.magic").magic_yank_word({
					keyword = "word_outer",
				})
			end,
		},
		{
			"0yWi",
			function()
				require("custom.plugins.magic").magic_yank_word({
					keyword = "WORD_inner",
				})
			end,
		},
		{
			"0yWo",
			function()
				require("custom.plugins.magic").magic_yank_word({
					keyword = "WORD_outer",
				})
			end,
		},

		{
			"0dwi",
			function()
				require("custom.plugins.magic").magic_delete_word({
					keyword = "word_inner",
				})
			end,
		},
		{
			"0dwo",
			function()
				require("custom.plugins.magic").magic_delete_word({
					keyword = "word_outer",
				})
			end,
		},
		{
			"0dWi",
			function()
				require("custom.plugins.magic").magic_delete_word({
					keyword = "WORD_inner",
				})
			end,
		},
		{
			"0dWo",
			function()
				require("custom.plugins.magic").magic_delete_word({
					keyword = "WORD_outer",
				})
			end,
		},
		{
			"0cwi",
			function()
				require("custom.plugins.magic").magic_change_word({
					keyword = "word_inner",
				})
			end,
		},
		{
			"0cwo",
			function()
				require("custom.plugins.magic").magic_change_word({
					keyword = "word_outer",
				})
			end,
		},
		{
			"0cWi",
			function()
				require("custom.plugins.magic").magic_change_word({
					keyword = "WORD_inner",
				})
			end,
		},
		{
			"0cWo",
			function()
				require("custom.plugins.magic").magic_change_word({
					keyword = "WORD_outer",
				})
			end,
		},
	},
	config = function(opt)
		require("custom.plugins.magic").setup()
	end,
}
