return {
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
        previewer = false,
        silent = true,
      })
    end,
    desc = "Lsp Code Actions",
  },
}
