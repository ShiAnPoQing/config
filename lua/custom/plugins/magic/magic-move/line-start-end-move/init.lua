local M = {}

local Key = require("custom.plugins.magic.key")
local Line_hl = require("custom.plugins.magic.line-highlight")

local function get_col(position, line, wininfo)
	local leftcol = wininfo.leftcol
	local rightcol = leftcol + wininfo.width - wininfo.textoff
	local width = wininfo.width - wininfo.textoff

	local col
	local cursor_col

	if position == 1 then
		local l = vim.api.nvim_buf_get_lines(0, line - 1, line, false)[1] or ""
		if #l == 0 then
			col = 0 - leftcol
			cursor_col = 0
		else
			col = l:find("%S") - 1 - leftcol
			cursor_col = l:find("%S") - 1
		end
	elseif position == 2 then
		local l = vim.api.nvim_buf_get_lines(0, line - 1, line, false)[1]
		local displaywidth = vim.fn.strdisplaywidth(l)

		if #l == 0 then
			col = 0 - leftcol
			cursor_col = 0
		else
			if displaywidth > rightcol then
				col = width - 1
			else
				col = displaywidth - leftcol - 1
			end
			cursor_col = #l - 1
		end
	end

	return col, cursor_col
end

--- @class MagicLineStartEndMoveOpts
--- @field position 1|2

--- @param opts MagicLineStartEndMoveOpts
function M.magic_line_start_end_move(opts)
	local wininfo = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
	local topline = wininfo.topline
	local botline = wininfo.botline

	Key:init({
		clean = function()
			Line_hl:del_hl()
		end,
	})
	Line_hl:init(topline, botline)
	Key:compute_key(botline - topline + 1)

	for line = topline, botline do
		local col, cursor_col = get_col(opts.position, line, wininfo)

		Key:register({
			callback = function()
				vim.api.nvim_win_set_cursor(0, { line, cursor_col })
			end,
			one_key = {
				set_extmark = function(opts)
					vim.api.nvim_buf_set_extmark(0, opts.ns_id, line - 1, 0, {
						virt_text_win_col = col,
						virt_text = { { opts.key, "CustomMagicNextKey" } },
					})
				end,
			},
			two_key = {
				set_extmark = function(opts1, opts2)
					vim.api.nvim_buf_set_extmark(0, opts1.ns_id, line - 1, 0, {
						virt_text_win_col = col,
						virt_text = { { opts1.key, "CustomMagicNextKey1" } },
					})

					if col >= wininfo.leftcol then
						vim.api.nvim_buf_set_extmark(0, opts2.ns_id, line - 1, 0, {
							virt_text_win_col = col + 1,
							virt_text = { { opts2.key, "CustomMagicNextKey2" } },
						})
					end
				end,
				reset_extmark = function(opts)
					vim.api.nvim_buf_set_extmark(0, opts.ns_id, line - 1, 0, {
						virt_text_win_col = col,
						virt_text = { { opts.key, "CustomMagicNextKey" } },
					})
				end,
			},
		})
	end

	Key:ready_on_key()
end

return M
