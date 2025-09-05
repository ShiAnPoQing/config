local M = {}

local function get_colors(bg)
  local color_groups = {
    dark = {
      hue1 = "#c0827c", -- 5
      hue2 = "#c0877c", -- 10
      hue3 = "#c08d7c", -- 15
      hue4 = "#c0937c", -- 20
      hue5 = "#c0987c", -- 25
      hue6 = "#c09e7c", -- 30
      hue7 = "#c0a47c", -- 35
      hue8 = "#c0a97c", -- 40
      hue9 = "#c0af7c", -- 45
      hue10 = "#c0b57c", -- 50
      hue11 = "#c0ba7c", -- 55
      hue12 = "#c0c07c", -- 60
      hue13 = "#bac07c", -- 65
      hue14 = "#b5c07c", -- 70
      hue15 = "#afc07c", -- 75
      hue16 = "#a9c07c", -- 80
      hue17 = "#a4c07c", -- 85
      hue18 = "#9ec07c", -- 90
      hue19 = "#98c07c", -- 95
      hue20 = "#93c07c", -- 100
      hue21 = "#8dc07c", -- 105
      hue22 = "#87c07c", -- 110
      hue23 = "#82c07c", -- 115
      hue24 = "#7cc07c", -- 120
      hue25 = "#7cc082", -- 125
      hue26 = "#7cc087", -- 130
      hue27 = "#7cc08d", -- 135
      hue28 = "#7cc093", -- 140
      hue29 = "#7cc098", -- 145
      hue30 = "#7cc09e", -- 150
      hue31 = "#7cc0a4", -- 155
      hue32 = "#7cc0a9", -- 160
      hue33 = "#7cc0af", -- 165
      hue34 = "#7cc0b5", -- 170
      hue35 = "#7cc0ba", -- 175
      hue36 = "#7cc0c0", -- 180
      hue37 = "#7cbac0", -- 185
      hue38 = "#7cb5c0", -- 190
      hue39 = "#7cafc0", -- 195
      hue40 = "#7ca9c0", -- 200
      hue41 = "#7ca4c0", -- 205
      hue42 = "#7c9ec0", -- 210
      hue43 = "#7c98c0", -- 215
      hue44 = "#7c93c0", -- 220
      hue45 = "#7c8dc0", -- 225
      hue46 = "#7c87c0", -- 230
      hue47 = "#7c82c0", -- 235
      hue48 = "#7c7cc0", -- 240
      hue49 = "#827cc0", -- 245
      hue50 = "#877cc0", -- 250
      hue51 = "#8d7cc0", -- 255
      hue52 = "#937cc0", -- 260
      hue53 = "#987cc0", -- 265
      hue54 = "#9e7cc0", -- 270
      hue55 = "#a47cc0", -- 275
      hue56 = "#a97cc0", -- 280
      hue57 = "#af7cc0", -- 285
      hue58 = "#b57cc0", -- 290
      hue59 = "#ba7cc0", -- 295
      hue60 = "#c07cc0", -- 300
      hue61 = "#c07cba", -- 305
      hue62 = "#c07cb5", -- 310
      hue63 = "#c07caf", -- 315
      hue64 = "#c07ca9", -- 320
      hue65 = "#c07ca4", -- 325
      hue66 = "#c07c9e", -- 330
      hue67 = "#c07c98", -- 335
      hue68 = "#c07c93", -- 340
      hue69 = "#c07c8d", -- 345
      hue70 = "#c07c87", -- 350
      hue71 = "#c07c82", -- 355
      hue72 = "#c07c7c", -- 360

      bg1 = "#080A13",
      bg2 = "#0A0B15",
      bg3 = "#131520",
      bg4 = "#1D202B",
      bg5 = "#262A36",
      bg6 = "#313644",
      bg7 = "#3D414F",
      bg8 = "#484C5A",
      bg9 = "#545868",
      bg10 = "#5F6372",
      bg11 = "#6B7081",
      bg12 = "#777C8F",
      bg13 = "#82879A",
      bg14 = "#8E93A5",
      bg15 = "#999FB3",
      bg16 = "#A5AAC0",
      bg17 = "#B0B6CC",
      bg18 = "#BCC2D9",
      bg19 = "#C7CEE5",
      bg20 = "#D3D9F2",
      bg21 = "#DEE5FF",
      bg22 = "#E3E9FF",

      _bg1 = "#08080b",
      _bg2 = "#0f0f13",
      _bg3 = "#18181e",
      _bg4 = "#1f1f27",
      _bg5 = "#26262f",
      _bg6 = "#2f2f3b",
      _bg7 = "#363643",
      _bg8 = "#3c3c4c",
      _bg9 = "#454557",
      _bg10 = "#4c4c60",
      _bg11 = "#535368",
      _bg12 = "#5c5c74",
      _bg13 = "#63637c",
      _bg14 = "#6a6a85",
      _bg15 = "#737390",
      _bg16 = "#7b7b96",
      _bg17 = "#84849d",
    },
    light = {
      hue1 = "#ac4339", -- 5
      hue2 = "#ac4d39", -- 10
      hue3 = "#ac5639", -- 15
      hue4 = "#ac6039", -- 20
      hue5 = "#ac6939", -- 25
      hue6 = "#ac7339", -- 30
      hue7 = "#ac7c39", -- 35
      hue8 = "#ac8639", -- 40
      hue9 = "#ac8f39", -- 45
      hue10 = "#ac9939", -- 50
      hue11 = "#aca339", -- 55
      hue12 = "#acac39", -- 60
      hue13 = "#a3ac39", -- 65
      hue14 = "#99ac39", -- 70
      hue15 = "#8fac39", -- 75
      hue16 = "#86ac39", -- 80
      hue17 = "#7cac39", -- 85
      hue18 = "#73ac39", -- 90
      hue19 = "#69ac39", -- 95
      hue20 = "#60ac39", -- 100
      hue21 = "#56ac39", -- 105
      hue22 = "#4dac39", -- 110
      hue23 = "#43ac39", -- 115
      hue24 = "#39ac39", -- 120
      hue25 = "#39ac43", -- 125
      hue26 = "#39ac4c", -- 130
      hue27 = "#39ac56", -- 135
      hue28 = "#39ac60", -- 140
      hue29 = "#39ac69", -- 145
      hue30 = "#39ac73", -- 150
      hue31 = "#39ac7c", -- 155
      hue32 = "#39ac86", -- 160
      hue33 = "#39ac8f", -- 165
      hue34 = "#39ac99", -- 170
      hue35 = "#39aca3", -- 175
      hue36 = "#39acac", -- 180
      hue37 = "#39a3ac", -- 185
      hue38 = "#3999ac", -- 190
      hue39 = "#398fac", -- 195
      hue40 = "#3986ac", -- 200
      hue41 = "#397cac", -- 205
      hue42 = "#3973ac", -- 210
      hue43 = "#3969ac", -- 215
      hue44 = "#3960ac", -- 220
      hue45 = "#3956ac", -- 225
      hue46 = "#394cac", -- 230
      hue47 = "#3943ac", -- 235
      hue48 = "#3939ac", -- 240
      hue49 = "#4339ac", -- 245
      hue50 = "#4d39ac", -- 250
      hue51 = "#5639ac", -- 255
      hue52 = "#6039ac", -- 260
      hue53 = "#6939ac", -- 265
      hue54 = "#7339ac", -- 270
      hue55 = "#7c39ac", -- 275
      hue56 = "#8639ac", -- 280
      hue57 = "#8f39ac", -- 285
      hue58 = "#9939ac", -- 290
      hue59 = "#a339ac", -- 295
      hue60 = "#ac39ac", -- 300
      hue61 = "#ac39a3", -- 305
      hue62 = "#ac3999", -- 310
      hue63 = "#ac398f", -- 315
      hue64 = "#ac3986", -- 320
      hue65 = "#ac397c", -- 325
      hue66 = "#ac3973", -- 330
      hue67 = "#ac3969", -- 335
      hue68 = "#ac3960", -- 340
      hue69 = "#ac3956", -- 345
      hue70 = "#ac394d", -- 350
      hue71 = "#ac3943", -- 355
      hue72 = "#ac3939", -- 360
    },
  }
  return color_groups[bg]
end

local function get_groups()
  local bg = vim.o.background
  local colors = get_colors(bg)
  local groups = {
    dark = {
      CustomVisual = { bg = colors.bg7, reverse = false },
      -- Normal = { fg = colors.bg15, bg = colors.bg5 }, -- 普通文本
      -- Normal = { fg = colors.bg15, bg = "#1F1F27" }, -- 普通文本
      Normal = { fg = colors.bg15, bg = colors._bg4 }, -- 普通文本
      NormalFloat = { fg = colors.bg15, bg = colors.bg3 }, --- 浮动窗口的普通文本
      NormalNC = { link = "Normal" }, -- 非当前窗口的普通文本
      MoreMsg = { link = "Normal" }, -- More Message
      ModeMsg = { link = "Normal" }, -- Mode Message
      LineNr = { fg = colors.bg9, bg = colors._bg4, bold = false }, -- 行号
      Search = { reverse = true }, -- 搜索结果
      IncSearch = { link = "Search" },
      CurSearch = { link = "IncSearch" },
      StatusLine = { bg = colors.bg5, fg = colors.bg15, reverse = true }, -- 状态栏
      SignColumn = { bg = colors._bg4 }, -- 符号列
      CursorLine = { bg = colors.bg6 }, -- 光标行
      CursorLineNr = { fg = colors.bg15, bold = true },
      ColorColumn = { bg = colors.bg6 },
      Visual = { link = "CustomVisual" },
      VisualNOS = { link = "Visual" },
      TabLineFill = { bg = colors.bg5 }, -- 标签栏
      TabLine = { link = "TabLineFill" }, -- 非当前标签
      TabLineSel = { fg = colors.hue44, bg = colors.bg6, bold = true }, -- 当前标签选中
      WarningMsg = { fg = colors.hue5 },
      Error = { fg = colors.hue72 },
      ErrorMsg = { fg = colors.bg5, bg = colors.hue72, bold = true },
      MatchParen = { reverse = true },
      -- Conceal = { fg =  },
      Keyword = { fg = colors.hue52, bold = true },
      Function = { fg = colors.hue45, bold = true },
      String = { fg = colors.hue20 },
      Number = { bg = colors._bg4, fg = colors.hue1 },
      Operator = { fg = colors.hue40 },
      Delimiter = { fg = colors.bg15 },
      Comment = { fg = colors.bg9 },
      Boolean = { fg = colors.hue72, bold = true },
      Type = { fg = colors.hue36, bold = true },
      Constant = { fg = colors.hue1, bold = true },
      Directory = { fg = colors.hue45, bold = true },
      Label = { fg = colors.hue50, bold = true },
      Special = { fg = colors.hue35 },
      Title = { fg = colors.hue45 },
      Folded = { link = "Visual" },

      -- Underlined = { fg = colors.blue, underline = config.underline }, -- 突出的文本，HTML链接

      ["@variable"] = { fg = colors.bg15 },
      ["@variable.parameter"] = { fg = colors.hue6, bold = false },
      ["@variable.builtin"] = { fg = colors.hue72, bold = true },
      -- ["@variable.member"] = { fg = "" },
      ["@module.builtin"] = { link = "@variable.builtin" },
      ["@property"] = { fg = colors.hue48 },
      ["@keyword"] = { link = "Keyword" },
      ["@keyword.function"] = { fg = colors.hue52, bold = true },
      ["@keyword.return"] = { fg = colors.hue52, bold = true },
      -- ["@keyword.conditional"] = { bg = "", fg = "", bold = true },
      -- ["@keyword.repeat"] = { bg = "", fg = "", bold = true },
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
      ["@comment"] = { link = "Comment" },
      ["@type"] = { link = "Type" },
      ["@type.builtin"] = { link = "Type" },
      ["@number"] = { link = "Number" },
      ["@number.float"] = { link = "Float" },
      ["@boolean"] = { link = "Boolean" },
      ["@constant"] = { link = "Constant" },
      ["@constant.builtin"] = { link = "Constant" },
      ["@tag"] = { fg = colors.hue72, bold = true },
      ["@tag.attribute"] = { fg = colors.hue48 },
      ["@tag.delimiter"] = { link = "Delimiter" },
      ["@tag.builtin"] = { fg = colors.hue40, bold = false },

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

      -- ["@markup"] = { link = "GruvboxFg1" },
      -- ["@markup.strong"] = { bold = config.bold },
      -- ["@markup.italic"] = { link = "@text.emphasis" },
      -- ["@markup.underline"] = { underline = config.underline },
      -- ["@markup.strikethrough"] = { strikethrough = config.strikethrough },
      -- ["@markup.heading"] = { link = "Title" },
      ["@markup.raw"] = { link = "String" },
      -- ["@markup.math"] = { link = "Special" },
      -- ["@markup.environment"] = { link = "Macro" },
      -- ["@markup.environment.name"] = { link = "Type" },
      ["@markup.link"] = { fg = colors.hue62 },
      ["@markup.link.label"] = { link = "@markup.link" },
      ["@markup.link.vimdoc"] = { link = "@markup.link" },
      ["@markup.list"] = { link = "Delimiter" },
      -- ["@markup.list.checked"] = { link = "GruvboxGreen" },
      -- ["@markup.list.unchecked"] = { link = "GruvboxGray" },

      ["@label"] = { link = "Label" },
      ["@label.vimdoc"] = { link = "Label" },

      DiagnosticUnderlineWarn = { underline = true, sp = colors.orange0 },
      -- DiagnosticUnnecessary = { underdotted = true },
      BlinkCmpLabelDeprecated = { strikethrough = true },
      BlinkCmpKind = { fg = colors.hue52 },
      -- BlinkCmpLabel = { bg = "" },
      BlinkCmpLabelMatch = { fg = colors.hue52, bold = true },
      BlinkCmpMenuSelection = { bg = colors.bg6 },
      BlinkCmpMenu = { bg = colors.bg3 },
      BlinkCmpSource = { fg = colors.bg10 },
      BlinkCmpDoc = { bg = colors.bg3 },
      -- BlinkCmpLabelDetail = { bg = colors.bg2 },
      BlinkCmpLabelDescription = { bg = colors.bg2 },
      BlinkCmpKindText = { fg = colors.hue23 },
      BlinkCmpKindVariable = { fg = colors.hue48 },
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
      NeoTreeGitUntracked = { fg = colors.hue5, bold = true },
      NeoTreeGitModified = { fg = colors.hue36, bold = true },
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
      -- NeoTreeModified = { fg = colors. },
      -- NeoTreeRootName = { fg = colors.fg1, bold = true, italic = true },
      -- NeoTreeSymbolicLinkTarget = { link = "NeoTreeFileName" },
      -- NeoTreeExpander = { fg = colors.fg4 },
      -- NeoTreeWindowsHidden = { link = "NeoTreeDotfile" },
      -- NeoTreePreview = { link = "Search" },
      -- NeoTreeGitAdded = { link = "GitGutterAdd" },
      -- NeoTreeGitConflict = { fg = colors., bold = true, italic = true },
      -- NeoTreeGitDeleted = { link = "GitGutterDelete" },
      -- NeoTreeGitIgnored = { link = "NeoTreeDotfile" },
      -- NeoTreeGitRenamed = { link = "NeoTreeGitModified" },
      -- NeoTreeGitStaged = { link = "NeoTreeGitAdded" },
      -- NeoTreeGitUnstaged = { link = "NeoTreeGitConflict" },
      -- NeoTreeTabActive = { fg = colors.fg1, bold = true },
      -- NeoTreeTabInactive = { fg = colors.fg4, bg = colors.bg5 },
      -- NeoTreeTabSeparatorActive = { fg = colors.bg5 },
      -- NeoTreeTabSeparatorInactive = { fg = colors.bg2, bg = colors.bg5 },
    },
    light = {
      Normal = { fg = "#2D3142", bg = "#B0B6CC" }, -- 普通文本
      ["@variable"] = { fg = "#2D3142" },
      -- ["@variable.builtin"] = { fg = "#6a40bf" },
      Keyword = { fg = colors.hue55, bold = true },
      Function = { fg = colors.hue50, bold = true },
      Special = { fg = "#007373" },
      String = { fg = "#4d7300" },
      Boolean = { fg = colors.hue1, bold = true },
      ["@property"] = { fg = "#007373" },
      ["@lsp.type.property"] = { link = "@property" },
    },
  }

  return groups[bg]
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
