return {
  name = "neo-option.nvim",
  config = function()
    require("neo-option").setup({
      -- autowrite = false,
      -- clipboard = { "unnamedplus" },
      -- updatetime = 500,
      -- termguicolors = true,
      -- history = 500,
      -- showcmd = true,
      -- title = true,
      -- titlestring = "MuHuiXueLuoAnPoQing",
      -- showmode = false,
      -- cmdheight = 1,
      -- autoindent = true,
      -- cindent = true,
      -- smartindent = true,
      -- winwidth = 2,
      -- winaltkeys = "no",
      -- statusline = "%<%f %{luaeval('vim.api.nvim_get_mode().mode')}",

      -- 禁止 number column 和 relative number column
      -- 使用 statuscolumn 替代
      -- number = true,
      -- numberwidth = 0,
      -- relativenumber = true,

      -- hlsearch = true,
      -- incsearch = true,
      -- ignorecase = true,
      -- smartcase = true,
      -- concealcursor = {},
      -- cursorline = false,
      --
      -- updatetime = 100,
      -- 0: never
      -- 1: only if there are at least two tab pages
      -- 2: always
      -- showtabline = 1,
      -- tabline = "%!v:lua.custom_tabline()",

      -- linebreak = false,
      -- ruler = true,
      -- virtualedit = { "none" },
      -- wrap = false,
      -- showbreak = "󱞩 ",
      -- scrolloff = 0,
      -- splitright = true,
      -- splitbelow = true,
      -- swapfile = false,
      -- backup = false,
      -- undofile = true,
      -- timeout = false,
      -- --imdisable = true,
      -- -- 是否自动切换工作目录
      -- -- autochdir = true,
      -- autoread = true,
      -- signcolumn = "no",
      -- signcolumn = "yes:2",
      -- laststatus = 3,

      -- tabstop = 2,
      -- softtabstop = 2,
      -- shiftwidth = 2,
      -- expandtab = true,
      -- smarttab = true,

      -- display = { "truncate" },
      -- conceallevel = 0,
      -- colorcolumn = "78",
      -- textwidth = 80,

      -- list = true,
      -- inccommand = "split",
      listchars = {
        -- eol = "",
        -- precedes = "⭆",
        -- space = "·",
        extends = "⭆",
        -- trail = "»",

        -- lead = "·",
        -- multispace = "",
        trail = "·",
        -- tab = "",
        tab = "󰌥󰌒",
        -- tab = "󰞓󰞔",
        -- tab = "󰞓󰁔",

        -- multispace = "    │",
      },
      -- fillchars = {
      --   vert = "│",
      --   horiz = "─",
      --   fold = " ",
      --   foldopen = "",
      --   foldsep = " ",
      --   foldclose = "",
      -- },
      -- formatoptions = {
      --   j = true,
      --   c = true,
      --   r = true,
      --   o = true,
      --   q = true,
      --   l = true,
      --   ["/"] = true,
      -- },
      -- statuscolumn = "%s %{v:lnum} %{v:relnum}",

      -- foldcolumn = "auto",
      -- foldmethod = "expr",
      -- foldexpr = "v:lua.vim.treesitter.foldexpr()",
      -- foldenable = true, -- 打开文件时启用折叠
      -- foldlevel = 99, -- 默认展开所有
      -- foldlevelstart = 99, -- 打开文件时不折叠
      -- foldnestmax = 3, -- 最大嵌套折叠层数
      -- foldtext = "v:lua.custom_foldtext()",
      -- pumheight = 8,
      -- matchpairs = function(v)
      --   v.append({ "【:】", "<:>", "《:》", "（:）", "`:`" })
      -- end,
      -- helplang = function(v)
      --   v.prepend({ "cn" })
      -- end,
    })
  end,
}
