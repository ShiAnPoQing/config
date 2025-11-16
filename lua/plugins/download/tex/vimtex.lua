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

    require("simple-keymap").add({
      ["cem"] = {
        "<Plug>(vimtex-delim-delete)",
        "n",
        buffer = true,
      },
      ["wc"] = {
        "<Plug>(vimtex-ac)",
        { "x", "o" },
        buffer = true,
      },
      ["ec"] = {
        "<Plug>(vimtex-ic)",
        { "x", "o" },
        buffer = true,
      },
      ["wd"] = {
        "<Plug>(vimtex-ad)",
        { "x", "o" },
        buffer = true,
      },
      ["ed"] = {
        "<Plug>(vimtex-id)",
        { "x", "o" },
        buffer = true,
      },
      ["we"] = {
        "<Plug>(vimtex-ae)",
        { "x", "o" },
        buffer = true,
      },
      ["ee"] = {
        "<Plug>(vimtex-ie)",
        { "x", "o" },
        buffer = true,
      },
      ["w$"] = {
        "<Plug>(vimtex-a$)",
        { "x", "o" },
        buffer = true,
      },
      ["e$"] = {
        "<Plug>(vimtex-i$)",
        { "x", "o" },
        buffer = true,
      },
      ["wP"] = {
        "<Plug>(vimtex-aP)",
        { "x", "o" },
        buffer = true,
      },
      ["eP"] = {
        "<Plug>(vimtex-iP)",
        { "x", "o" },
        buffer = true,
      },
      ["<localleader>lt"] = {
        function()
          return require("vimtex.fzf-lua").run()
        end,
        "n",
        buffer = true,
      },
      ["<localleader>k"] = {
        "<Plug>(vimtex-doc-package)",
        "n",
        buffer = true,
      },
    })
    vim.keymap.set("n", "<localleader>cse", function()
      local bufnr = vim.api.nvim_get_current_buf()
      local Client = vim.lsp.get_clients({
        bufnr = bufnr,
      })[1]

      if not Client then
        return
      end

      Client:exec_cmd({
        title = "Change Environment",
        command = "texlab.findEnvironments",
        arguments = {
          {
            textDocument = { uri = vim.uri_from_bufnr(0) },
            position = vim.api.nvim_win_get_cursor(0),
          },
        },
      }, { bufnr = bufnr }, function(err, result, ctx)
        if err or #result == 0 then
          return
        end
        local r = result[#result]

        vim.ui.input({
          prompt = "Change Environment Name: ",
          default = r.name.text or "",
        }, function(input)
          if input == nil then
            return
          end

          Client:exec_cmd({
            title = "Change Environment",
            command = "texlab.changeEnvironment",
            arguments = {
              {
                textDocument = { uri = vim.uri_from_bufnr(0) },
                position = vim.api.nvim_win_get_cursor(0),
                newName = input,
              },
            },
          })
        end)
      end)
    end)

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
