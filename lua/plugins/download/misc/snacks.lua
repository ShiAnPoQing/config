return {
  "folke/snacks.nvim",
  -- lazy = false,
  priority = 1000,
  key = {
    ["<leader>e"] = {
      function()
        Snacks.explorer()
      end,
      "n",
      desc = "File Explorer",
    },
    ["<leader>,"] = {
      function()
        Snacks.picker.buffers()
      end,
      "n",
      desc = "Buffers",
    },
    ["<leader>sf"] = {
      function()
        Snacks.picker.pick("files")
      end,
      "n",
      desc = "Snacks pick files",
    },
    ["<leader>sh"] = {
      function()
        Snacks.picker.pick("help")
      end,
      "n",
      desc = "Snacks pick help",
    },
    ["<leader>sk"] = {
      function()
        Snacks.picker.pick("keymaps")
      end,
      "n",
      desc = "Snacks pick keymaps",
    },
    ["<leader>sj"] = {
      function()
        Snacks.picker.pick("jumps")
      end,
      "n",
      desc = "Snacks pick jumps",
    },
  },
  config = function()
    require("snacks").setup({
      bigfile = { enabled = true },
      dashboard = {
        enabled = true,
        preset = {
          header = [[
██████╗ ██████╗  ██████╗ ██╗  ██╗███████╗███╗   ██╗███████╗██╗   ██╗███╗   ██╗███╗   ██╗██╗   ██╗
██╔══██╗██╔══██╗██╔═══██╗██║ ██╔╝██╔════╝████╗  ██║██╔════╝██║   ██║████╗  ██║████╗  ██║╚██╗ ██╔╝
██████╔╝██████╔╝██║   ██║█████╔╝ █████╗  ██╔██╗ ██║███████╗██║   ██║██╔██╗ ██║██╔██╗ ██║ ╚████╔╝ 
██╔══██╗██╔══██╗██║   ██║██╔═██╗ ██╔══╝  ██║╚██╗██║╚════██║██║   ██║██║╚██╗██║██║╚██╗██║  ╚██╔╝  
██████╔╝██║  ██║╚██████╔╝██║  ██╗███████╗██║ ╚████║███████║╚██████╔╝██║ ╚████║██║ ╚████║   ██║   
╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═══╝╚══════╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝  ╚═══╝   ╚═╝   
    ]],
        },
        sections = {
          { section = "header" },
          { section = "keys", gap = 1, padding = 1 },
          -- { section = "startup" },
        },
      },
      explorer = { enabled = true },
      indent = { enabled = true, char = "│", animate = { enabled = false } },
      input = {
        enabled = true,
      },
      picker = { enabled = true },
      notifier = { enabled = false },
      quickfile = { enabled = true },
      scope = { enabled = false },
      scroll = { enabled = false },
      -- statuscolumn = { enabled = true },
      words = { enabled = true },
      styles = {
        input = {
          b = {
            completion = true, -- disable blink completions in input
          },
        },
      },
    })
  end,
}
