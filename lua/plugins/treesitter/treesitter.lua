return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
  config = function()
    require("nvim-treesitter.configs").setup({
      -- A list of parser names, or "all" (the five listed parsers should always be installed)
      ensure_installed = { "c", "lua", "vim", "vimdoc", "query" },

      -- Install parsers synchronously (only applied to `ensure_installed`)
      sync_install = false,

      -- Automatically install missing parsers when entering buffer
      -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
      auto_install = true,

      -- List of parsers to ignore installing (or "all")
      ignore_install = { "javascript", "typescript" },

      ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
      -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

      highlight = {
        enable = true,

        -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
        -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
        -- the name of the parser)
        -- list of language that will be disabled
        disable = { "c", "rust", "latex" },
        -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
        -- disable = function(lang, buf)
        -- local max_filesize = 100 * 1024 -- 100 KB
        -- local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        -- if ok and stats and stats.size > max_filesize then
        -- return true
        -- end
        -- end,

        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
      },
      -- autotag = {
      --   enable = true,
      -- },
      textobjects = {
        select = {
          enable = true,

          -- Automatically jump forward to textobj, similar to targets.vim
          lookahead = true,

          keymaps = {
            ["<space>fo"] = "@function.outer",
            ["<space>fi"] = "@function.inner",
            ["<space>fp"] = "@parameter.inner",
            --
            ["<space>fci"] = "@call.inner",
            ["<space>fco"] = "@call.outer",

            ["<space>ai"] = "@attribute.inner",
            ["<space>ao"] = "@attribute.outer",

            ["<space>ri"] = "@return.inner",
            ["<space>ro"] = "@return.outer",

            ["<space>rgi"] = "@regex.inner",
            ["<space>rgo"] = "@regex.outer",

            ["<space>ci"] = "@comment.inner",
            ["<space>co"] = "@comment.outer",

            [";li"] = "@loop.inner",
            [";lo"] = "@loop.outer",
            [";ki"] = "@conditional.inner",
            [";ko"] = "@conditional.outer",

            ["<space>bi"] = "@block.inner",
            ["<space>bo"] = "@block.outer",

            ["<space>csi"] = "@class.inner",
            ["<space>cso"] = "@class.outer",

            -- [";el"] = "@assignment.inner",
            -- [";eh"] = "@assignment.lhs",
            -- [";ee"] = "@assignment.outer",
            [";sm"] = "@statement.outer",

            [";nm"] = "@number.inner",
          },
          selection_modes = {
            ["@parameter.outer"] = "v", -- charwise
            ["@function.outer"] = "V",  -- linewise
            ["@class.outer"] = "<c-v>", -- blockwise
          },
          include_surrounding_whitespace = true,
        },
      },
    })

    -- require("treesitter-context").setup({
    -- 	enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
    -- 	max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
    -- 	min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
    -- 	line_numbers = true,
    -- 	multiline_threshold = 20, -- Maximum number of lines to show for a single context
    -- 	trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
    -- 	mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
    -- 	-- Separator between context and content. Should be a single character string, like '-'.
    -- 	-- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
    -- 	separator = nil,
    -- 	zindex = 20, -- The Z-index of the context window
    -- 	on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
    -- })
  end,
}

--[[
| 捕获组             | 说明（选中内容）                         |
| ------------------ | ---------------------------------------- |
| @assignment.inner  | 赋值语句的右侧（被赋值的值）             |
| @assignment.rhs    | 赋值语句的右侧（同 inner，右值）         |
| @assignment.lhs    | 赋值语句的左侧（被赋值的变量）           |
| @assignment.outer  | 整个赋值语句                             |
| @attribute.inner   | 属性内容（如 Python 装饰器的内容）       |
| @attribute.outer   | 整个属性（如装饰器整行）                 |
| @block.inner       | 代码块内部（不含大括号/缩进）            |
| @block.outer       | 整个代码块（含大括号/缩进）              |
| @call.inner        | 函数调用参数部分                         |
| @call.outer        | 整个函数调用（含函数名和括号）           |
| @class.inner       | 类体内部（不含 class 关键字和花括号）    |
| @class.outer       | 整个类定义（含 class 关键字和花括号）    |
| @comment.inner     | 注释内容（不含注释符号）                 |
| @comment.outer     | 整个注释（含注释符号）                   |
| @conditional.inner | 条件语句体（如 if/else 内部）            |
| @conditional.outer | 整个条件语句（如 if/else 整体）          |
| @frame.inner       | 框架结构内部（如 LaTeX 的 frame）        |
| @frame.outer       | 整个框架结构                             |
| @function.inner    | 函数体内部（不含 function 关键字和括号） |
| @function.outer    | 整个函数定义（含 function 关键字和括号） |
| @loop.inner        | 循环体内部（如 for/while 内部）          |
| @loop.outer        | 整个循环结构（如 for/while 整体）        |
| @number.inner      | 数字文本对象                             |
| @parameter.inner   | 参数内容（如函数参数）                   |
| @regex.inner       | 正则表达式内容                           |
| @regex.outer       | 整个正则表达式                           |
| @return.inner      | return 语句的返回值部分                  |
| @return.outer      | 整个 return 语句                         |
| @scopename.inner   | 作用域名称（如函数名、类名等）           |
| @statement.outer   | 整个语句（如一行代码）                   |
--]]
