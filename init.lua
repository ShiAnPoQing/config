vim.pack.add({ "https://github.com/BrokenSunny/native-packer" })
require("global")
require("command")
require("autocmds")
require("keymaps")
require("test")
require("native-packer").setup({
  require("plugins.download.style"),
  require("plugins.download.style.statuscol"),
  -- require("plugins.download.heirline"),
  require("plugins.local.test.statusline"),
  -- require("plugins.download.style.lualine"),
  require("plugins.local.neo-option"),
  require("plugins.local.native-macro"),
  require("plugins.download.misc.repeat"),
  require("plugins.local.undotree"),
  require("plugins.local.neo-lsp"),
  require("plugins.local.native-diagnostic"),
  require("plugins.local.reasonable-scroll"),
  require("plugins.local.reasonable-screen-move"),
  require("plugins.local.window-swap"),
  require("plugins.local.buffer-swap"),
  require("plugins.download.misc.linefuse"),
  require("plugins.local.move-line"),
  require("plugins.local.move-word"),
  require("plugins.local.cursorline"),
  require("plugins.local.file-details"),
  require("plugins.local.code-action"),
  require("plugins.local.op-register"),
  require("plugins.local.simple-translate"),
  require("plugins.download.misc.lazydev"),
  require("plugins.download.misc.zen"),
  require("plugins.download.snippet.luasnip"),
  require("plugins.download.cmp.blink-cmp"),
  -- require("plugins.download.eye-track"),
  require("plugins.download.fzf"),
  require("plugins.download.format.conform"),
  require("plugins.download.treesitter"),
  -- require("plugins.download.misc.which-key"),
  require("plugins.download.filemanager.oil"),
  require("plugins.download.filemanager.neo-tree"),
  require("plugins.download.misc.autopairs"),
  require("plugins.download.misc.nvim-ts-autotag"),
  require("plugins.download.misc.supermaven"),
  require("plugins.download.misc.grug-far"),
  require("plugins.download.misc.toggleterm"),
  -- require("plugins.download.misc.todo-comments"),
  require("plugins.download.git.gitsigns"),
  require("plugins.download.tmux.vim-tmux-navigator"),
  require("plugins.download.window.winshift"),
  -- require("plugins.download.misc.flash"),
  require("plugins.download.misc.snacks"),
  -- require("plugins.download.misc.trouble"),
  require("plugins.local.neo-winbar"),
  require("plugins.download.tex"),
  require("plugins.download.markdown"),
  require("plugins.download.misc.neotest"),
  -- require("plugins.download.misc.noice"),
  require("plugins.download.misc.outline"),
  require("plugins.local.bufferman"),
  -- require("plugins.local.visual-move"),
  require("plugins.local.test.treesitter-textobject"),
  require("plugins.local.test.eye-track"),
  require("plugins.local.test.eye-track-treesitter"),
  require("plugins.local.test.eye"),
  require("plugins.local.doc"),
  require("plugins.download.misc.ts-comments"),
  require("plugins.download.misc.persistence"),
  require("plugins.download.misc.showkey"),
  require("plugins.download.filemanager.yazi"),
  -- require("plugins.download.ai.copilot"),
})

-- vim.api.nvim_set_hl(0, "Normal", {
--   bg = "#141414",
--   fg = "#808080",
-- })
--
-- vim.api.nvim_set_hl(0, "String", {
--   fg = "#809e80",
-- })
--
-- vim.api.nvim_set_hl(0, "@variable", {
--   fg = "#808080",
-- })
--
-- vim.api.nvim_set_hl(0, "Function", {
--   fg = "#9999ad",
-- })
--
-- vim.api.nvim_set_hl(0, "@keyword", {
--   fg = "#806280",
-- })
--
-- vim.api.nvim_set_hl(0, "@keyword.function", {
--   fg = "#806280",
-- })
--
-- vim.api.nvim_set_hl(0, "@property", {
--   fg = "#816e8c",
-- })
--
-- vim.api.nvim_set_hl(0, "@punctuation.bracket", {
--   fg = "#808080",
-- })
