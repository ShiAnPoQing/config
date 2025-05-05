return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        run = "make",
        -- build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
      },
    },
    config = function()
      require("telescope").setup({
        defaults = {
          mappings = {
            i = {
              ["<C-h>"] = "which_key",
              ["<M-v>"] = require("telescope.actions").select_vertical,
            },
          },
          file_ignore_patterns = {
            "node_modules",
          },
          layout_config = {
            vertical = { width = 0.5 },
          },
        },
        pickers = {},
        extensions = {
          -- fzf = {
          -- 	fuzzy = true, -- false will only do exact matching
          -- 	override_generic_sorter = true, -- override the generic sorter
          -- 	override_file_sorter = true, -- override the file sorter
          -- 	case_mode = "smart_case", -- or "ignore_case" or "respect_case"
          -- },
        },
      })

      local builtin = require("telescope.builtin")
      local actions = require("telescope.actions")

      require("plugin-keymap").add({
        -- 搜索 单词 拼写建议
        ["<leader>ss"] = {
          function()
            require("telescope.builtin").spell_suggest(require("telescope.themes").get_dropdown({
              previewer = false,
            }))
          end,
          "n",
          { desc = "[S]earch [S]pelling suggestions" },
        },
        ["<leader>z"] = {
          function()
            builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
              previewer = false,
            }))
          end,
          "n",
          { desc = "[Z] Fuzzily search in current buffer]" },
        },
        ["<leader>ff"] = { builtin.find_files, "n", { desc = "[F]ind [F]iles" } },
        ["<leader>fg"] = { builtin.live_grep, "n", { desc = "[F]ind [G]rep" } },
        ["<leader>fb"] = { builtin.buffers, "n", { desc = "[F]ind [B]uffers" } },
        ["<leader>fh"] = { builtin.help_tags, "n" },
        ["<leader>fq"] = { builtin.quickfix, "n" },
        ["<leader>fsh"] = { builtin.search_history, "n" },
        ["<leader>fo"] = { builtin.oldfiles, "n", { desc = "Find Old Files" } },
        ["<leader>fsb"] = { builtin.lsp_document_symbols, "n", { desc = "Find Symbols" } },
        ["<leader>fw"] = { builtin.grep_string, "n", { desc = "Find Word under Cursor" } },
        ["<leader>fr"] = { builtin.resume, "n", { desc = "Resume the previous telescope picker" } },
        ["<leader>fd"] = {
          builtin.diagnostics,
          "n",
          { desc = "Lists Diagnostics for all open buffers or a specific buffe" },
        },
        ["<leader>ft"] = {
          builtin.treesitter,
          "n",
          { desc = "Lists Function names, variables, from Treesitter" },
        },
        ["<leader>bs"] = { builtin.lsp_document_symbols, "n", { desc = "LSP [B]uffer [S]ymbols" } },
        ["<leader>ps"] = { builtin.lsp_workspace_symbols, "n", { desc = "LSP [P]roject [S]ymbols" } },
        ["<leader>lr"] = { builtin.lsp_references, "n", { desc = "[L]SP [R]eference" } },
        ["<leader>bb"] = { builtin.builtin, "n" },
        ["<leader>fc"] = {
          function()
            builtin.colorscheme({
              colors = { "tokyonight-day", "catppuccin-macchiato" },
            })
          end,
          "n",
        },
        ["<leader>sc"] = {
          function()
            builtin.commands(require("telescope.themes").get_dropdown({
              previewer = false,
            }))
          end,
          "n",
        },
        ["<leader>vg"] = { builtin.jumplist, "n", { desc = "[V]im [J]umplist" } },
        ["<leader>vm"] = { builtin.marks, "n", { desc = "[V]im [M]ark" } },
        ["<leader>vk"] = { builtin.keymaps, "n", { desc = "[V]im [K]eymaps" } },
        ["<leader>vo"] = { builtin.vim_options, "n", { desc = "[V]im [O]ptions" } },
      })
      require("telescope").load_extension("fzf")
    end,
  },
}
-- create custom telescope pickers
--   function()
--     local conf = require("telescope.config").values
--
--     require("telescope.pickers").new({}, {
--       prompt_title = "colors",
--       finder = require("telescope.finders").new_table {
--         results = { "red", "green", "blue" }
--       },
--       previewer = conf.file_previewer({}),
--       sorter = conf.generic_sorter({}),
--     }):find()
--   end,
