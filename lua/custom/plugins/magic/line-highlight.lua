local M = {}
function M:init(topline, botline)
	self.topline = topline
	self.botline = botline
	self.ns_id = vim.api.nvim_create_namespace("line-custom")
	self:set_hl()
end

function M:set_hl()
	vim.api.nvim_buf_set_extmark(0, self.ns_id, self.topline - 1, 0, {
		end_row = self.botline,
		hl_group = "CustomMagicUnmatched",
	})
end

function M:del_hl()
	if self.ns_id ~= nil then
		vim.api.nvim_buf_clear_namespace(0, self.ns_id, 0, -1)
		self.ns_id = nil
	end
end

return M
