return {
  "ibhagwan/fzf-lua",
  -- dependencies = { "echasnovski/mini.icons" },
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    {
      "<leader>fd",
      "<cmd>FzFDirectories<CR>",
    },
    -- Hot
    {
      "<leader>ff",
      function()
        require("fzf-lua").files()
      end,
      desc = "Find Files in Current Working Directory",
    },

    {
      "<leader>fb",

      function()
        require("fzf-lua").buffers()
      end,
      desc = "{F,{B,rs",
    },
    {
      "<leader>fll",
      function()
        require("fzf-lua").lines()
      end,
      desc = "Fzf Lines",
    },
    {
      "<leader>flb",
      function()
        require("fzf-lua").blines()
      end,
      desc = "Fzf Lines Buffer",
    },
    {
      "<leader>flo",
      function()
        require("fzf-lua").loclist()
      end,
      desc = "Fzf Loclist",
    },
    {
      "<leader>fts",
      function()
        require("fzf-lua").treesitter()
      end,
      desc = "Fzf Treesitter",
    },
    {
      "<leader>ftb",
      function()
        require("fzf-lua").tabs()
      end,
      desc = "Fzf Tabs",
    },
    {
      "<leader>fag",
      function()
        require("fzf-lua").args()
      end,
      desc = "Fzf Args",
    },
    {
      "<leader>fac",
      function()
        require("fzf-lua").autocmds()
      end,
      desc = "Fzf Autocmds",
    },
    {
      "<leader>fo",
      function()
        require("fzf-lua").oldfiles()
      end,
      desc = "Fzf Old Files",
    },
    {
      "<leader>fq",
      function()
        require("fzf-lua").quickfix()
      end,
      desc = "Fzf Quickfix",
    },
    {
      "<leader>fm",
      function()
        require("fzf-lua").marks()
      end,
      desc = "Fzf Marks",
    },
    {
      "<leader>fss",
      function()
        require("fzf-lua").spell_suggest()
      end,
      desc = "Fzf Spell Suggest",
    },
    {
      "<leader>fsc",
      function()
        require("fzf-lua").spellcheck()
      end,
      desc = "Fzf Spell Check",
    },
    {
      "<leader>fsh",
      function()
        require("fzf-lua").search_history()
      end,
      desc = "Fzf Search History",
    },
    {
      "<leader>fno",
      function()
        require("fzf-lua").nvim_options()
      end,
      desc = "Fzf Neovim Options",
    },
    {
      "<leader>fi",
      function()
        require("fzf-lua").jumps()
      end,
      desc = "Fzf Jumps",
    },
    {
      "<leader>fc",
      function()
        require("fzf-lua").registers()
      end,
      desc = "Fzf Registers",
    },
    {
      "<leader>fk",
      function()
        require("fzf-lua").keymaps()
      end,
      desc = "Fzf Keymaps",
    },
    {
      "<leader>fhl",
      function()
        require("fzf-lua").highlights()
      end,
      desc = "Fzf Highlights",
    },
    {
      "<leader>fht",
      function()
        require("fzf-lua").helptags()
      end,
      desc = "Fzf Helptags",
    },
    {
      "<leader>fz",
      function()
        require("fzf-lua").builtin()
      end,
      desc = "Fzf Builtin",
    },
    {
      "<leader>fg",
      function()
        require("fzf-lua").global()
      end,
      desc = "Fzf Global",
    },
    -- Fzf
    {
      "<leader>fO",
      function()
        require("fzf-lua").resume()
      end,
      desc = "Fzf Resume",
    },
    {
      "<leader>fcc",
      function()
        require("fzf-lua").commands()
      end,
      desc = "Find Commands",
    },
    {
      "<leader>fch",
      function()
        require("fzf-lua").command_history()
      end,
      desc = "Find Commands History",
    },
    {
      "<leader>fcs",
      function()
        require("fzf-lua").colorschemes()
      end,
      desc = "Find Color Schemes",
    },
    {
      "<leader>fcg",
      function()
        require("fzf-lua").changes()
      end,
      desc = "Find Changes",
    },
    {
      "<leader>fcb",
      function()
        require("fzf-lua").combine()
      end,
      desc = "Fzf Combine",
    },
    --- Tag
    {
      "<leader>tt",
      function()
        -- require("fzf-lua").tags({ cwd = vim.fn.fnamemodify(vim.fn.tagfiles(){1,p:h") })
        require("fzf-lua").tags()
      end,
      desc = "Tags",
    },
    {
      "<leader>tb",
      function()
        require("fzf-lua").btags()
      end,
      desc = "Buffer Tags",
    },
    {
      "<leader>tgg",
      function()
        require("fzf-lua").tags_grep()
      end,
      desc = "Tags Grep",
    },
    {
      "<leader>tgw",
      function()
        require("fzf-lua").tags_grep_cword()
      end,
      desc = "Tags Grep Cword",
    },
    {
      "<leader>tgW",
      function()
        require("fzf-lua").tags_grep_cWORD()
      end,
      desc = "Tags Grep CWORD",
    },
    {
      "<leader>tgv",
      function()
        require("fzf-lua").tags_grep_visual()
      end,
      desc = "Tags Grep Visual",
    },
    {
      "<leader>tlg",
      function()
        require("fzf-lua").tags_live_grep()
      end,
      desc = "Tags Live Grep",
    },
    --- Complete
    {
      "<leader>cp",
      function()
        require("fzf-lua").complete_path()
      end,
      desc = "Complete Path",
    },
    {
      "<leader>cf",
      function()
        require("fzf-lua").complete_file()
      end,
      desc = "Complete File",
    },
    --- Git
    {
      "<leader>gts",
      function()
        require("fzf-lua").git_status()
      end,
      desc = "Git Status",
    },
    {
      "<leader>gtf",
      function()
        require("fzf-lua").git_files()
      end,
      desc = "Git ls-files",
    },
    {
      "<leader>gtc",
      function()
        require("fzf-lua").git_commits()
      end,
      desc = "Git Commits",
    },
    {
      "<leader>gtbh",
      function()
        require("fzf-lua").git_branches()
      end,
      desc = "Git Branches",
    },
    --- Grep
    {
      "<leader>gg",
      function()
        require("fzf-lua").grep()
      end,
      desc = "Grep",
    },
    {
      "<leader>gw",
      function()
        require("fzf-lua").grep_cword()
      end,
      desc = "Grep cword",
    },
    {
      "<leader>gW",
      function()
        require("fzf-lua").grep_cWORD()
      end,
      desc = "Grep CWORD",
    },
    {
      "<leader>gv",
      function()
        require("fzf-lua").grep_visual()
      end,
      "x",
      desc = "Grep Visual",
    },
    {
      "<leader>gp",
      function()
        require("fzf-lua").grep_project()
      end,
      desc = "Grep Project Line",
    },
    {
      "<leader>gb",
      function()
        require("fzf-lua").grep_curbuf()
      end,
      desc = "Grep Current Buffer Line",
    },
    {
      "<leader>gq",
      function()
        require("fzf-lua").grep_quickfix()
      end,
      desc = "Grep Quickfix",
    },
    {
      "<leader>gl",
      function()
        require("fzf-lua").grep({ resume = true })
      end,
      desc = "Grep Last",
    },
    {
      "<leader>gj",
      function()
        require("fzf-lua").grep_loclist()
      end,
      desc = "Grep Loclist",
    },
    --- Live Grep
    {
      "<leader>lgg",
      function()
        require("fzf-lua").live_grep()
      end,
      desc = "Live Grep",
    },
    {
      "<leader>lgr",
      function()
        require("fzf-lua").live_grep_resume()
      end,
      desc = "Live Grep Resume",
    },
    {
      "<leader>lgn",
      function()
        require("fzf-lua").live_grep_native()
      end,
      desc = "Live Grep Native",
    },
    {
      "<leader>lgq",
      function()
        require("fzf-lua").lgrep_quickfix()
      end,
      desc = "Live Grep Quickfix",
    },
    {
      "<leader>lgl",
      function()
        require("fzf-lua").lgrep_loclist()
      end,
      desc = "Live Grep Localist",
    },
    {
      "<leader>lgb",
      function()
        require("fzf-lua").lgrep_curbuf()
      end,
      desc = "Live Grep Current Buffer",
    },
    --- LSP
    {
      "<leader>lr",
      function()
        require("fzf-lua").lsp_references()
      end,
      desc = "Lsp References",
    },
    {
      "<leader>lf",
      function()
        require("fzf-lua").lsp_finder()
      end,
      desc = "Lsp Finder",
    },
    {
      "<leader>ldf",
      function()
        require("fzf-lua").lsp_definitions()
      end,
      desc = "Lsp Definitions",
    },
    {
      "<leader>ldl",
      function()
        require("fzf-lua").lsp_declarations()
      end,
      desc = "Lsp Declarations",
    },
    {
      "<leader>lds",
      function()
        require("fzf-lua").lsp_document_symbols()
      end,
      desc = "Lsp Document Symbols",
    },
    {
      "<leader>lws",
      function()
        require("fzf-lua").lsp_workspace_symbols()
      end,
      desc = "Lsp Workspace Symbols",
    },
    {
      "<leader>llws",

      function()
        require("fzf-lua").lsp_live_workspace_symbols()
      end,
      desc = "Lsp Live Workspace Symbols",
    },
    {
      "<leader>ltd",
      function()
        require("fzf-lua").lsp_typedefs()
      end,
      desc = "Lsp Typedefs",
    },
    {
      "<leader>lim",
      function()
        require("fzf-lua").lsp_implementations()
      end,
      desc = "Lsp Implementations",
    },
    {
      "<leader>ldd",
      function()
        require("fzf-lua").diagnostics_document()
      end,
      desc = "Lsp Diagnostics Document",
    },
    {
      "<leader>ldw",
      function()
        require("fzf-lua").diagnostics_workspace()
      end,
      desc = "Lsp Diagnostics Workspace",
    },
    {
      "<leader>lci",
      function()
        require("fzf-lua").lsp_incoming_calls()
      end,
      desc = "Lsp Incoming Calls",
    },
    {
      "<leader>lco",
      function()
        require("fzf-lua").lsp_outgoing_calls()
      end,
      desc = "Lsp Outgoing Calls",
    },
    {
      "<leader>lca",
      function()
        -- require("fzf-lua").register_ui_select()
        require("fzf-lua").lsp_code_actions({
          ---@diagnostic disable-next-line: assign-type-mismatch
          previewer = false,
          silent = true,
        })
      end,
      desc = "Lsp Code Actions",
    },
  },
  config = function()
    local fzf = require("fzf-lua")
    vim.api.nvim_create_user_command("FzfFileTypes", function()
      fzf.filetypes()
    end, {})
    require("fzf-lua").setup({
      winopts = {
        split = "belowright new",
      },
    })
    vim.api.nvim_create_user_command("FzFDirectories", function()
      local fzf_lua = require("fzf-lua")
      local opt = {}
      local path = vim.fn.getcwd(0)
      opts.prompt = path .. "> "

      opts.fn_transform = function(x)
        local ansi_codes = require("fzf-lua.utils").ansi_codes
        return ansi_codes.magenta(x)
      end

      opts.fzf_opts = {
        ["--preview"] = "tree {}",
        ["--preview-window"] = "nohidden,right,50%",
      }

      opts.actions = {
        ["default"] = function(selected)
          vim.cmd("cd " .. selected[1])
        end,
      }
      fzf_lua.fzf_exec("fd --type d ", opts)
    end, {})
  end,
}
