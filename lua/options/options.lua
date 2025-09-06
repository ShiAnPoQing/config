function MyTabLabel(n)
  local buflist = vim.fn.tabpagebuflist(n)
  local winnr = vim.fn.tabpagewinnr(n)
  local full_path = vim.fn.bufname(buflist[winnr])
  local filename = vim.fn.fnamemodify(full_path, ":t")

  if filename == "" then
    return "[No Name]"
  else
    return filename
  end
end

function _G.MyTabLine()
  local s = ""

  for i = 1, vim.fn.tabpagenr("$") do
    if i == vim.fn.tabpagenr() then
      s = s .. "%#TabLineSel#"
    else
      s = s .. "%#TabLine#"
    end
    s = s .. " " .. MyTabLabel(i) .. " "
  end
  s = s .. "%#TabLineFill#%T"
  return s
end

_G.MyTabLine()

return {
  normal = {
    clipboard = { "unnamedplus" },
    termguicolors = true,
    history = 500,
    showcmd = true,
    title = true,
    titlestring = "MuHuiXueLuoAnPoQing -neovim",
    showmode = true,
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
    concealcursor = {},

    updatetime = 100,
    -- 0: never
    -- 1: only if there are at least two tab pages
    -- 2: always
    showtabline = 1,
    tabline = "%!v:lua.MyTabLine()",

    linebreak = false,
    ruler = true,
    virtualedit = { "all" },
    wrap = false,
    scrolloff = 0,
    splitright = true,
    splitbelow = true,
    -- cursorline = true,
    swapfile = false,
    backup = false,
    undofile = true,
    timeout = false,
    --imdisable = true,
    -- 是否自动切换工作目录
    -- autochdir = true,
    autoread = true,
    foldcolumn = "0",
    -- signcolumn = "no",
    signcolumn = "yes:1",
    -- signcolumn = "yes:2",
    laststatus = 3,

    tabstop = 2,
    softtabstop = 2,
    shiftwidth = 2,
    expandtab = true,
    smarttab = true,

    display = { "truncate" },
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
    formatoptions = {
      j = true,
      c = true,
      r = true,
      o = true,
      q = true,
      l = true,
      ["/"] = true,
    },
    foldmethod = "indent",
    -- foldexpr = "nvim_treesitter#foldexpr()",
    foldenable = false,
    pumheight = 8,
    append = {
      matchpairs = { "【:】", "<:>", "《:》", "（:）", "`:`" },
    },
  },
}
