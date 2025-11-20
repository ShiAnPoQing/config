return {
  dir = "~/.config/nvim/pack/custom/opt/neo-lsp.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "saghen/blink.cmp" },
  config = function(opt)
    require("neo-lsp").setup({
      enable = function(opts)
        return {
          opts.lua,
          opts.ts,
          opts.vue,
          opts.clangd,
          opts.html,
          opts.css,
          opts.json,
          opts.qml,
          opts.rust,
          opts.tex,
        }
      end,
    })

    local Methods = vim.lsp.protocol.Methods
    local callbacks = {
      [Methods.textDocument_documentSymbol] = function(args)
        require("simple-keymap").add({
          ["<leader>ds"] = {
            function()
              vim.lsp.buf.document_symbol()
            end,
            "n",
            buffer = args.buf,
            desc = "LSP Document Symbol",
          },
        })
      end,
      [Methods.textDocument_codeAction] = function(args)
        local group = vim.api.nvim_create_augroup("LspCodeLens" .. args.buf, { clear = true })
        vim.api.nvim_create_autocmd("CursorHold", {
          group = group,
          buffer = args.buf,
          callback = function()
            vim.lsp.codelens.refresh({ bufnr = args.buf })
          end,
        })
        vim.api.nvim_create_autocmd({ "CursorMoved", "InsertLeave" }, {
          group = group,
          buffer = args.buf,
          callback = function()
            vim.lsp.codelens.clear(nil, args.buf)
          end,
        })
      end,
      [Methods.textDocument_documentHighlight] = function(args)
        -- local group = vim.api.nvim_create_augroup("document-highlight", { clear = false })
        -- vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI", "InsertLeave" }, {
        --   group = group,
        --   buffer = args.buf,
        --   callback = vim.lsp.buf.document_highlight,
        -- })
        -- vim.api.nvim_create_autocmd({ "CursorMoved", "InsertEnter" }, {
        --   group = group,
        --   buffer = args.buf,
        --   callback = vim.lsp.buf.clear_references,
        -- })
      end,
      [Methods.textDocument_inlayHint] = function(args)
        require("simple-keymap").add({
          ["<leader>hi"] = {
            function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({}))
            end,
            "n",
            buffer = args.buf,
            desc = "Toggle inlay hint",
          },
        })
      end,
      [Methods.callHierarchy_incomingCalls] = function(args)
        require("simple-keymap").add({
          ["<leader>ic"] = {
            function()
              vim.lsp.buf.incoming_calls()
            end,
            "n",
            buffer = args.buf,
            desc = "Lists all the call sites of the symbol under the cursor in the |quickfix| window.",
          },
        })
      end,
      [Methods.textDocument_selectionRange] = function(args)
        require("simple-keymap").add({
          ["er"] = {
            function()
              vim.lsp.buf.selection_range(vim.v.count1)
            end,
            "x",
            buffer = args.buf,
            desc = "Perform an incremental selection at the cursor position based on ranges given by the LSP.",
          },
        })
      end,
      [Methods.callHierarchy_outgoingCalls] = function(args)
        require("simple-keymap").add({
          ["<leader>oc"] = {
            function()
              vim.lsp.buf.incoming_calls()
            end,
            "n",
            buffer = args.buf,
            desc = "Lists all the items that are called by the symbol under the cursor in the |quickfix| window.",
          },
        })
      end,
      [Methods.textDocument_documentColor] = function(args)
        vim.lsp.document_color.enable(true, args.buf, { style = "virtual" })
      end,
      [Methods.textDocument_linkedEditingRange] = function(args, client)
        vim.lsp.linked_editing_range.enable(true, { client_id = client.id })
      end,
      [Methods.textDocument_definition] = function(args)
        require("simple-keymap").add({
          ["gd"] = {
            function()
              vim.lsp.buf.definition()
            end,
            "n",
            desc = "Goto Lsp definition",
            buffer = args.buf,
          },
        })
      end,
      [Methods.textDocument_typeDefinition] = function(args)
        require("simple-keymap").add({
          ["gy"] = {
            function()
              vim.lsp.buf.type_definition()
            end,
            "n",
            desc = "Got Lsp type definition",
            buffer = args.buf,
          },
        })
      end,
      [Methods.textDocument_hover] = function(args)
        require("simple-keymap").add({
          ["<leader>k"] = {
            function()
              vim.lsp.buf.hover()
            end,
            "n",
            buffer = args.buf,
            desc = "LSP Hover",
          },
        })
      end,
      [Methods.textDocument_signatureHelp] = function(args)
        require("simple-keymap").add({
          ["gs"] = {
            function()
              vim.lsp.buf.signature_help()
            end,
            "n",
            buffer = args.buf,
            desc = "LSP Signature Help",
          },
        })
      end,
    }

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("my.lsp", {}),
      callback = function(args)
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
        for method, callback in pairs(callbacks) do
          if client:supports_method(method) then
            callback(args, client)
          end
        end
      end,
    })
  end,
}
