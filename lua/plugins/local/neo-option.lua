local function specificity(name)
  return #vim.split(name, ".", { plain = true })
end

local function fold_virt_text(result, start_text, lnum)
  local text = ""
  local hl
  for i = 1, #start_text do
    local char = start_text:sub(i, i)
    local new_hl = "@text"

    -- local sem_tokens = vim.lsp.semantic_tokens.get_at_pos(0, lnum, i)
    -- if sem_tokens and #sem_tokens > 0 then
    --   new_hl = "@" .. sem_tokens[1].type
    -- else
    local captures = vim.treesitter.get_captures_at_pos(0, lnum, i - 1)
    if #captures > 0 then
      local top = captures[1]
      local top_priority = (top.metadata and tonumber(top.metadata.priority)) or 0
      local top_spec = specificity(top.capture)
      for _, cap in ipairs(captures) do
        local raw_prio = cap.metadata and cap.metadata.priority
        local prio = tonumber(raw_prio) or 0
        if prio > top_priority then
          top = cap
          top_priority = prio
        elseif prio == top_priority and top_spec < specificity(cap.capture) then
          top = cap
          top_priority = prio
        end
      end
      new_hl = "@" .. top.capture
    end
    -- end

    if new_hl then
      if new_hl ~= hl then
        table.insert(result, { text, hl })
        text = ""
        hl = nil
      end
      text = text .. char
      hl = new_hl
    else
      text = text .. char
    end
  end
  table.insert(result, { text, hl })
end

function _G.custom_foldtext()
  local start_text = vim.fn.getline(vim.v.foldstart):gsub("\t", string.rep(" ", vim.o.tabstop))
  local nline = vim.v.foldend - vim.v.foldstart
  local result = {}
  fold_virt_text(result, start_text, vim.v.foldstart - 1)
  table.insert(result, { "  ", nil })
  table.insert(result, { "󰛁  " .. nline .. " lines folded", "@comment" })
  return result
end

function MyTabLabel(n)
  local hl = vim.api.nvim_get_hl(0, { name = "TabLineSel" })
  vim.api.nvim_set_hl(0, "TabLineError", {
    fg = "#ff5555",
    bg = hl.bg,
  })
  local buflist = vim.fn.tabpagebuflist(n)
  local winnr = vim.fn.tabpagewinnr(n)
  local buf = buflist[winnr]
  local full_path = vim.fn.bufname(buflist[winnr])
  local filename = vim.fn.fnamemodify(full_path, ":t")
  local modified = vim.api.nvim_get_option_value("modified", { buf = buf })
  local error_count = vim.diagnostic.count(buf, {
    severity = vim.diagnostic.severity.ERROR,
  })[vim.diagnostic.severity.ERROR]
  local label = filename
  if label == "" then
    return "[No Name]"
  end
  if modified then
    label = label .. " ●"
  end
  if error_count and error_count > 0 then
    label = label .. " %#TabLineError#" .. " "
  end
  label = label
  return label
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
  name = "neo-option.nvim",
  config = function()
    require("neo-option").setup({
      autowrite = false,
      clipboard = { "unnamedplus" },
      updatetime = 500,
      termguicolors = true,
      history = 500,
      showcmd = true,
      title = true,
      titlestring = "MuHuiXueLuoAnPoQing",
      showmode = false,
      cmdheight = 1,
      autoindent = true,
      cindent = true,
      smartindent = true,
      winwidth = 2,
      winaltkeys = "no",
      -- statusline = "%<%f %{luaeval('vim.api.nvim_get_mode().mode')}",

      -- 禁止 number column 和 relative number column
      -- 使用 statuscolumn 替代
      number = true,
      -- numberwidth = 0,
      relativenumber = true,

      hlsearch = true,
      incsearch = true,
      ignorecase = true,
      smartcase = true,
      concealcursor = {},
      cursorline = false,
      --
      -- updatetime = 100,
      -- 0: never
      -- 1: only if there are at least two tab pages
      -- 2: always
      showtabline = 1,
      tabline = "%!v:lua.MyTabLine()",

      linebreak = false,
      ruler = true,
      virtualedit = { "none" },
      wrap = false,
      scrolloff = 0,
      splitright = true,
      splitbelow = true,
      swapfile = false,
      backup = false,
      undofile = true,
      timeout = false,
      -- --imdisable = true,
      -- -- 是否自动切换工作目录
      -- -- autochdir = true,
      autoread = true,
      -- signcolumn = "no",
      signcolumn = "yes:2",
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

      list = true,
      -- inccommand = "split",
      listchars = {
        -- eol = "",
        -- space = " ",
        extends = "⭆",
        -- trail = "»",
        trail = "·",
        tab = ">-",
        -- multispace = "   │",
      },
      fillchars = {
        vert = "│",
        horiz = "─",
        fold = " ",
        foldopen = "",
        foldsep = " ",
        foldclose = "",
      },
      formatoptions = {
        j = true,
        c = true,
        r = true,
        o = true,
        q = true,
        l = true,
        ["/"] = true,
      },
      -- statuscolumn = "%s %{v:lnum} %{v:relnum}",

      foldcolumn = "auto",
      foldmethod = "expr",
      foldexpr = "v:lua.vim.treesitter.foldexpr()",
      foldenable = true, -- 打开文件时启用折叠
      foldlevel = 99, -- 默认展开所有
      foldlevelstart = 99, -- 打开文件时不折叠
      foldnestmax = 3, -- 最大嵌套折叠层数
      foldtext = "v:lua.custom_foldtext()",
      pumheight = 8,
      matchpairs = function(v)
        v.append({ "【:】", "<:>", "《:》", "（:）", "`:`" })
      end,
      helplang = function(v)
        v.prepend({ "cn" })
      end,
    })
  end,
}
