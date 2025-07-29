local M = {}
local magic_keyword = require("custom.plugins.magic.magic-keyword")

local function set_hl_group()
	local visual_hl = vim.api.nvim_get_hl(0, { name = "Visual" })

	vim.api.nvim_set_hl(0, "CustomMagicNextKey", {
		fg = "#ff007c",
		bg = visual_hl.bg,
	})
	vim.api.nvim_set_hl(0, "CustomMagicNextKey1", {
		fg = "#00dfff",
		bg = visual_hl.bg,
	})
	vim.api.nvim_set_hl(0, "CustomMagicNextKey2", {
		fg = "#2b8db3",
		bg = visual_hl.bg,
	})
	vim.api.nvim_set_hl(0, "CustomMagicUnmatched", {
		fg = "#666666",
	})
end

function M.setup()
	set_hl_group()
end

function M.magic_visual_word(opt)
	magic_keyword.magic_keyword({
		keyword = opt.keyword,
		callback = function(line, start_col, end_col)
			require("utils.mark").set_visual_mark(line + 1, start_col, line + 1, end_col - 1)
			vim.api.nvim_feedkeys("gv", "n", true)
		end,
	})
end

function M.magic_yank_word(opt)
	magic_keyword.magic_keyword({
		keyword = opt.keyword,
		callback = function(line, start_col, end_col)
			vim.fn.setreg("+", vim.api.nvim_buf_get_text(0, line, start_col, line, end_col, {})[1])
		end,
	})
end

function M.magic_delete_word(opt)
	magic_keyword.magic_keyword({
		keyword = opt.keyword,
		callback = function(line, start_col, end_col)
			vim.api.nvim_buf_set_text(0, line, start_col, line, end_col, {})
		end,
	})
end

function M.magic_change_word(opt)
	magic_keyword.magic_keyword({
		keyword = opt.keyword,
		callback = function(line, start_col, end_col)
			require("utils.mark").set_visual_mark(line + 1, start_col, line + 1, end_col - 1)
			vim.api.nvim_feedkeys("gvc", "n", true)
		end,
	})
end

return M
