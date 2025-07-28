local function toggle()
	local harpoon = require("harpoon")
	local fzf = require("fzf-lua")
	local list = harpoon:list()
	local items = {}
	for i = 1, list:length() do
		local item = list:get(i)
		if item and item.value and item.value ~= "" then
			table.insert(items, string.format("%d: %s", i, item.value)) -- skip empty lines if deletion didn't functional properly
		end
	end
	fzf.fzf_exec(items, {
		prompt = "Harpoon Files> ",
		winopts = {
			width = 0.4,
			height = 0.4,
		},

		fzf_opts = {
			["--preview"] = "bat --style=numbers --color=always $(echo {} | sed 's/^\\([0-9]\\+\\): //')",
		},
		actions = {
			["default"] = function(selected)
				local idx = tonumber(selected[1]:match("^(%d+):"))
				if idx then
					list:select(idx)
				end
			end,
			["ctrl-d"] = function(selected)
				local idx = tonumber(selected[1]:match("^(%d+):"))
				if idx then
					local item = list:get(idx)
					list:remove(item)
				end
			end,
		},
	})
end

return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	keys = {
		{
			"<leader>ho",
			function()
				toggle()
			end,
		},
		{
			"<leader>ha",
			function()
				require("harpoon"):list():add()
			end,
		},
		{
			"<leader>h1",
			function()
				require("harpoon"):list():select(1)
			end,
		},
		{
			"<leader>h2",
			function()
				require("harpoon"):list():select(2)
			end,
		},
		{
			"<leader>h3",
			function()
				require("harpoon"):list():select(3)
			end,
		},
		{
			"<leader>h4",
			function()
				require("harpoon"):list():select(4)
			end,
		},
		{
			"<leader>h5",
			function()
				require("harpoon"):list():select(5)
			end,
		},
		{
			"<leader>hp",
			function()
				require("harpoon"):list():prev()
			end,
		},
		{
			"<leader>hn",
			function()
				require("harpoon"):list():next()
			end,
		},
	},
	config = function()
		local harpoon = require("harpoon")
		harpoon:setup()
		vim.keymap.set("n", "<C-F3>", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end)
	end,
}

-- local conf = require("telescope.config").values

-- local function toggle_telescope(harpoon_files)
--   local file_paths = {}
--   for _, item in ipairs(harpoon_files.items) do
--     table.insert(file_paths, item.value)
--   end
--
--   require("telescope.pickers")
--       .new({}, {
--         prompt_title = "Harpoon",
--         finder = require("telescope.finders").new_table({
--           results = file_paths,
--         }),
--         previewer = conf.file_previewer({}),
--         sorter = conf.generic_sorter({}),
--       })
--       :find()
-- end
