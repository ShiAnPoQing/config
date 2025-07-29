return {
	dir = vim.fn.stdpath("config") .. "/lua/custom/plugins/magic",
	name = "magic",
	keys = {
		{
			"0vwi",
			function()
				require("custom.plugins.magic").magic_visual_keyword({
					keyword = "word_inner",
				})
			end,
		},
		{
			"0vwo",
			function()
				require("custom.plugins.magic").magic_visual_keyword({
					keyword = "word_outer",
				})
			end,
		},
		{
			"0vWi",
			function()
				require("custom.plugins.magic").magic_visual_keyword({
					keyword = "WORD_inner",
				})
			end,
		},
		{
			"0vWo",
			function()
				require("custom.plugins.magic").magic_visual_keyword({
					keyword = "WORD_outer",
				})
			end,
		},
		{
			"0ywi",
			function()
				require("custom.plugins.magic").magic_yank_keyword({
					keyword = "word_inner",
				})
			end,
		},
		{
			"0ywo",
			function()
				require("custom.plugins.magic").magic_yank_keyword({
					keyword = "word_outer",
				})
			end,
		},
		{
			"0yWi",
			function()
				require("custom.plugins.magic").magic_yank_keyword({
					keyword = "WORD_inner",
				})
			end,
		},
		{
			"0yWo",
			function()
				require("custom.plugins.magic").magic_yank_keyword({
					keyword = "WORD_outer",
				})
			end,
		},

		{
			"0dwi",
			function()
				require("custom.plugins.magic").magic_delete_keyword({
					keyword = "word_inner",
				})
			end,
		},
		{
			"0dwo",
			function()
				require("custom.plugins.magic").magic_delete_keyword({
					keyword = "word_outer",
				})
			end,
		},
		{
			"0dWi",
			function()
				require("custom.plugins.magic").magic_delete_keyword({
					keyword = "WORD_inner",
				})
			end,
		},
		{
			"0dWo",
			function()
				require("custom.plugins.magic").magic_delete_keyword({
					keyword = "WORD_outer",
				})
			end,
		},
		{
			"0cwi",
			function()
				require("custom.plugins.magic").magic_change_keyword({
					keyword = "word_inner",
				})
			end,
		},
		{
			"0cwo",
			function()
				require("custom.plugins.magic").magic_change_keyword({
					keyword = "word_outer",
				})
			end,
		},
		{
			"0cWi",
			function()
				require("custom.plugins.magic").magic_change_keyword({
					keyword = "WORD_inner",
				})
			end,
		},
		{
			"0cWo",
			function()
				require("custom.plugins.magic").magic_change_keyword({
					keyword = "WORD_outer",
				})
			end,
		},
		{
			"0cr",
			function()
				vim.ui.input({ prompt = ">修改>正则匹配: " }, function(input)
					require("custom.plugins.magic").magic_change_keyword({
						keyword = input,
					})
				end)
			end,
		},
		{
			"0dr",
			function()
				vim.ui.input({ prompt = ">删除>正则匹配: " }, function(input)
					require("custom.plugins.magic").magic_delete_keyword({
						keyword = input,
					})
				end)
			end,
		},
		{
			"0vr",
			function()
				vim.ui.input({ prompt = ">选中>正则匹配: " }, function(input)
					require("custom.plugins.magic").magic_visual_keyword({
						keyword = input,
					})
				end)
			end,
		},
		{
			"0yr",
			function()
				vim.ui.input({ prompt = ">复制>正则匹配: " }, function(input)
					require("custom.plugins.magic").magic_yank_keyword({
						keyword = input,
					})
				end)
			end,
		},
		{
			"0k",
			function()
				require("custom.plugins.magic.magic-move").magic_line_move("up")
			end,
		},
		{
			"0j",
			function()
				require("custom.plugins.magic.magic-move").magic_line_move("down")
			end,
		},
	},
	config = function(opt)
		require("custom.plugins.magic").setup()
	end,
}
