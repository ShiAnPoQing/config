return {
  "nvim-neotest/neotest",
  depend = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "MisanthropicBit/neotest-busted",
  },
  key = {
    ["<leader>T"] = {
      function()
        require("neotest").run.run(vim.fn.expand("%"))
      end,
      "n",
    },
  },
  config = function()
    require("neotest").setup({
      adapters = {
        -- require("neotest-busted")({
        --   -- Leave as nil to let neotest-busted automatically find busted
        --   busted_command = "busted",
        --   -- -- Do not use nvim to run busted, but run busted directly
        --   -- no_nvim = false,
        --   -- -- Extra arguments to busted
        --   -- busted_args = { "--shuffle-files" },
        --   -- -- List of paths to add to lua path lookups before running
        --   -- -- busted, or a function returning a list of such paths
        --   -- busted_paths = { "my/custom/path/?.lua" },
        --   -- -- List of paths to add to lua cpath lookups before running
        --   -- -- busted, or a function returning a list of such paths
        --   -- busted_cpaths = { "my/custom/path/?.so" },
        --   -- -- Custom config to load via -u to set up testing.
        --   -- -- If nil, will look for a 'minimal_init.lua' file
        --   -- minimal_init = "custom_init.lua",
        --   -- -- Only use a luarocks installation in the project's directory. If
        --   -- -- true, installations in $HOME and global installations will be
        --   -- -- ignored. Useful for isolating the test environment
        --   -- local_luarocks_only = true,
        --   -- -- Find parametric tests
        --   -- parametric_test_discovery = false,
        -- }),
      },
    })
  end,
}
