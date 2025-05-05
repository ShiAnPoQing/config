local cmp = require("cmp")
local source = {}

local path = vim.fn.expand("~/.config/nvim/lua/custom-cmp/source.json")

local data = vim.fn.json_decode(vim.fn.readfile(path))

source.get_trigger_characters = function()
	return { "*" }
end

source.get_keyword_pattern = function()
	return [[\%(\k\|\.\)\+]]
end

source.complete = function(self, request, callback)
	local input = string.sub(request.context.cursor_before_line, request.offset - 1)
	local prefix = string.sub(request.context.cursor_before_line, 1, request.offset - 1)

	local items = {}

	for _, test in pairs(data) do
		table.insert(items, test)
	end

	callback({
		items = items,
		isIncomplete = true,
	})
end

source.resolve = function(self, completion_item, callback)
	completion_item.documentation = {
		kind = cmp.lsp.MarkupKind.Markdown,
		value = completion_item.data.doc,
	}
	callback(completion_item)
end

return source
