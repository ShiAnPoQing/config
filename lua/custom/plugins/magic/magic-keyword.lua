local M = {}

local Key = require("custom.plugins.magic.key")
local Keyword = require("custom.plugins.magic.keyword")
local Line_hl = require("custom.plugins.magic.line-highlight")

--- @class MagicKeyword
--- @field keyword string
--- @field callback function

--- @param opts MagicKeyword
function M.magic_keyword(opts)
	local wininfo = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
	local topline = wininfo.topline
	local botline = wininfo.botline
	local leftcol = wininfo.leftcol
	local rightcol = leftcol + wininfo.width - wininfo.textoff
	local cursor = vim.api.nvim_win_get_cursor(0)

	Key:init()
	Keyword:init({
		cursor = cursor,
		topline = topline,
		botline = botline,
		leftcol = leftcol,
		rightcol = rightcol,
		keyword = opts.keyword,
	})
	Line_hl:init(topline, botline)

	Keyword:match_keyword()
	Key:compute_key(Keyword.keyword_count)
	Keyword:set_keyword_callback(function(line, start_col, end_col)
		Key:register(line, start_col, end_col, function()
			Line_hl:del_hl()
			opts.callback(line, start_col, end_col)
			Key:clean()
			Keyword:clean()
		end)
	end)
	Key:ready_on_key(function()
		Line_hl:del_hl()
		Key:clean()
		Keyword:clean()
	end)
end

return M
