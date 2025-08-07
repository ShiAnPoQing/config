vim.g.mapleader = ";"
require("command")
require("plugin-options").setup({
  paths = {
    "options/options",
    "options/typescript",
    "options/markdown",
  },
})
require("repeat").setup()
local Keymap = require("plugin-keymap").setup()
require("lazy-setup")
require("lazy").setup({
  require("plugins.snippet.luasnip"),
  require("plugins.cmp.blank-cmp"),
  -- require("plugins.lsp.lsp-config"),
  require("plugins.lsp.tiny-inline-diagnostic"),
  require("plugins.format.conform"),
  require("plugins.treesitter.treesitter"),
  -- require("plugins.treesitter.nvim-treesitter-context"),
  -- require("plugins.telescope.telescope"),
  require("plugins.fzf.fzf-lua"),
  require("plugins.tex.vimtex"),
  require("plugins.markdown.markdown-preview"),
  require("plugins.markdown.render-markdown"),
  require("plugins.filemanager.neo-tree"),
  require("plugins.filemanager.yazi"),
  require("plugins.filemanager.oil-nvim"),
  require("plugins.code.aerial"),
  -- require("plugins.code.windsurf"),
  require("plugins.code.supermaven"),
  require("plugins.code.typescript-tool"),
  require("plugins.code.twilight"),
  require("plugins.tmux.vim-tmux-navigator"),
  require("plugins.window.winshift"),

  -- require("plugins-auto.harpoon"),
  require("plugins.misc.toggle-term"),
  require("plugins.misc.grug-far"),
  require("plugins.misc.flash"),
  require("plugins.misc.autopairs"),
  require("plugins.misc.nvim-ts-autotag"),
  -- require("plugins.misc.augment"),
  require("plugins.misc.zen-mode"),
  require("plugins.misc.colorizer"),
  require("plugins.misc.todo-comments"),
  require("plugins.misc.hop"),
  require("plugins.misc.undotree"),
  require("plugins.misc.numb"),
  require("plugins.misc.nvim-possession"),
  -- require("plugins.misc.harpoon"),
  require("plugins.misc.showkey"),

  require("plugins.git.gitsigns"),

  -- require("plugins.style.lualine"),
  -- require("plugins.style.dashboard-nvim"),
  -- require("plugins.style.barbar"),
  -- require"plugins.style.alpha-nvim",
  -- require("plugins.style.theme.material"),
  -- require("plugins.style.theme.moonfly"),
  -- require("plugins.style.theme.gruvbox"),
  require("plugins.style.theme.vague"),
  -- require("plugins.style.theme.kanagawa"),
  -- require("plugins.style.theme.tokyonight"),
  -- require("plugins.style.theme.catppuccin"),
  -- require("plugins.style.theme.colorbuddy"),
  -- require("plugins.style.theme.everforest"),
  -- require("plugins.style.theme.gruvbox-material"),
  -- require("plugins.style.theme.melange"),
  -- require("plugins.style.theme.night-owl"),
  -- require("plugins.style.theme.nightfox"),
  -- require("plugins.style.theme.nord"),
  -- require("plugins.style.theme.nordic"),
  -- require("plugins.style.theme.onedarkpro"),
  -- require("plugins.style.theme.onenord"),
  -- require("plugins.style.theme.rose-pine-neovim"),

  -- require("plugins.custom.win-action"),
  require("plugins.custom.lsp"),
  require("plugins.custom.show-file-info"),
  require("plugins.custom.magic"),
})

require("test")

Keymap.add({
  -- tmux fixed
  ["<F32>"] = {
    { "<Del>", { "i" } },
    { "lxh", "n" },
  },
  -- tmux fixed
  ["<F6>"] = {
    function()
      require("custom.plugins.move-col-center").move_col_center("left")
    end,
    "n",
  },
  -- tmux fixed
  ["<F31>"] = { "<Left><C-o>diw", { "i" } },

  [";x"] = {
    function()
      require("test.test").test()
    end,
    "n",
    { filetype = "javascript" },
  },
  [";;cf"] = {
    function()
      require("test.typescript_exchange_function").test()
    end,
    "n",
  },
  [";;a"] = {
    function()
      require("utils.get-window-size").get_window_size()
    end,
    "n",
  },
  [";;b"] = {
    function()
      local current_win = vim.api.nvim_get_current_win()
      local size = require("utils.get-window-size").get_window_size(current_win)
      local width = size.width + 5
      require("utils.set-window-size").set_window_size({
        win_id = current_win,
        width = width,
      })
    end,
    "n",
  },
  [";fd"] = {
    "<cmd>FzFDirectories<CR>",
    "n",
  },
})

vim.keymap.del("x", "in")

-- vim.cmd([[
--   let g:augment_workspace_folders = ['~/Learn']
-- ]])
--
