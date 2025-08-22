local M = {}

local function get_colors()
  local color_groups = {
    dark = {
      red0 = "#8f3d3d",
      red1 = "#8f443d",
      red2 = "#8f4b3d",
      red3 = "#8f523d",
      red4 = "#8f583d",
      red5 = "#8f5f3d",

      orange0 = "#8f663d",
      orange1 = "#8f6d3d",
      orange2 = "#8f743d",
      orange3 = "#8f7a3d",
      orange4 = "#8f813d",
      orange5 = "#8f883d",

      yellow0 = "#8f8f3d",
      yellow1 = "#888f3d",
      yellow2 = "#818f3d",
      yellow3 = "#7a8f3d",
      yellow4 = "#748f3d",
      yellow5 = "#6d8f3d",

      yellow_green0 = "#668f3d",
      yellow_green1 = "#5f8f3d",
      yellow_green2 = "#588f3d",
      yellow_green3 = "#528f3d",
      yellow_green4 = "#4b8f3d",
      yellow_green5 = "#448f3d",

      green0 = "#3d8f3d",
      green1 = "#3d8f44",
      green2 = "#3d8f4b",
      green3 = "#3d8f52",
      green4 = "#3d8f58",
      green5 = "#3d8f5f",

      turquoise0 = "#3d8f66",
      turquoise1 = "#3d8f6d",
      turquoise2 = "#3d8f74",
      turquoise3 = "#3d8f7a",
      turquoise4 = "#3d8f81",
      turquoise5 = "#3d8f88",

      cyan_blue0 = "#3d8f8f",
      cyan_blue1 = "#3d888f",
      cyan_blue2 = "#3d818f",
      cyan_blue3 = "#3d7a8f",
      cyan_blue4 = "#3d748f",
      cyan_blue5 = "#3d6d8f",

      indigo0 = "#3d668f",
      indigo1 = "#3d5f8f",
      indigo2 = "#3d588f",
      indigo3 = "#3d528f",
      indigo4 = "#3d4b8f",
      indigo5 = "#3d448f",

      blue0 = "#3d3d8f",
      blue1 = "#443d8f",
      blue2 = "#4b3d8f",
      blue3 = "#523d8f",
      blue4 = "#583d8f",
      blue5 = "#5f3d8f",

      purple0 = "#663d8f",
      purple1 = "#6d3d8f",
      purple2 = "#743d8f",
      purple3 = "#7a3d8f",
      purple4 = "#813d8f",
      purple5 = "#883d8f",

      magenta0 = "#8f3d8f",
      magenta1 = "#8f3d88",
      magenta2 = "#8f3d81",
      magenta3 = "#8f3d7a",
      magenta4 = "#8f3d74",
      magenta5 = "#8f3d6d",

      peach0 = "#8f3d66",
      peach1 = "#8f3d5f",
      peach2 = "#8f3d58",
      peach3 = "#8f3d52",
      peach4 = "#8f3d4b",
      peach5 = "#8f3d44",

      bg1 = "#262A36",
      bg2 = "#191919",
      fg1 = "#969aa3",
    },
    light = {
      black1 = "#c0caf5",
    },
  }
  local bg = vim.o.background
  return color_groups[bg]
end

local function get_groups()
  local colors = get_colors()
  local groups = {
    CustomVisual = { bg = "#262626", reverse = false },
    Normal = { fg = colors.fg1, bg = colors.bg1 }, -- 普通文本
    NormalFloat = { link = "Normal" }, --- 浮动窗口的普通文本
    NormalNC = { link = "Normal" }, -- 非当前窗口的普通文本
    MoreMsg = { link = "Normal" }, -- More Message
    ModeMsg = { link = "Normal" }, -- Mode Message
    LineNr = { fg = "#404040", bg = colors.bg1 }, -- 行号
    Search = { reverse = true }, -- 搜索结果
    IncSearch = { link = "Search" },
    CurSearch = { link = "IncSearch" },
    StatusLine = { bg = colors.bg1, fg = "#404040", reverse = true }, -- 状态栏
    SignColumn = { bg = colors.bg1 }, -- 符号列
    CursorLine = { bg = colors.bg2 }, -- 光标行
    CursorLineNr = { fg = colors.black10 },
    ColorColumn = { bg = colors.black2 },
    Visual = { link = "CustomVisual" },
    VisualNOS = { link = "Visual" },
    TabLineFill = { bg = "#0C0E11" }, -- 标签栏
    TabLine = { link = "TabLineFill" }, -- 非当前标签
    TabLineSel = { fg = "#36BBAC", bg = colors.bg2, bold = true }, -- 当前标签选中
    WarningMsg = { fg = "#F2B33F" },
    Error = { fg = "#C54659" },
    ErrorMsg = { fg = colors.bg1, bg = "#C54659", bold = true },
    MatchParen = { reverse = true },
    -- Conceal = { fg = colors.blue },
    Keyword = { fg = "#937cc0", bold = true },
    Function = { fg = "#7c8dc0", bold = true },
    String = { fg = "#a9c07c" },
    Number = { bg = colors.bg1, fg = "#bf4055" },
    Operator = { fg = colors.fg1 },
    Delimiter = { fg = colors.fg1 },
    Comment = { fg = "#4b4d52" },
    Boolean = { fg = "#bf5540", bold = true },
    Type = { fg = colors.turquoise5, bold = true },
    Constant = { fg = colors.cyan_blue0, bold = true },
    Directory = { fg = "#6a40bf", bold = true },

    -- Underlined = { fg = colors.blue, underline = config.underline }, -- 突出的文本，HTML链接

    ["@variable"] = { fg = colors.fg1 },
    ["@variable.parameter"] = { fg = "#7C9DC0" },
    ["@variable.builtin"] = { fg = colors.turquoise1, bold = true },
    ["@variable.member"] = { fg = "#937cc0" },
    ["@module.builtin"] = { link = "@variable.builtin" },
    ["@property"] = {},
    ["@keyword"] = { link = "Keyword" },
    ["@keyword.function"] = { fg = "#937cc0", bold = true },
    ["@keyword.return"] = { fg = "#c07c7c", bold = true },
    -- ["@keyword.conditional"] = { bg = "#191C20", fg = "#8A7B7A", bold = true },
    -- ["@keyword.repeat"] = { bg = "#191C20", fg = "#8A8A9A", bold = true },
    -- ["@keyword.debug"] = { link = "Debug" },
    -- ["@keyword.directive"] = { link = "PreProc" },
    -- ["@keyword.directive.define"] = { link = "Define" },
    -- ["@keyword.exception"] = { link = "Exception" },
    -- ["@keyword.import"] = { link = "Include" },
    -- ["@keyword.operator"] = { link = "Gruvboxpeach4" },
    -- ["@keyword.storage"] = { link = "StorageClass" },
    ["@function"] = { link = "Function" },
    ["@function.call"] = { link = "Function" },
    ["@function.builtin"] = { link = "Function" },
    -- ["@function.macro"] = { link = "Macro" },
    -- ["@function.method"] = { link = "Function" },
    ["@operator"] = { link = "Operator" },
    ["@punctuation.delimiter"] = { link = "Delimiter" },
    ["@punctuation.bracket"] = { link = "Delimiter" },
    ["@punctuation.special"] = { link = "Delimiter" },
    ["@constructor"] = { link = "Delimiter" },
    ["@comment"] = { fg = "#4b4d52" },
    ["@type"] = { link = "Type" },
    ["@type.builtin"] = { link = "Type" },
    ["@number"] = { link = "Number" },
    ["@number.float"] = { link = "Float" },
    ["@boolean"] = { link = "Boolean" },
    ["@constant"] = { link = "Constant" },
    ["@constant.builtin"] = { link = "Constant" },
    ["@tag"] = { fg = colors.indigo5, bold = true },
    ["@tag.attribute"] = { fg = "#7c7cc0" },
    ["@tag.delimiter"] = { link = "Delimiter" },
    ["@tag.builtin"] = { fg = colors.turquoise3, bold = false },

    ["@lsp.type.variable"] = {},
    ["@lsp.type.property"] = { link = "@property" },
    ["@lsp.type.class"] = { link = "@type" },
    -- ["@lsp.type.comment"] = { link = "@comment" },
    -- ["@lsp.type.decorator"] = { link = "@macro" },
    -- ["@lsp.type.enum"] = { link = "@type" },
    -- ["@lsp.type.enumMember"] = { link = "@constant" },
    -- ["@lsp.type.function"] = { link = "@function" },
    -- ["@lsp.type.interface"] = { link = "@constructor" },
    -- ["@lsp.type.macro"] = { link = "@macro" },
    -- ["@lsp.type.method"] = { link = "@method" },
    -- ["@lsp.type.modifier.java"] = { link = "@keyword.type.java" },
    -- ["@lsp.type.namespace"] = { link = "@namespace" },
    -- ["@lsp.type.parameter"] = { link = "@parameter" },
    -- ["@lsp.type.struct"] = { link = "@type" },
    -- ["@lsp.type.type"] = { link = "@type" },
    -- ["@lsp.type.typeParameter"] = { link = "@type.definition" },
    -- ["@text"] = { link = "GruvboxFg1" },
    -- ["@text.strong"] = { bold = config.bold },
    -- ["@text.emphasis"] = { italic = config.italic.emphasis },
    -- ["@text.underline"] = { underline = config.underline },
    -- ["@text.strike"] = { strikethrough = config.strikethrough },
    -- ["@text.title"] = { link = "Title" },
    -- ["@text.literal"] = { link = "String" },
    -- ["@text.uri"] = { link = "Underlined" },
    -- ["@text.math"] = { link = "Special" },
    -- ["@text.environment"] = { link = "Macro" },
    -- ["@text.environment.name"] = { link = "Type" },
    -- ["@text.reference"] = { link = "Constant" },
    -- ["@text.todo"] = { link = "Todo" },
    -- ["@text.todo.checked"] = { link = "GruvboxGreen" },
    -- ["@text.todo.unchecked"] = { link = "GruvboxGray" },
    -- ["@text.note"] = { link = "SpecialComment" },
    -- ["@text.note.comment"] = { fg = colors.purple, bold = config.bold },
    -- ["@text.warning"] = { link = "WarningMsg" },
    -- ["@text.danger"] = { link = "ErrorMsg" },
    -- ["@text.danger.comment"] = { fg = colors.fg0, bg = colors.red, bold = config.bold },
    -- ["@text.diff.add"] = { link = "diffAdded" },
    -- ["@text.diff.delete"] = { link = "diffRemoved" },

    ["@string"] = { link = "String" },
    ["@string.escape"] = { fg = colors.peach4 },
    -- ["@string.regex"] = { link = "String" },
    -- ["@string.regexp"] = { link = "String" },
    -- ["@string.special"] = { link = "SpecialChar" },
    -- ["@string.special.path"] = { link = "Underlined" },
    -- ["@string.special.symbol"] = { link = "Identifier" },
    -- ["@string.special.url"] = { link = "Underlined" },
    ["@none"] = { bg = "NONE", fg = "NONE" },

    DiagnosticUnderlineWarn = { underline = true, sp = colors.orange0 },
    -- BlinkCmpLabelDeprecated = { bg = "black" },
    BlinkCmpKind = { fg = colors.peach4 },
    -- BlinkCmpLabel = { bg = "black" },
    BlinkCmpLabelMatch = { fg = colors.turquoise5 },
    BlinkCmpMenuSelection = { bg = "#262626" },
    BlinkCmpMenu = { bg = colors.bg2 },
    BlinkCmpSource = { fg = "#404040" },
    -- BlinkCmpLabelDetail = { link = "GruvboxGray" },
    -- BlinkCmpLabelDescription = { link = "GruvboxGray" },
    BlinkCmpKindText = { fg = colors.yellow_green0 },
    -- BlinkCmpKindVariable = { link = "GruvboxOrange" },
    BlinkCmpKindMethod = { link = "BlinkCmpKindFunction" },
    BlinkCmpKindFunction = { fg = colors.purple1 },
    -- BlinkCmpKindConstructor = { link = "Gruvboxorange2" },
    -- BlinkCmpKindUnit = { link = "GruvboxBlue" },
    -- BlinkCmpKindField = { link = "GruvboxBlue" },
    -- BlinkCmpKindClass = { link = "Gruvboxorange2" },
    -- BlinkCmpKindInterface = { link = "Gruvboxorange2" },
    -- BlinkCmpKindModule = { link = "GruvboxBlue" },
    -- BlinkCmpKindProperty = { link = "GruvboxBlue" },
    -- BlinkCmpKindValue = { link = "GruvboxOrange" },
    -- BlinkCmpKindEnum = { link = "Gruvboxorange2" },
    -- BlinkCmpKindOperator = { link = "Gruvboxorange2" },
    -- BlinkCmpKindKeyword = { link = "Gruvboxblue4" },
    -- BlinkCmpKindEvent = { link = "Gruvboxblue4" },
    -- BlinkCmpKindReference = { link = "Gruvboxblue4" },
    -- BlinkCmpKindColor = { link = "Gruvboxblue4" },
    -- BlinkCmpKindSnippet = { link = "Gruvboxgreen4" },
    -- BlinkCmpKindFile = { link = "GruvboxBlue" },
    -- BlinkCmpKindFolder = { link = "GruvboxBlue" },
    -- BlinkCmpKindEnumMember = { link = "GruvboxAqua" },
    -- BlinkCmpKindConstant = { link = "GruvboxOrange" },
    -- BlinkCmpKindStruct = { link = "Gruvboxorange2" },
    -- BlinkCmpKindTypeParameter = { link = "Gruvboxorange2" },
    -- BlinkCmpGhostText = { link = "GruvboxBg4" },

    NeoTreeDirectoryName = { link = "Directory" },
    NeoTreeGitUntracked = { fg = colors.orange0, bold = true },
    NeoTreeGitModified = { fg = colors.cyan_blue0, bold = true },
    -- NeoTreeDotfile = { fg = colors.fg4 },
    -- NeoTreeFadeText1 = { fg = colors.fg3 },
    -- NeoTreeFadeText2 = { fg = colors.fg4 },
    -- NeoTreeFileIcon = { fg = colors.blue },
    -- NeoTreeFileName = { fg = colors.fg1 },
    -- NeoTreeFileNameOpened = { fg = colors.fg1, bold = true },
    -- NeoTreeFileStats = { fg = colors.fg3 },
    -- NeoTreeFileStatsHeader = { fg = colors.fg2, italic = true },
    -- NeoTreeFilterTerm = { link = "SpecialChar" },
    -- NeoTreeHiddenByName = { link = "NeoTreeDotfile" },
    -- NeoTreeIndentMarker = { fg = colors.fg4 },
    -- NeoTreeMessage = { fg = colors.fg3, italic = true },
    -- NeoTreeModified = { fg = colors.yellow },
    -- NeoTreeRootName = { fg = colors.fg1, bold = true, italic = true },
    -- NeoTreeSymbolicLinkTarget = { link = "NeoTreeFileName" },
    -- NeoTreeExpander = { fg = colors.fg4 },
    -- NeoTreeWindowsHidden = { link = "NeoTreeDotfile" },
    -- NeoTreePreview = { link = "Search" },
    -- NeoTreeGitAdded = { link = "GitGutterAdd" },
    -- NeoTreeGitConflict = { fg = colors.orange, bold = true, italic = true },
    -- NeoTreeGitDeleted = { link = "GitGutterDelete" },
    -- NeoTreeGitIgnored = { link = "NeoTreeDotfile" },
    -- NeoTreeGitRenamed = { link = "NeoTreeGitModified" },
    -- NeoTreeGitStaged = { link = "NeoTreeGitAdded" },
    -- NeoTreeGitUnstaged = { link = "NeoTreeGitConflict" },
    -- NeoTreeTabActive = { fg = colors.fg1, bold = true },
    -- NeoTreeTabInactive = { fg = colors.fg4, bg = colors.bg1 },
    -- NeoTreeTabSeparatorActive = { fg = colors.bg1 },
    -- NeoTreeTabSeparatorInactive = { fg = colors.bg2, bg = colors.bg1 },
  }

  return groups
end

function M.setup(opts) end

function M.loader()
  vim.cmd("highlight clear")
  vim.g.colorscheme = "colorscheme"
  vim.o.termguicolors = true
  local groups = get_groups()
  for group, colors in pairs(groups) do
    vim.api.nvim_set_hl(0, group, colors)
  end
end

return M

-- 40 40
-- 350
-- #8f3d4b
-- 260
-- #583d8f
-- 40
-- #8f743d
-- 10
-- #8f4b3d
--
-- 120
-- #3d8f3d
-- 160
-- #3d8f74

-- 卡
-- #BE5454
-- #F2B33F
-- #DA8D59
-- #7C9DC0
-- #969BA2
--
-- 背景
-- #191C1E
-- 前景
-- #BBBFC2
--
-- 大红
-- #C54659
-- #2476C6
-- #1C5A95
-- #49B095
-- #59B38C
-- #387262
-- #5D3D98
-- #8F5FDE
-- #B52227
-- #851E23
-- #2B1260

-- #8D6B42
-- #CEA961

-- #3D8BA0
-- #58CBE1

-- #637028
-- #4C733E

-- #BEA34C
-- #36BBAC
-- #5ED0E6
-- 红色系
-- #C07C7C - 红灰色
-- #C07C8A - 粉红色
-- #C07C98 - 玫瑰红
-- #C07CA6 - 紫红色
-- #C07CB4 - 洋红色
-- 橙色系
-- #C08A7C - 橙红色
-- #C0987C - 橙黄色
-- #C0A67C - 金黄色
-- #C0B47C - 柠檬黄
-- #C0C27C - 黄绿色
-- 黄色系
-- #C0C07C - 黄色
-- #B4C07C - 黄绿色
-- #A6C07C - 青绿色
-- #98C07C - 绿色
-- #8AC07C - 蓝绿色
-- 绿色系
-- #7CC07C - 绿色
-- #7CC08A - 青绿色
-- #7CC098 - 蓝绿色
-- #7CC0A6 - 青色
-- #7CC0B4 - 蓝青色
-- 青色系
-- #7CC0C0 - 青色
-- #7CB4C0 - 蓝青色
-- #7CA6C0 - 蓝色
-- #7C98C0 - 蓝紫色
-- #7C8AC0 - 紫色
-- 蓝色系
-- #7C7CC0 - 蓝色
-- #8A7CC0 - 蓝紫色
-- #987CC0 - 紫色
-- #A67CC0 - 紫红色
-- #B47CC0 - 洋红色
-- 紫色系
-- #C07CC0 - 紫色
-- #C07CB4 - 紫红色
-- #C07CA6 - 紫蓝色
-- #C07C98 - 蓝紫色
-- #C07C8A - 紫绿色
-- 中性色系
-- #A0A0A0 - 中性灰色
-- #B0B0B0 - 浅灰色
-- #C0C0C0 - 银灰色
-- #D0D0D0 - 更浅灰色
-- #E0E0E0 - 极浅灰色
-- 暖色系
-- #C0A07C - 棕色
-- #C0B07C - 米色
-- #C0C07C - 米黄色
-- #B0C07C - 橄榄绿
-- #A0C07C - 苔藓绿
-- 冷色系
-- #7CA0C0 - 钢蓝色
-- #7CB0C0 - 青蓝色
-- #7CC0C0 - 青色
-- #7CC0B0 - 青绿色
-- #7CC0A0 - 绿色
-- black0 = "#000000",
-- black1 = "#0d0d0d",
-- black2 = "#191919",
-- black3 = "#262626",
-- black4 = "#333333",
-- black5 = "#404040",
-- black6 = "#4d4d4d",
-- black7 = "#595959",
-- black8 = "#666666",
-- black9 = "#737373",
-- black10 = "#808080",
-- black11 = "#8C8C8C",
-- black12 = "#999999",
-- black13 = "#A6A6A6",
-- black14 = "#B3B3B3",
-- black15 = "#BFBFBF",
-- black16 = "#CCCCCC",
-- black17 = "#D9D9D9",
-- black18 = "#E6E6E6",
-- black19 = "#F2F2F2",
-- black20 = "#FFFFFF",
-- #222831
-- #1D1616
-- #0C0C0C
