local M = {}
local Key = require("custom.plugins.magic.key")
local Keyword = require("custom.plugins.magic.keyword")
local Line_hl = require("custom.plugins.magic.line-highlight")

--- @alias KeywordType "word" | "WORD"

--- @class MagicWordMoveOpts
--- @field position 1|2
--- @field type KeywordType

--- @param type KeywordType
local function get_keyword(type)
	local keyword

	if type == "word" then
		keyword = "word_inner"
	else
		keyword = "WORD_inner"
	end

	return keyword
end

local function get_col(position, start_col, end_col)
	local col

	if position == 1 then
		col = start_col
	elseif position == 2 then
		col = end_col - 1
	end

	return col
end

--- @param opts MagicWordMoveOpts
function M.magic_word_move(opts)
	local wininfo = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
	local topline = wininfo.topline
	local botline = wininfo.botline
	local leftcol = wininfo.leftcol
	local rightcol = leftcol + wininfo.width - wininfo.textoff
	local cursor = vim.api.nvim_win_get_cursor(0)

	Key:init({
		clean = function()
			Line_hl:del_hl()
			Keyword:clean()
		end,
	})
	Keyword:init({
		cursor = cursor,
		topline = topline,
		botline = botline,
		leftcol = leftcol,
		rightcol = rightcol,
		keyword = get_keyword(opts.type),
	})
	Line_hl:init(topline, botline)

	Keyword:match_keyword()
	Key:compute_key(Keyword.keyword_count)
	Keyword:set_keyword_callback(function(line, start_col, end_col)
		local col = get_col(opts.position, start_col, end_col)

		Key:register({
			callback = function()
				vim.api.nvim_win_set_cursor(0, { line + 1, col })
			end,
			one_key = {
				set_extmark = function(opts)
					vim.api.nvim_buf_set_extmark(0, opts.ns_id, line, 0, {
						virt_text_win_col = col,
						virt_text = { { opts.key, "CustomMagicNextKey" } },
					})
				end,
			},
			two_key = {
				set_extmark = function(opts1, opts2)
					vim.api.nvim_buf_set_extmark(0, opts1.ns_id, line, 0, {
						virt_text_win_col = col,
						virt_text = { { opts1.key, "CustomMagicNextKey1" } },
					})
					vim.api.nvim_buf_set_extmark(0, opts2.ns_id, line, 0, {
						virt_text_win_col = col + 1,
						virt_text = { { opts2.key, "CustomMagicNextKey2" } },
					})
				end,
				reset_extmark = function(opts)
					vim.api.nvim_buf_set_extmark(0, opts.ns_id, line, 0, {
						virt_text_win_col = col,
						virt_text = { { opts.key, "CustomMagicNextKey" } },
					})
				end,
			},
		})
	end)
	Key:ready_on_key()
end

return M
