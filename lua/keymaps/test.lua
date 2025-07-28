local utils = require("utils.mark")

return {
	-- ["<F6>"] = {
	--   function()
	--     -- local opt = vim.opt.iskeyword:get()
	--     -- vim.opt.iskeyword = {"@", "48-57", "_", "192-255" }
	--     local reg = vim.regex("\\k\\+")
	--     local matchs = {}
	--     local start_pos = 0
	--     local cursor = vim.api.nvim_win_get_cursor(0)
	--     local cursor_row = cursor[1]
	--     while true do
	--       local start, end_ = reg:match_line(0, cursor_row - 1, start_pos)
	--       if not start then
	--         break
	--       end
	--
	--       local keyword_start = start + start_pos
	--       local keyword_end = end_ + start_pos
	--
	--       table.insert(matchs, {
	--         keyword_start = keyword_start,
	--         keyword_end = keyword_end
	--       })
	--
	--       local ns_id = vim.api.nvim_create_namespace("custom-keyword")
	--       vim.api.nvim_buf_set_extmark(0, ns_id, cursor_row - 1, keyword_start, {
	--         end_row = cursor[1] - 1,
	--         end_col = keyword_end,
	--         hl_group = "Search"
	--       })
	--
	--       print(vim.api.nvim_buf_get_text(0, cursor_row - 1, keyword_start, cursor_row - 1, keyword_end, {})[1])
	--
	--       start_pos = start_pos + end_
	--     end
	--   end,
	--   "n",
	-- },
	["<CR>"] = {
		"<nop>",
		"n",
	},
}
