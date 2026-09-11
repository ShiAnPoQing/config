return {
  "lervag/vimtex",
  ft = { "plaintex", "tex" },
  config = function()
    vim.g.tex_flavor = "latex"
    vim.g.vimtex_mappings_disable = {
      ["x"] = { "ac", "ic", "ad", "id", "ae", "ie", "a$", "i$", "aP", "iP", "am", "im" },
      ["o"] = { "ac", "ic", "ad", "id", "ae", "ie", "a$", "i$", "aP", "iP", "am", "im" },
      ["n"] = { "K" },
    }
    vim.g.vimtex_view_general_options = "-reuse-instance -forward-search @tex @line @pdf"
    vim.g.vimtex_view_general_viewer = "zathura_simple"
    vim.g.vimtex_view_method = "zathura_simple"
    vim.g.vimtex_view_automatic = 1
    vim.g.vimtex_view_zathura_options = "--synctex-forward @line:@col:@pdf"
    vim.g.matchup_override_vimtex = 1
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
      \   '-shell-escape',
      \   '-verbose',
      \   '-file-line-error',
      \   '-synctex=1',
      \   '-interaction=nonstopmode',
      \ ],
      \}
        ]])

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
    vim.g.vimtex_env_change_autofill = 1
    vim.g.vimtex_fold_enabled = 1
    vim.g.vimtex_indent_on_ampersands = 0

    vim.g.vimtex_quickfix_enabled = 1
    vim.g.vimtex_quickfix_mode = 0
    -- vim.g.vimtex_quickfix_autoclose_after_keystrokes = 4
    vim.g.vimtex_quickfix_open_on_warning = 0
    vim.g.vimtex_quickfix_ignore_filters = {
      "Marginpar on page",
    }
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
