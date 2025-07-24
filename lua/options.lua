local M = {}
function M.setup()
  local default_options = {
    clipboard = "unnamedplus",
    termguicolors = true,
    history = 500,
    showcmd = true,
    title = true,
    titlestring = "MuHuiXueLuoAnPoQing -neovim",
    showmode = false,
    cmdheight = 1,
    autoindent = true,
    cindent = true,
    smartindent = true,
    winwidth = 2,
    winaltkeys = "no",

    number = true,
    relativenumber = true,
    hlsearch = true,
    incsearch = true,
    ignorecase = true,
    smartcase = true,

    updatetime = 100,
    -- 0: never
    -- 1: only if there are at least two tab pages
    -- 2: always
    showtabline = 0,

    linebreak = false,

    ruler = true,

    virtualedit = "all",

    wrap = false,

    scrolloff = 0,

    splitright = true,
    splitbelow = true,

    -- cursorline = true,

    swapfile = false,
    undofile = true,

    timeout = false,

    --imdisable = true,

    autochdir = true,

    autoread = true,

    foldcolumn = "0",
    -- signcolumn = "no",
    signcolumn = "yes:1",
    -- signcolumn = "yes:2",
    laststatus = 3,

    shiftwidth = 2,
    tabstop = 2,
    expandtab = true,
    softtabstop = 2,
    smarttab = true,

    display = "truncate",

    conceallevel = 0,

    -- colorcolumn = "72",
    -- textwidth = 80,
    list = false,
    listchars = {
      eol = "«",
      space = "—",
      extends = "⭆",
      trail = "»",
      tab = "| ",
    },

    fillchars = {
      vert = "│",
      horiz = "",
    },
    -- formatoptions = { "o/qwjb" },
    formatoptions = "jcroql/",
    foldmethod = "indent",
    foldexpr = "nvim_treesitter#foldexpr()",
    foldenable = false,
    pumheight = 8
  }

  --vim.opt.whichwrap:append
  vim.opt.matchpairs:append("<:>")
  vim.opt.matchpairs:append("《:》")
  vim.opt.matchpairs:append("【:】")
  vim.opt.matchpairs:append("（:）")

  vim.g.mapleader = ";"

  for k, v in pairs(default_options) do
    vim.opt[k] = v
  end
end

return M
