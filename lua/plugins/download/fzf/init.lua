return {
  "ibhagwan/fzf-lua",
  -- dependencies = { "echasnovski/mini.icons" },
  depend = { "nvim-tree/nvim-web-devicons" },
  keys = {
    -- Hot
    ["<leader>ff"] = {
      function()
        require("fzf-lua").files()
      end,
      "n",
      desc = "Find Files in Current Working Directory",
    },

    ["<leader>fb"] = {

      function()
        require("fzf-lua").buffers()
      end,
      "n",
      desc = "[F]ind [B]uffers",
    },
    ["<leader>fll"] = {
      function()
        require("fzf-lua").lines()
      end,
      "n",
      desc = "Fzf Lines",
    },
    ["<leader>flb"] = {
      function()
        require("fzf-lua").blines()
      end,
      "n",
      desc = "Fzf Lines Buffer",
    },
    ["<leader>flo"] = {
      function()
        require("fzf-lua").loclist()
      end,
      "n",
      desc = "Fzf Loclist",
    },
    ["<leader>fts"] = {
      function()
        require("fzf-lua").treesitter()
      end,
      "n",
      desc = "Fzf Treesitter",
    },
    ["<leader>ftb"] = {
      function()
        require("fzf-lua").tabs()
      end,
      "n",
      desc = "Fzf Tabs",
    },
    ["<leader>fag"] = {
      function()
        require("fzf-lua").args()
      end,
      "n",
      desc = "Fzf Args",
    },
    ["<leader>fac"] = {
      function()
        require("fzf-lua").autocmds()
      end,
      "n",
      desc = "Fzf Autocmds",
    },
    ["<leader>fo"] = {
      function()
        require("fzf-lua").oldfiles()
      end,
      "n",
      desc = "Fzf Old Files",
    },
    ["<leader>fq"] = {
      function()
        require("fzf-lua").quickfix()
      end,
      "n",
      desc = "Fzf Quickfix",
    },
    ["<leader>fm"] = {
      function()
        require("fzf-lua").marks()
      end,
      "n",
      desc = "Fzf Marks",
    },
    ["<leader>fss"] = {
      function()
        require("fzf-lua").spell_suggest()
      end,
      "n",
      desc = "Fzf Spell Suggest",
    },
    ["<leader>fsc"] = {
      function()
        require("fzf-lua").spellcheck()
      end,
      "n",
      desc = "Fzf Spell Check",
    },
    ["<leader>fsh"] = {
      function()
        require("fzf-lua").search_history()
      end,
      "n",
      desc = "Fzf Search History",
    },
    ["<leader>fno"] = {
      function()
        require("fzf-lua").nvim_options()
      end,
      "n",
      desc = "Fzf Neovim Options",
    },
    ["<leader>fi"] = {
      function()
        require("fzf-lua").jumps()
      end,
      "n",
      desc = "Fzf Jumps",
    },
    ["<leader>fc"] = {
      function()
        require("fzf-lua").registers()
      end,
      "n",
      desc = "Fzf Registers",
    },
    ["<leader>fk"] = {
      function()
        require("fzf-lua").keymaps()
      end,
      "n",
      desc = "Fzf Keymaps",
    },
    ["<leader>fhl"] = {
      function()
        require("fzf-lua").highlights()
      end,
      "n",
      desc = "Fzf Highlights",
    },
    ["<leader>fht"] = {
      function()
        require("fzf-lua").helptags()
      end,
      "n",
      desc = "Fzf Helptags",
    },
    ["<leader>fz"] = {
      function()
        require("fzf-lua").builtin()
      end,
      "n",
      desc = "Fzf Builtin",
    },
    ["<leader>fg"] = {
      function()
        require("fzf-lua").global()
      end,
      "n",
      desc = "Fzf Global",
    },
    -- Fzf
    ["<leader>fO"] = {
      function()
        require("fzf-lua").resume()
      end,
      "n",
      desc = "Fzf Resume",
    },
    ["<leader>fcc"] = {
      function()
        require("fzf-lua").commands()
      end,
      "n",
      desc = "Find Commands",
    },
    ["<leader>fch"] = {
      function()
        require("fzf-lua").command_history()
      end,
      "n",
      desc = "Find Commands History",
    },
    ["<leader>fcs"] = {
      function()
        require("fzf-lua").colorschemes()
      end,
      "n",
      desc = "Find Color Schemes",
    },
    ["<leader>fcg"] = {
      function()
        require("fzf-lua").changes()
      end,
      "n",
      desc = "Find Changes",
    },
    ["<leader>fcb"] = {
      function()
        require("fzf-lua").combine()
      end,
      "n",
      desc = "Fzf Combine",
    },
    --- Tag
    ["<leader>tt"] = {
      function()
        -- require("fzf-lua").tags({ cwd = vim.fn.fnamemodify(vim.fn.tagfiles()[1], ":p:h") })
        require("fzf-lua").tags()
      end,
      "n",
      desc = "Tags",
    },
    ["<leader>tb"] = {
      function()
        require("fzf-lua").btags()
      end,
      "n",
      desc = "Buffer Tags",
    },
    ["<leader>tgg"] = {
      function()
        require("fzf-lua").tags_grep()
      end,
      "n",
      desc = "Tags Grep",
    },
    ["<leader>tgw"] = {
      function()
        require("fzf-lua").tags_grep_cword()
      end,
      "n",
      desc = "Tags Grep Cword",
    },
    ["<leader>tgW"] = {
      function()
        require("fzf-lua").tags_grep_cWORD()
      end,
      "n",
      desc = "Tags Grep CWORD",
    },
    ["<leader>tgv"] = {
      function()
        require("fzf-lua").tags_grep_visual()
      end,
      "n",
      desc = "Tags Grep Visual",
    },
    ["<leader>tlg"] = {
      function()
        require("fzf-lua").tags_live_grep()
      end,
      "n",
      desc = "Tags Live Grep",
    },
    --- Complete
    ["<leader>cp"] = {
      function()
        require("fzf-lua").complete_path()
      end,
      "n",
      desc = "Complete Path",
    },
    ["<leader>cf"] = {
      function()
        require("fzf-lua").complete_file()
      end,
      "n",
      desc = "Complete File",
    },
    --- Git
    ["<leader>gts"] = {
      function()
        require("fzf-lua").git_status()
      end,
      "n",
      desc = "Git Status",
    },
    ["<leader>gtf"] = {
      function()
        require("fzf-lua").git_files()
      end,
      "n",
      desc = "Git ls-files",
    },
    ["<leader>gtc"] = {
      function()
        require("fzf-lua").git_commits()
      end,
      "n",
      desc = "Git Commits",
    },
    ["<leader>gtbh"] = {
      function()
        require("fzf-lua").git_branches()
      end,
      "n",
      desc = "Git Branches",
    },
    --- Grep
    ["<leader>gg"] = {
      function()
        require("fzf-lua").grep()
      end,
      "n",
      desc = "Grep",
    },
    ["<leader>gw"] = {
      function()
        require("fzf-lua").grep_cword()
      end,
      "n",
      desc = "Grep cword",
    },
    ["<leader>gW"] = {
      function()
        require("fzf-lua").grep_cWORD()
      end,
      "n",
      desc = "Grep CWORD",
    },
    ["<leader>gv"] = {
      function()
        require("fzf-lua").grep_visual()
      end,
      "x",
      desc = "Grep Visual",
    },
    ["<leader>gp"] = {
      function()
        require("fzf-lua").grep_project()
      end,
      "n",
      desc = "Grep Project Line",
    },
    ["<leader>gb"] = {
      function()
        require("fzf-lua").grep_curbuf()
      end,
      "n",
      desc = "Grep Current Buffer Line",
    },
    ["<leader>gq"] = {
      function()
        require("fzf-lua").grep_quickfix()
      end,
      "n",
      desc = "Grep Quickfix",
    },
    ["<leader>gl"] = {
      function()
        require("fzf-lua").grep({ resume = true })
      end,
      "n",
      desc = "Grep Last",
    },
    ["<leader>gj"] = {
      function()
        require("fzf-lua").grep_loclist()
      end,
      "n",
      desc = "Grep Loclist",
    },
    --- Live Grep
    ["<leader>lgg"] = {
      function()
        require("fzf-lua").live_grep()
      end,
      "n",
      desc = "Live Grep",
    },
    ["<leader>lgr"] = {
      function()
        require("fzf-lua").live_grep_resume()
      end,
      "n",
      desc = "Live Grep Resume",
    },
    ["<leader>lgn"] = {
      function()
        require("fzf-lua").live_grep_native()
      end,
      "n",
      desc = "Live Grep Native",
    },
    ["<leader>lgq"] = {
      function()
        require("fzf-lua").lgrep_quickfix()
      end,
      "n",
      desc = "Live Grep Quickfix",
    },
    ["<leader>lgl"] = {
      function()
        require("fzf-lua").lgrep_loclist()
      end,
      "n",
      desc = "Live Grep Localist",
    },
    ["<leader>lgb"] = {
      function()
        require("fzf-lua").lgrep_curbuf()
      end,
      desc = "Live Grep Current Buffer",
    },
    --- LSP
    ["<leader>lr"] = {
      function()
        require("fzf-lua").lsp_references()
      end,
      "n",
      desc = "Lsp References",
    },
    ["<leader>lf"] = {
      function()
        require("fzf-lua").lsp_finder()
      end,
      "n",
      desc = "Lsp Finder",
    },
    ["<leader>ldf"] = {
      function()
        require("fzf-lua").lsp_definitions()
      end,
      "n",
      desc = "Lsp Definitions",
    },
    ["<leader>ldl"] = {
      function()
        require("fzf-lua").lsp_declarations()
      end,
      "n",
      desc = "Lsp Declarations",
    },
    ["<leader>lds"] = {
      function()
        require("fzf-lua").lsp_document_symbols()
      end,
      "n",
      desc = "Lsp Document Symbols",
    },
    ["<leader>lws"] = {
      function()
        require("fzf-lua").lsp_workspace_symbols()
      end,
      "n",
      desc = "Lsp Workspace Symbols",
    },
    ["<leader>llws"] = {

      function()
        require("fzf-lua").lsp_live_workspace_symbols()
      end,
      "n",
      desc = "Lsp Live Workspace Symbols",
    },
    ["<leader>ltd"] = {
      function()
        require("fzf-lua").lsp_typedefs()
      end,
      "n",
      desc = "Lsp Typedefs",
    },
    ["<leader>lim"] = {
      function()
        require("fzf-lua").lsp_implementations()
      end,
      "n",
      desc = "Lsp Implementations",
    },
    ["<leader>ldd"] = {
      function()
        require("fzf-lua").diagnostics_document()
      end,
      "n",
      desc = "Lsp Diagnostics Document",
    },
    ["<leader>ldw"] = {
      function()
        require("fzf-lua").diagnostics_workspace()
      end,
      "n",
      desc = "Lsp Diagnostics Workspace",
    },
    ["<leader>lci"] = {
      function()
        require("fzf-lua").lsp_incoming_calls()
      end,
      "n",
      desc = "Lsp Incoming Calls",
    },
    ["<leader>lco"] = {
      function()
        require("fzf-lua").lsp_outgoing_calls()
      end,
      "n",
      desc = "Lsp Outgoing Calls",
    },
    ["<leader>lca"] = {
      function()
        -- require("fzf-lua").register_ui_select()
        require("fzf-lua").lsp_code_actions({
          previewer = false,
          silent = true,
        })
      end,
      "n",
      desc = "Lsp Code Actions",
    },
  },
  config = function()
    local fzf = require("fzf-lua")
    vim.api.nvim_create_user_command("FzfFileTypes", function()
      fzf.filetypes()
    end, {})
  end,
}
