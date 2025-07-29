local M = {}

local Key = require("custom.plugins.magic.key")
local Keyword = require("custom.plugins.magic.magic-keyword.keyword")
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
	local clean = function()
		Line_hl:del_hl()
		Key:clean()
		Keyword:clean()
	end

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
		Key:register({
			callback = function()
				opts.callback(line, start_col, end_col)
				clean()
			end,
			one_key = {
				set_extmark = function(opts)
					vim.api.nvim_buf_set_extmark(0, opts.ns_id, line, start_col, {
						virt_text_pos = "overlay",
						virt_text = { { opts.key, "CustomMagicNextKeyInVisual" } },
					})
					vim.api.nvim_buf_set_extmark(0, opts.ns_id, line, start_col, {
						end_col = end_col,
						hl_group = "Visual",
					})
				end,
			},
			two_key = {
				set_extmark = function(opts1, opts2)
					vim.api.nvim_buf_set_extmark(0, opts1.ns_id, line, start_col, {
						virt_text_pos = "overlay",
						virt_text = { { opts1.key, "CustomMagicNextKey1InVisual" } },
					})
					if end_col - start_col ~= 1 then
						vim.api.nvim_buf_set_extmark(0, opts2.ns_id, line, start_col + 1, {
							virt_text_pos = "overlay",
							virt_text = { { opts2.key, "CustomMagicNextKey2InVisual" } },
						})
					end
					vim.api.nvim_buf_set_extmark(0, opts2.ns_id, line, start_col, {
						end_col = end_col,
						hl_group = "Visual",
					})
				end,
				reset_extmark = function(opts)
					vim.api.nvim_buf_set_extmark(0, opts.ns_id, line, start_col, {
						virt_text_pos = "overlay",
						virt_text = { { opts.key, "CustomMagicNextKeyInVisual" } },
					})
					vim.api.nvim_buf_set_extmark(0, opts.ns_id, line, start_col, {
						end_col = end_col,
						hl_group = "Visual",
					})
				end,
			},
		})
	end)

	Key:ready_on_key(function()
		clean()
	end)
end

return M
