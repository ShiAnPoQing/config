-- local utils = require("utils.mark")

-- vim.o.complete = ".,o"
-- vim.o.completeopt = "fuzzy,noselect,menu,popup"
-- vim.o.autocomplete = true
-- vim.o.pumheight = 7
--
-- vim.api.nvim_create_autocmd("LspAttach", {
--   callback = function(ev)
--     vim.lsp.completion.enable(true, ev.data.client_id, ev.buf, {
--       autocomplete = false,
--       -- convert = function(item)
--       --   local menu = item.detail or ""
--       --   return { abbr = item.label, word = item.label, menu = menu, info = "# nihoa" }
--       -- end,
--     })
--   end,
-- })

-- Keymap.add({
--   [";x"] = {
--     function()
--       require("test.test").test()
--     end,
--     "n",
--     { filetype = "javascript" },
--   },
--   [";;cf"] = {
--     function()
--       require("test.typescript_exchange_function").test()
--     end,
--     "n",
--   },
--   [";;a"] = {
--     function()
--       require("utils.ffget-window-size").get_window_size()
--     end,
--     "n",
--   },
--   [";;z"] = {
--     function()
--       local lnum = vim.fn.searchpairpos("{", "", "}", "n")
--       vim.print(lnum)
--     end,
--     "n",
--     -- function()
--     --   vim.ui.input({ prompt = "请输入内容:" }, function(input)
--     --     print(input)
--     --   end)
--     -- end,
--     -- "n",
--   },
-- })
-- vim.cmd([[
--   let g:augment_workspace_folders = ['~/Learn']
-- ]])
--

return {
  -- ["<M-l>"] = {
  --   "a",
  --   "n",
  -- },
  -- ["<M-h>"] = {
  --   "i",
  --   "n",
  -- },
  ["<leader>8"] = {
    ":move '>+1<CR>gv",
    "x",
  },
  -- ["<leader>7"] = {
  --   "<C-r>=nr2char(0x)<Left>",
  --   "i",
  -- },
  ["<leader><leader>o"] = {
    function()
      local node = vim.treesitter.get_node()
      local cursor = vim.api.nvim_win_get_cursor(0)
      -- vim.print(node:named_descendant_for_range(cursor[1] - 1, cursor[2], cursor[1], 1):type())
    end,
    "n",
  },
  ["<leader><leader>z"] = {
    function()
      -- 获取当前 buffer 的 parser
      local parser = vim.treesitter.get_parser(0)

      -- 取第一个 tree
      local tree = parser:parse()[1]
      local root = tree:root()

      -- 获取光标位置
      local row, col = unpack(vim.api.nvim_win_get_cursor(0))
      row = row - 1 -- 0-based

      -- 找到光标所在的 node
      local node = root:named_descendant_for_range(row, col, row, col)

      vim.print("node type:", node:type())

      while node do
        local t = node:type()
        if t == "function_declaration" or t == "method_declaration" then
          break
        end
        node = node:parent()
      end

      vim.print("node type:", node:type())

      -- local client = vim.lsp.get_clients({ bufnr = 0 })[1]
      --
      -- if not client:supports_method("textDocument/prepareCallHierarchy") then
      --   vim.notify("textDocument/prepareCallHierarchy not supported", vim.log.levels.WARN)
      --   return
      -- end
      --
      -- local params = vim.lsp.util.make_position_params(0, "utf-8")
      --
      -- vim.lsp.buf_request(0, "textDocument/prepareCallHierarchy", params, function(err, result, ctx, _)
      --   if err then
      --     vim.notify("prepareCallHierarchy error: " .. err.message, vim.log.levels.ERROR)
      --     return
      --   end
      --   if not result or vim.tbl_isempty(result) then
      --     vim.notify("No call hierarchy item found", vim.log.levels.WARN)
      --     return
      --   end
      --   local item = result[1]
      --
      --   if not item.data then
      --     return
      --   end
      --
      --   vim.lsp.buf_request(0, "callHierarchy/incomingCalls", { item = item }, function(err2, result2, ctx2, _)
      --     if err2 then
      --       vim.notify("incomingCalls error: " .. err2.message, vim.log.levels.ERROR)
      --       return
      --     end
      --     vim.print(result2)
      --     vim.print("------------------")
      --   end)
      -- end)
    end,
    "n",
  },

  -- { {
  --     from = {
  --       detail = "",
  --       kind = 12,
  --       name = "nihao",
  --       range = {
  --         ["end"] = {
  --           character = 1,
  --           line = 19
  --         },
  --         start = {
  --           character = 0,
  --           line = 17
  --         }
  --       },
  --       selectionRange = {
  --         ["end"] = {
  --           character = 14,
  --           line = 17
  --         },
  --         start = {
  --           character = 9,
  --           line = 17
  --         }
  --       },
  --       uri = "file:///home/luoqing/Project/react-router/src/main.tsx"
  --     },
  --     fromRanges = { {
  --         ["end"] = {
  --           character = 6,
  --           line = 18
  --         },
  --         start = {
  --           character = 2,
  -- ["="] = { "+", "n" },
  -- ["+"] = { "jg_", "n" },
  -- ["_"] = { "kg_", "n" },
  -- ["s"] = { "<nop>", "n" },
  -- ["sk"] = { "-", "n" },
  -- ["sj"] = { "+", "n" },
  -- ["t"] = { "f", { "n", "x", "o" } },
  -- ["f"] = { "d", { "n", "x", "o" } },
  -- ["dk"] = { "kg_", "n" },
  -- ["dj"] = { "jg_", "n" },
  -- ["sh"] = { "6zl", "n" },
  -- ["sl"] = { "6zh", "n" },
  -- ["ssh"] = { "", "n" },
  -- ["dl"] = { "g_", "n" },
  -- ["ddl"] = { "$", "n" },
  -- ["s"] = { "i", { "n", "x" } },
  -- ["d"] = { "a", { "n", "x" } },
  -- --
  -- ["w"] = { "b", { "n", "x" } },
  -- ["e"] = { "ge", { "n", "x" } },
  -- ["i"] = { "w", { "n", "x" } },
  -- ["o"] = { "e", { "n", "x" } },
  -- ["<M-w>"] = { "bi", "n" },
  -- ["<M-e>"] = { "gea", "n" },
  -- ["<M-i>"] = { "wi", "n" },
  -- ["<M-o>"] = { "ea", "n" },

  -- ["so"] = { "w", "n" },
  -- ["si"] = { "b", "n" },
  -- ["do"] = { "e", "n" },
  -- ["di"] = { "ge", "n" },

  -- ["<S-Space>"] = {
  --   function()
  --     print("vim")
  --   end,
  --   "n",
  -- },

  ["<M-w>"] = {
    function()
      local function taglist_to_qf(tagname)
        local tags = vim.fn.taglist(tagname)
        if #tags == 0 then
          vim.api.nvim_echo({ { "No tags found for " .. tagname, "WarningMsg" } }, true, {})
          return
        end

        local qf_items = {}

        for _, t in ipairs(tags) do
          -- 从 cmd 提取行列信息: "/\%336l\%10c/"
          local lnum, col = t.cmd:match("\\%%(%d+)l\\%%(%d+)c")
          lnum = tonumber(lnum) or 1
          col = tonumber(col) or 0

          table.insert(qf_items, {
            filename = t.filename,
            lnum = lnum,
            col = col,
            text = t.name,
          })
        end

        -- 设置 quickfix list 并跳到第一个条目
        vim.fn.setqflist(qf_items, "r")
        vim.cmd("cfirst")
        print("Quickfix list populated with " .. #qf_items .. " matches for tag: " .. tagname)
      end
      taglist_to_qf("tags")
    end,
    "n",
  },

  -- ["<C-j>"] = { "+", "n" },
  -- ["<C-k>"] = { "-", "n" },
  -- ["<M-j>"] = { "<down>g_", "n" },
  -- ["<M-k>"] = { "<up>g_", "n" },
  -- ["<CR>"] = {
  --   "<nop>",
  --   "n",
  -- },
}

-- -- 获取光标下变量的引用
-- local function highlight_references()
--   local params = vim.lsp.util.make_position_params(nil, "utf-16")
--   -- vim.print(params)
--   params.context = params.context or { includeDeclaration = true }
--   vim.lsp.buf_request(0, "textDocument/references", params, function(err, result, ctx, _)
--     vim.print(err)
--     if err or not result then
--       return
--     end
--     vim.print(result)
--
--     -- -- 清除之前的高亮
--     -- vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)
--     --
--     -- for _, loc in ipairs(result) do
--     -- end
--   end)
-- end

-- vim.api.nvim_create_autocmd("CursorMoved", {
--   callback = highlight_references,
-- })
