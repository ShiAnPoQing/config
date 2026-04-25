return {
  name = "neo-lsp.nvim",
  event = { "BufReadPre", "BufNewFile" },
  depend = { "saghen/blink.cmp" },
  config = function()
    require("neo-lsp").setup({
      enable = function(opts)
        return {
          opts.lua,
          opts.ts,
          -- opts.vue,
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
        require("native-packer.key").add({
          ["<leader>ds"] = {
            function()
              vim.lsp.buf.document_symbol()
            end,
            "n",
            buf = args.buf,
            desc = "LSP Document Symbol",
          },
        })
      end,
      [Methods.textDocument_codeAction] = function(args, client)
        require("native-packer.key").add({
          ["<leader>C"] = {
            function()
              vim.lsp.codelens.enable(not vim.lsp.codelens.is_enabled())
            end,
            "n",
            buf = args.buf,
            desc = "Toggle codelens",
          },
        })
        -- local group = vim.api.nvim_create_augroup("LspCodeLens" .. args.buf, { clear = true })
        -- vim.api.nvim_create_autocmd("CursorHold", {
        --   group = group,
        --   buffer = args.buf,
        --   callback = function()
        --     vim.lsp.codelens.enable(true, { bufnr = args.buf })
        --   end,
        -- })
        -- vim.api.nvim_create_autocmd({ "CursorMoved", "InsertLeave" }, {
        --   group = group,
        --   buffer = args.buf,
        --   callback = function()
        --     vim.lsp.codelens.enable(false, { bufnr = args.buf })
        --   end,
        -- })
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
        require("native-packer.key").add({
          ["<leader>hi"] = {
            function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({}))
            end,
            "n",
            buf = args.buf,
            desc = "Toggle inlay hint",
          },
        })
      end,
      [Methods.callHierarchy_incomingCalls] = function(args)
        require("native-packer.key").add({
          ["<leader>ic"] = {
            function()
              vim.lsp.buf.incoming_calls()
            end,
            "n",
            buf = args.buf,
            desc = "Lists all the call sites of the symbol under the cursor in the |quickfix| window.",
          },
        })
      end,
      [Methods.textDocument_selectionRange] = function(args)
        require("native-packer.key").add({
          ["er"] = {
            function()
              vim.lsp.buf.selection_range(vim.v.count1)
            end,
            "x",
            buf = args.buf,
            desc = "Perform an incremental selection at the cursor position based on ranges given by the LSP.",
          },
        })
      end,
      [Methods.callHierarchy_outgoingCalls] = function(args)
        require("native-packer.key").add({
          ["<leader>oc"] = {
            function()
              vim.lsp.buf.incoming_calls()
            end,
            "n",
            buf = args.buf,
            desc = "Lists all the items that are called by the symbol under the cursor in the |quickfix| window.",
          },
        })
      end,
      [Methods.textDocument_documentColor] = function()
        vim.lsp.document_color.enable(true, nil, { style = "virtual" })
      end,
      [Methods.textDocument_linkedEditingRange] = function(args, client)
        vim.lsp.linked_editing_range.enable(true, { client_id = client.id })
      end,
      [Methods.textDocument_definition] = function(args)
        require("native-packer.key").add({
          ["gd"] = {
            function()
              vim.opt.switchbuf = "uselast"
              vim.lsp.buf.definition()
            end,
            "n",
            desc = "Goto Lsp definition",
            buf = args.buf,
          },
          ["<tab>gd"] = {
            function()
              vim.opt.switchbuf = "newtab"
              vim.lsp.buf.definition()
            end,
            "n",
            desc = "Goto Lsp definition(New Tab)",
            buf = args.buf,
          },
          ["ad"] = {
            function()
              vim.opt.switchbuf = "vsplit"
              vim.lsp.buf.definition()
            end,
            "n",
            desc = "Goto Lsp definition(vsplit)",
            buf = args.buf,
          },
          ["sd"] = {
            function()
              vim.opt.switchbuf = "split"
              vim.lsp.buf.definition()
            end,
            "n",
            desc = "Goto Lsp definition(vsplit)",
            buf = args.buf,
          },
          [";gd"] = {
            function()
              local method = vim.lsp.protocol.Methods.textDocument_definition
              local bufnr = vim.api.nvim_get_current_buf()
              local win = vim.api.nvim_get_current_win()

              local clients = vim.lsp.get_clients({ method = method, bufnr = bufnr })
              if not next(clients) then
                vim.notify(vim.lsp._unsupported_method(method), vim.log.levels.WARN)
                return
              end

              local from = vim.fn.getpos(".")
              from[1] = bufnr
              local tagname = vim.fn.expand("<cword>")

              vim.lsp.buf_request_all(bufnr, method, function(client)
                local params = vim.lsp.util.make_position_params(win, client.offset_encoding)
                ---@diagnostic disable-next-line: inject-field
                params.context = nil or { includeDeclaration = true }
                return params
              end, function(results)
                ---@type vim.quickfix.entry[]
                local all_items = {}

                for client_id, res in pairs(results) do
                  local client = assert(vim.lsp.get_client_by_id(client_id))
                  local locations = {}
                  if res then
                    locations = vim.islist(res.result) and res.result or { res.result }
                  end
                  local items = vim.lsp.util.locations_to_items(locations, client.offset_encoding)
                  vim.list_extend(all_items, items)
                end

                local name = string.gsub(method:match("textDocument/(.*)"), "(%u)", " %1"):lower()
                if vim.tbl_isempty(all_items) then
                  vim.notify(("No %s found"):format(name), vim.log.levels.INFO)
                  return
                end

                ---@type vim.fn.setqflist.what
                local list = {
                  title = name:gsub("^%l", string.upper),
                  items = all_items,
                  context = { bufnr = bufnr, method = method },
                }

                local height = math.ceil(vim.o.lines * 0.3)
                local row
                local winline = vim.fn.winline()
                local below_height = vim.o.lines - winline - vim.o.cmdheight - 2

                if vim.o.laststatus > 1 then
                  below_height = below_height - 1
                end
                if below_height >= winline then
                  height = math.min(below_height, height)
                  row = 1
                else
                  height = math.min(winline, height)
                  row = -height - 2
                end
                local _buf = vim.uri_to_bufnr(list.items[1].user_data.targetUri)
                list.items[1].bufnr = _buf
                vim.fn.bufload(_buf)
                local width = #vim.api.nvim_buf_get_lines(_buf, list.items[1].lnum - 1, list.items[1].lnum, false)[1]
                width = math.max(width, 10)

                local float_win = vim.api.nvim_open_win(_buf, true, {
                  relative = "cursor",
                  width = width,
                  height = height,
                  style = "minimal",
                  row = row,
                  col = 0,
                  title = "Tag: " .. tagname,
                  title_pos = "center",
                  border = "single",
                })
                vim.api.nvim_set_option_value("signcolumn", "no", { win = float_win })
                vim.fn.setqflist({}, " ", list)
                local tagstack = { { tagname = tagname, from = from } }
                vim.fn.settagstack(vim.fn.win_getid(win), { items = tagstack }, "t")
                vim.cmd("cfirst")
                vim.schedule(function()
                  vim.api.nvim_set_option_value("cursorline", true, { win = float_win })
                end)
                vim.api.nvim_set_current_win(win)
                vim.api.nvim_create_autocmd("CursorMoved", {
                  callback = function()
                    vim.api.nvim_win_close(float_win, true)
                    return true
                  end,
                })
              end)
            end,
            "n",
            buf = args.buf,
          },
        })
      end,
      [Methods.textDocument_typeDefinition] = function(args)
        require("native-packer.key").add({
          ["gy"] = {
            function()
              vim.lsp.buf.type_definition()
            end,
            "n",
            desc = "Got Lsp type definition",
            buf = args.buf,
          },
        })
      end,
      [Methods.textDocument_hover] = function(args)
        require("native-packer.key").add({
          ["<leader>k"] = {
            function()
              vim.lsp.buf.hover()
            end,
            "n",
            buf = args.buf,
            desc = "LSP Hover",
          },
        })
      end,
      [Methods.textDocument_signatureHelp] = function(args)
        require("native-packer.key").add({
          ["gs"] = {
            function()
              vim.lsp.buf.signature_help()
            end,
            "n",
            buf = args.buf,
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
