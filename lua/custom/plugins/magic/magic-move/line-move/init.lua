local M = {}
local Key = require("custom.plugins.magic.key")
local Line_hl = require("custom.plugins.magic.line-highlight")

--- @param dir "up" | "down"
function M.magic_line_move(dir)
	local wininfo = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
	local topline = wininfo.topline
	local botline = wininfo.botline
	local cursor = vim.api.nvim_win_get_cursor(0)
	local startline, endline

	if dir == "up" then
		startline = topline
		endline = cursor[1] - 1
	else
		startline = cursor[1] + 1
		endline = botline
	end

	local clean = function()
		Line_hl:del_hl()
		Key:clean()
	end

	Key:init()
	Line_hl:init(startline, endline)
	Key:compute_key(endline - startline + 1)

	for line = startline, endline do
		Key:register({
			callback = function()
				vim.api.nvim_win_set_cursor(0, { line, cursor[2] })
				clean()
			end,
			one_key = {
				set_extmark = function(opts)
					vim.api.nvim_buf_set_extmark(0, opts.ns_id, line - 1, 0, {
						virt_text_win_col = cursor[2],
						virt_text = { { opts.key, "CustomMagicNextKey" } },
					})
				end,
			},
			two_key = {
				set_extmark = function(opts1, opts2)
					vim.api.nvim_buf_set_extmark(0, opts1.ns_id, line - 1, 0, {
						virt_text_win_col = cursor[2],
						virt_text = { { opts1.key, "CustomMagicNextKey1" } },
					})
					vim.api.nvim_buf_set_extmark(0, opts2.ns_id, line - 1, 0, {
						virt_text_win_col = cursor[2] + 1,
						virt_text = { { opts2.key, "CustomMagicNextKey2" } },
					})
				end,
				reset_extmark = function(opts)
					vim.api.nvim_buf_set_extmark(0, opts.ns_id, line - 1, 0, {
						virt_text_win_col = cursor[2],
						virt_text = { { opts.key, "CustomMagicNextKey" } },
					})
				end,
			},
		})
	end

	Key:ready_on_key(function()
		clean()
	end)
end

return M
