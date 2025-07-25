vim.g.mapleader = ";"
require("plugin-options").setup({
  paths = {
    "options/options",
    "options/typescript",
    "options/markdown",
  }
})
require("repeat").setup()
local Keymap = require("plugin-keymap").setup()
require("lazy-setup")
require("lazy").setup({
  require("plugins.snippet.luasnip"),
  require("plugins.cmp.blank-cmp"),
  require("plugins.lsp.lsp-config"),
  require("plugins.lsp.tiny-inline-diagnostic"),
  require("plugins.format.conform"),
  require("plugins.treesitter.treesitter"),
  -- require("plugins.treesitter.nvim-treesitter-context"),
  require("plugins.telescope.telescope"),
  require("plugins.tex.vimtex"),
  require("plugins.markdown.markdown-preview"),
  require("plugins.markdown.render-markdown"),
  require("plugins.filemanager.neo-tree"),
  require("plugins.filemanager.yazi"),
  require("plugins.code.aerial"),
  require("plugins.tmux.vim-tmux-navigator"),

  require("plugins-auto.toggle-term"),
  require("plugins-auto.flash"),
  require("plugins-auto.winshift"),
  require("plugins-auto.harpoon"),
  require("plugins-auto.grug-far"),
  require("plugins-auto.oil-nvim"),

  require("plugins.misc.autopairs"),
  require("plugins.misc.nvim-ts-autotag"),
  -- require("plugins.misc.augment"),
  require("plugins.misc.zen-mode"),
  require("plugins.misc.colorizer"),
  require("plugins.misc.todo-comments"),
  require("plugins.misc.hop"),
  require("plugins.misc.undotree"),

  require("plugins.git.gitsigns"),

  require("plugins.style.lualine"),
  require("plugins.style.dashboard-nvim"),
  -- require"plugins.style.alpha-nvim",
  -- require("plugins.style.theme.material"),
  require("plugins.style.theme.moonfly"),
  -- require("plugins.style.theme.gruvbox"),
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
  require("plugins.custom.register-control"),
  require("plugins.custom.concat-mode"),
  require("plugins.custom.win-action"),
  require("plugins.custom.show-file-info"),
  require("plugins.custom.word-move"),
})


require("test")

Keymap.add({
  ["<F32>"] = {
    { "<Del>", { "i" } },
    { "lxh",   "n" }
  },
  ["<F31>"] = { "<Left><C-o>diw", { "i" } },
  [";x"] = {
    function()
      require("test.test").test()
    end,
    "n",
    { filetype = "javascript" }
  },
  [";;cf"] = {
    function()
      require("test.typescript_exchange_function").test()
    end,
    "n"
  }
})

vim.cmd([[
  let g:augment_workspace_folders = ['~/Learn']
]])
