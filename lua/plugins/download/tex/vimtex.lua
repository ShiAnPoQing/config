return {
  "lervag/vimtex",
  ft = "tex",
  config = function()
    vim.g.tex_flavor = "latex"

    vim.g.vimtex_view_general_options = "-reuse-instance -forward-search @tex @line @pdf"
    vim.g.vimtex_view_general_viewer = "zathura_simple"
    vim.g.vimtex_view_method = "zathura_simple"
    vim.g.vimtex_view_automatic = 1
    vim.g.vimtex_view_zathura_options = "--synctex-forward @line:@col:@pdf"
    --vim.g.vimtex_view_general_options_latexmk = '-reuse-instance'
    vim.g.vimtex_compiler_progname = "nvr"

    vim.cmd([[
    function! s:write_server_name() abort
    let nvim_server_file = (has('win32') ? $TEMP : '/tmp') . '/vimtexserver.txt'
    call writefile([v:servername], nvim_server_file)
    endfunction

    augroup vimtex_common
    autocmd!
    autocmd FileType tex call s:write_server_name()
    augroup END
    ]])

    vim.g.matchup_override_vimtex = 1

    vim.g.vimtex_text_obj_enabled = 1

    vim.g.tex_conceal = "abdmg"

    vim.g.vimtex_flavor = "latex"

    vim.g.vimtex_compiler_latexmk_engines = { _ = "-xelatex" }
    vim.g.vimtex_compiler_latexrun_engines = { _ = "-xelatex" }

    vim.cmd([[
    let g:vimtex_compiler_latexmk = {
      \ 'build_dir' : '',
      \ 'callback' : 1,
      \ 'continuous' : 0,
      \ 'executable' : 'latexmk',
      \ 'hooks' : [],
      \ 'options' : [
      \   '-verbose',
      \   '-file-line-error',
      \   '-synctex=1',
      \   '-interaction=nonstopmode',
      \ ],
      \}

      " 检查文件中是否包含需要 luatex 编译的指示
      function! SwitchToLuaTeX()
      if search('!TEX\s+program\s*=\s*luatex', 'nw')
        let g:vimtex_compiler_latexmk_engines._ = '-lualatex'
        let g:vimtex_compiler_latexrun_engines._ = '-lualatex'
      else
        let g:vimtex_compiler_latexmk_engines._ = '-xelatex'
        let g:vimtex_compiler_latexrun_engines._ = '-xelatex'
      endif
      endfunction

        " 在打开或保存文件时执行切换操作
        augroup VimtexCompilerSettings
        autocmd!
        autocmd BufRead,BufNewFile * call SwitchToLuaTeX()
        autocmd BufWritePre * call SwitchToLuaTeX()
        augroup END
        ]])

    vim.g.vimtex_syntax_enabled = 1

    vim.g.vimtex_indent_ignored_envs = {
      "docunment",
      "FVerbminipage",
      "Verbatim",
      "BVerbatim",
      "LVerbatim",
      "verbatim",
      "center",
      "minipage",
      "BoxVerb",
      "BoxVerbmini",
      "Boxmini",
    }

    vim.g.vimtex_syntax_custom_cmds = {
      { name = "vspace", concealchar = "M", arg = false, arggreedy = 1 },
    }
    --
    -- Vimtex 格式化不影响注释
    vim.g.vimtex_format_enabled = 1
    -- Vimtex 补全
    -- vim.g.vimtex_complete_enabled = 1

    -- 定义分隔符匹配
    vim.g.vimtex_delim_list = {
      delim_tex = {
        name = {
          { "[", "]" },
          { "{", "}" },
          { "（", "）" },
          { "\\glq", "\\grq" },
          { "\\glqq", "\\grqq" },
          { "\\flq", "\\frq" },
          { "\\flqq", "\\frqq" },
        },
      },
    }

    --        `env_tex`     正常 TeX 模式下的环境定界符对
    --        `env_math`    特殊数学环境定界符对
    --        `delim_tex`   正常 TeX 模式下的分隔符对
    --        `delim_math`  数学模式下的分隔符对
    --        `mods`        数学模式分隔符的修饰符对
    -- {
    --   \ 'name' : [
    --   \   ['\(', '\)'],
    --   \   ['\[', '\]'],
    --   \   ['$$', '$$'],
    --   \   ['$', '$'],
    --   \ ],
    --   \ 're' : [
    --   \   ['\\(', '\\)'],
    --   \   ['\\\@<!\\\[', '\\\]'],
    --   \   ['\$\$', '\$\$'],
    --   \   ['\$', '\$'],
    --   \ ],
    --   \}
    --
    -- Vimtex cse -> 允许补全
    vim.g.vimtex_env_change_autofill = 1

    -- 修改 ts$ 的顺序
    vim.cmd([[
            let g:vimtex_env_toggle_math_map = {
              \ '$': '\[',
              \ '\[': 'equation',
              \ '$$': '\[',
              \ '\(': '$',
              \}
              ]])

    -- 启用 Vimtex 折叠
    vim.g.vimtex_fold_enabled = 1
    -- vim.g.vimtex_fold_manual = 1

    -- 自动对齐&符号
    vim.g.vimtex_indent_on_ampersands = 0

    -- 禁止映射
    -- let g:vimtex_mappings_disable = {
    --         \ 'n': ['tse', 'tsd'],
    --         \ 'x': ['tsd'],
    --         \}
    --
    --

    -- 过滤日志错误警告消息
    --vim.g.vimtex_log_ignore = {}
    --
    --
    --列表过滤错误警告消息（正则表达式）
    vim.g.vimtex_quickfix_ignore_filters = {
      "Marginpar on page",
    }

    vim.g.vimtex_quickfix_enabled = 1
    -- vim.g.vimtex_quickfix_mode = 2
    --  0 quickfix 窗口永远不会自动打开/关闭。
    --  1 出现错误时自动打开quickfix窗口，
    --         它成为活动窗口。
    --  2 出现错误时自动打开quickfix窗口，
    --         但它不会成为活动窗口。(default)
    --
    -- 指定运动次数后关闭quickfix窗口
    vim.g.vimtex_quickfix_autoclose_after_keystrokes = 4

    -- 警告信息也将打开quickfix列表
    vim.g.vimtex_quickfix_open_on_warning = 1

    require("parse-keymap").add({
      [";vv"] = {
        "<cmd>VimtexView<cr>",
        "n",
        { desc = "[V]imtex [V]iew" },
      },
      [";vc"] = {
        function()
          vim.cmd("wa")
          vim.cmd("VimtexCompile")
        end,
        "n",
        { desc = "[V]imtex [C]ompile" },
      },
      ["wc"] = { "<Plug>(vimtex-ac)", { "x", "o" } },
      ["we"] = { "<Plug>(vimtex-ae)", { "x", "o" } },
      ["ec"] = { "<Plug>(vimtex-ic)", { "x", "o" } },
      ["ee"] = { "<Plug>(vimtex-ie)", { "x", "o" } },
      ["em"] = { "<Plug>(vimtex-im)", { "x", "o" } },
      ["eP"] = { "<Plug>(vimtex-iP)", { "x", "o" } },
      ["e$"] = { "<Plug>(vimtex-i$)", { "x", "o" } },
      ["ed"] = { "<Plug>(vimtex-id)", { "x", "o" } },
    })
    vim.opt.cmdheight = 2

    vim.keymap.set("n", "cem", "<Plug>(vimtex-delim-change-math)")
    vim.keymap.set("n", "dem", "<Plug>(vimtex-delim-delete)")
    vim.keymap.set("n", "tem", "<Plug>(vimtex-delim-toggle-modifier)")
    vim.keymap.set("n", "teM", "<Plug>(vimtex-delim-toggle-modifier-reverse)")

    -- vim.g.tex_syntax_disabled = {
    --   'BoxVerb',
    --   "BoxVerbmini"
    -- }
    --
    -- vim.g.texlab_disabled = {
    --   rule = { "tex.comment" },
    --   environment = { "BoxVerb" }
    -- }
  end,
}
