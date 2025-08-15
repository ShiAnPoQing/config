local M = {}

local function get_colors()
  local color_groups = {
    dark = {
      black0 = "#000000",
      black1 = "#0d0d0d",
      black2 = "#191919",
      black3 = "#262626",
      black4 = "#333333",
      black5 = "#404040",
      black6 = "#4d4d4d",
      black7 = "#595959",
      black8 = "#666666",
      black9 = "#737373",
      black10 = "#808080",
      black11 = "#8C8C8C",
      black12 = "#999999",
      black13 = "#A6A6A6",
      black14 = "#B3B3B3",
      black15 = "#BFBFBF",
      black16 = "#CCCCCC",
      black17 = "#D9D9D9",
      black18 = "#E6E6E6",
      black19 = "#F2F2F2",
      black20 = "#FFFFFF",
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
    -- 普通文本
    Normal = { fg = "#969aa3", bg = "#0d0d0d" },
    --- 浮动窗口的普通文本
    NormalFloat = { link = "Normal" },
    -- 非当前窗口的普通文本
    NormalNC = { link = "Normal" },
    -- More Message
    MoreMsg = { link = "Normal" },
    -- Mode Message
    ModeMsg = { link = "Normal" },
    -- 行号
    LineNr = { fg = "#404040", bg = "#0d0d0d" },
    -- 搜索结果
    Search = { reverse = true },
    IncSearch = { link = "Search" },
    CurSearch = { link = "IncSearch" },
    -- 状态栏
    StatusLine = { bg = "#0d0d0d", fg = "#969aa3", reverse = true },
    -- 符号列
    SignColumn = { bg = "#0d0d0d" },
    -- 光标行
    CursorLine = { bg = "#202329" },
    CursorLineNr = { fg = colors.black10 },
    ColorColumn = { bg = colors.black2 },
    Visual = { bg = "#24272F", reverse = false },
    VisualNOS = { link = "Visual" },
    -- 标签栏
    TabLineFill = { bg = "#0C0E11" },
    -- 非当前标签
    TabLine = { link = "TabLineFill" },
    -- 当前标签选中
    TabLineSel = { fg = "#36BBAC", bg = "#0d0d0d", bold = true },
    WarningMsg = { fg = "#F2B33F" },
    Error = { fg = "#C54659" },
    ErrorMsg = { fg = "#0d0d0d", bg = "#C54659", bold = true },
    MatchParen = { reverse = true },
    -- Conceal = { fg = colors.blue },
    Keyword = { fg = "#8F5FDE", bold = true },

    ["@variable"] = { fg = "#7C9DC0" },
    ["@variable.parameter"] = { fg = "#7C9DC0" },
    ["@variable.builtin"] = { fg = "#59B38C", bold = true },
    ["@variable.member"] = { fg = "#969aa3" },
    ["@lsp.type.variable"] = {},

    ["@module.builtin"] = { link = "@variable.builtin" },
    -- ["@constant.builtin"] = { link = "@variable.builtin" },
    ["@property"] = {},
    ["@lsp.type.property"] = { link = "@property" },
    ["@keyword"] = { link = "Keyword" },
    ["@keyword.function"] = { fg = "#8F5FDE", bold = true },
    ["@keyword.return"] = { fg = "#C54659", bold = true },
    -- ["@keyword.conditional"] = { bg = "#191C20", fg = "#8A7B7A", bold = true },
    -- ["@keyword.repeat"] = { bg = "#191C20", fg = "#8A8A9A", bold = true },
    -- ["@keyword.debug"] = { link = "Debug" },
    -- ["@keyword.directive"] = { link = "PreProc" },
    -- ["@keyword.directive.define"] = { link = "Define" },
    -- ["@keyword.exception"] = { link = "Exception" },
    -- ["@keyword.import"] = { link = "Include" },
    -- ["@keyword.operator"] = { link = "GruvboxRed" },
    -- ["@keyword.storage"] = { link = "StorageClass" },

    Function = { fg = "#C54659", bold = true },
    String = { fg = "#F2B33F" },
    Number = { bg = "#0d0d0d", fg = "#C54659" },
    Operator = { fg = "#969aa3" },
    Delimiter = { fg = "#969aa3" },
    Comment = { fg = "#4b4d52" },
    Boolean = { bg = "#0d0d0d", fg = "#DA8D59", bold = true },
    Type = { fg = "#59B38C", bold = true },
    ["@function"] = { link = "Function" },
    ["@function.call"] = { link = "Function" },
    -- ["@function.builtin"] = { link = "Special" },
    -- ["@function.macro"] = { link = "Macro" },
    -- ["@function.method"] = { link = "Function" },
    ["@string"] = { link = "String" },
    ["@operator"] = { link = "Operator" },
    ["@punctuation.delimiter"] = { link = "Delimiter" },
    ["@punctuation.bracket"] = { link = "Delimiter" },
    ["@punctuation.special"] = { link = "Delimiter" },
    ["@constructor"] = { link = "Delimiter" },
    ["@comment"] = { fg = "#4b4d52" },
    ["@type"] = { link = "Type" },
    ["@lsp.type.class"] = { link = "@type" },
    ["@number"] = { link = "Number" },
    ["@number.float"] = { link = "Float" },
    ["@boolean"] = { link = "Boolean" },
    ["@constant"] = { link = "Constant" },
    -- BlinkCmpLabelDeprecated = { link = "GruvboxFg1" },
    BlinkCmpKind = { fg = "#C54659" },
    -- BlinkCmpLabel = { bg = "#C54659" },
    BlinkCmpLabelMatch = { fg = "#8F5FDE" },
    BlinkCmpMenuSelection = { bg = "#262626" },
    BlinkCmpMenu = { bg = "#191919" },
    BlinkCmpSource = { fg = "#7C9DC0" },
    -- BlinkCmpLabelDetail = { link = "GruvboxGray" },
    -- BlinkCmpLabelDescription = { link = "GruvboxGray" },
    -- BlinkCmpKindText = { link = "GruvboxOrange" },
    -- BlinkCmpKindVariable = { link = "GruvboxOrange" },
    -- BlinkCmpKindMethod = { link = "GruvboxBlue" },
    -- BlinkCmpKindFunction = { link = "GruvboxBlue" },
    -- BlinkCmpKindConstructor = { link = "GruvboxYellow" },
    -- BlinkCmpKindUnit = { link = "GruvboxBlue" },
    -- BlinkCmpKindField = { link = "GruvboxBlue" },
    -- BlinkCmpKindClass = { link = "GruvboxYellow" },
    -- BlinkCmpKindInterface = { link = "GruvboxYellow" },
    -- BlinkCmpKindModule = { link = "GruvboxBlue" },
    -- BlinkCmpKindProperty = { link = "GruvboxBlue" },
    -- BlinkCmpKindValue = { link = "GruvboxOrange" },
    -- BlinkCmpKindEnum = { link = "GruvboxYellow" },
    -- BlinkCmpKindOperator = { link = "GruvboxYellow" },
    -- BlinkCmpKindKeyword = { link = "GruvboxPurple" },
    -- BlinkCmpKindEvent = { link = "GruvboxPurple" },
    -- BlinkCmpKindReference = { link = "GruvboxPurple" },
    -- BlinkCmpKindColor = { link = "GruvboxPurple" },
    -- BlinkCmpKindSnippet = { link = "GruvboxGreen" },
    -- BlinkCmpKindFile = { link = "GruvboxBlue" },
    -- BlinkCmpKindFolder = { link = "GruvboxBlue" },
    -- BlinkCmpKindEnumMember = { link = "GruvboxAqua" },
    -- BlinkCmpKindConstant = { link = "GruvboxOrange" },
    -- BlinkCmpKindStruct = { link = "GruvboxYellow" },
    -- BlinkCmpKindTypeParameter = { link = "GruvboxYellow" },
    -- BlinkCmpGhostText = { link = "GruvboxBg4" },
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
