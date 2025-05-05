local M = {}
local snippets_by_filetype = {
	lua = {
		{
			trigger = "func?t?i?o?n?",
			body = [[
function $1($2) 
$3
end$4
]],
			regTrig = true,
		},
	},
}

function M.get_buf_snips()
	local ft = vim.bo.filetype
	local snips = {}

	if ft and snippets_by_filetype[ft] then
		vim.list_extend(snips, snippets_by_filetype[ft])
	end

	return snips
end

M.cache = {}

function M.isExpandable()
	local cursor = vim.api.nvim_win_get_cursor(0)
	local text = vim.api.nvim_buf_get_text(0, cursor[1] - 1, 0, cursor[1] - 1, cursor[2], {})[1]
	local trigger = text:match("(%w+)$")
	local ft = vim.bo.filetype
	local result = nil
	local clearTrigger = function()
		local newText = text:gsub("(%w+)$", "")
		vim.api.nvim_buf_set_text(0, cursor[1] - 1, 0, cursor[1] - 1, cursor[2], { newText })
	end

	if trigger == nil then
		return result
	end

	for _, snippet in ipairs(snippets_by_filetype[ft]) do
		if snippet.regTrig then
			if trigger:match(snippet.trigger) then
				result = function()
					clearTrigger()
					vim.snippet.expand(snippet.body)
				end
			end
		else
			if snippet.trigger == trigger then
				result = function()
					clearTrigger()
					vim.snippet.expand(snippet.body)
				end
			end
		end
	end

	return result
end

function M.expand(input)
	vim.snippet.expand(input)
end

return M
