return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require("harpoon")
    harpoon:setup()

    local conf = require("telescope.config").values

    local function toggle_telescope(harpoon_files)
      local file_paths = {}
      for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
      end

      require("telescope.pickers")
          .new({}, {
            prompt_title = "Harpoon",
            finder = require("telescope.finders").new_table({
              results = file_paths,
            }),
            previewer = conf.file_previewer({}),
            sorter = conf.generic_sorter({}),
          })
          :find()
    end

    require("plugin-keymap").add({
      ["<leader>ho"] = {
        function()
          toggle_telescope(harpoon:list())
        end,
        "n",
        { desc = "Open harpoon ui" },
      },
      ["<leader>ha"] = {
        function()
          harpoon:list():add()
        end,
        "n",
      },
      ["<leader>h1"] = {
        function()
          harpoon:list():select(1)
        end,
        "n",
      },
      ["<leader>h2"] = {
        function()
          harpoon:list():select(2)
        end,
        "n",
      },
      ["<leader>h3"] = {
        function()
          harpoon:list():select(3)
        end,
        "n",
      },
      ["<leader>h4"] = {
        function()
          harpoon:list():select(4)
        end,
        "n",
      },
      ["<leader>h5"] = {
        function()
          harpoon:list():select(5)
        end,
        "n",
      },
      ["<leader>hp"] = {
        function()
          harpoon:list():prev()
        end,
        "n",
      },
      ["<leader>hn"] = {
        function()
          harpoon:list():next()
        end,
        "n",
      },
    })

    vim.keymap.set("n", "<C-F3>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
  end,
}
