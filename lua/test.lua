-- local function test()
--   local cursor = vim.api.nvim_win_get_cursor(0)
--   local prev_cursor = cursor
--   local next_cursor = cursor
--   local scrolled
--   local stop
--   local wininfo = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
--   local s = cursor[1] - wininfo.topline
--
--   vim.api.nvim_create_autocmd({ "CursorMoved", "InsertEnter" }, {
--     callback = function()
--       if stop then
--         stop = false
--         return
--       end
--       local current_cursor = vim.api.nvim_win_get_cursor(0)
--       local offset = current_cursor[1] - prev_cursor[1]
--       next_cursor = current_cursor
--       if offset > 0 then
--         scrolled = true
--         vim.api.nvim_feedkeys(
--           vim.api.nvim_replace_termcodes(math.abs(offset) .. "<C-e>", true, false, true),
--           "nx",
--           false
--         )
--       elseif offset < 0 then
--         scrolled = true
--         vim.api.nvim_feedkeys(
--           vim.api.nvim_replace_termcodes(math.abs(offset) .. "<C-y>", true, false, true),
--           "nx",
--           false
--         )
--       end
--     end,
--   })
--
--   vim.api.nvim_create_autocmd("WinScrolled", {
--     callback = function()
--       local e = vim.v.event
--       vim.print(e)
--       if e.all.topline == 0 then
--         return
--       end
--
--       local win = vim.api.nvim_get_current_win()
--       if scrolled then
--         scrolled = false
--         prev_cursor = next_cursor
--       else
--         -- local scroll = e[tostring(win)].topline
--         -- local wininfo = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
--         -- local cursor = vim.api.nvim_win_get_cursor(0)
--         -- if cursor[1] - wininfo.topline == s then
--         --   return
--         -- end
--         --
--         -- if scroll > 0 then
--         --   stop = true
--         --   vim.api.nvim_win_set_cursor(0, { wininfo.topline + s, 0 })
--         --   prev_cursor = { wininfo.topline + s, 0 }
--         -- elseif scroll < 0 then
--         --   stop = true
--         --   vim.api.nvim_win_set_cursor(0, { wininfo.topline + s, 0 })
--         --   prev_cursor = { wininfo.topline + s, 0 }
--         -- end
--       end
--     end,
--   })
-- end

-- local utils = require("utils.mark")

-- vim.api.nvim_create_autocmd("LspAttach", {
--   callback = function(ev)
--     vim.lsp.completion.enable(true, ev.data.client_id, ev.buf, {
--       autocomplete = false,
--       -- convert = function(item)
--       --   local menu = item.detail or ""
--       --   return { abbr = item.label, word = item.label, menu = menu, info = "# nihoa" }
--       -- end,
--
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
  ["<leader>9"] = {
    function()
      local cursor1 = vim.fn.getpos(".")
      local cursor2 = vim.fn.getpos("v")
      vim.print(cursor1, cursor2)
    end,
    "x",
  },
  ["<leader>8"] = {
    ":move '>+1<CR>gv",
    "x",
  },
  ["<M-7>"] = {
    function()
      vim.cmd.stopinsert()
      vim.schedule(function()
        local cursor = vim.api.nvim_win_get_cursor(0)
        vim.api.nvim_feedkeys("e", "nx", false)
        local cursor2 = vim.api.nvim_win_get_cursor(0)
        local offset
        if cursor2[2] > cursor[2] then
          offset = cursor2[2] - cursor[2]
        end
        -- vim.schedule(function()
        vim.cmd.startinsert()
        vim.schedule(function()
          local s = "<right>"
          s = s:rep(offset)
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(s, true, false, true), "n", false)
        end)
        -- end)
      end)
      -- vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true), "nx", false)
    end,
    "t",
  },
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
  -- [";2"] = {
  --   function()
  --     vim.fn.win_splitmove(1000, 1007, {
  --       vertical = true,
  --       rightbelow = true,
  --     })
  --   end,
  --   "n",
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

-- return {
--   border1 = { "╔", "═", "╗", "║", "╝", "═", "╚", "║" },
--   fancy = {
--     { "🭽", "FloatBorder" },
--     { "▔", "FloatBorder" },
--     { "🭾", "FloatBorder" },
--     { "▕", "FloatBorder" },
--     { "🭿", "FloatBorder" },
--     { "▁", "FloatBorder" },
--     { "🭼", "FloatBorder" },
--     { "▏", "FloatBorder" },
--   },
--   dashed = {
--     { "┄", "FloatBorder" },
--     { "┄", "FloatBorder" },
--     { "┄", "FloatBorder" },
--     { "┆", "FloatBorder" },
--     { "┄", "FloatBorder" },
--     { "┄", "FloatBorder" },
--     { "┄", "FloatBorder" },
--     { "┆", "FloatBorder" },
--   },
--   -- 简单边框
--   simple = {
--     { "+", "FloatBorder" },
--     { "-", "FloatBorder" },
--     { "+", "FloatBorder" },
--     { "|", "FloatBorder" },
--     { "+", "FloatBorder" },
--     { "-", "FloatBorder" },
--     { "+", "FloatBorder" },
--     { "|", "FloatBorder" },
--   },
--
--   -- 粗边框
--   bold = {
--     { "▄", "FloatBorder" },
--     { "▄", "FloatBorder" },
--     { "▄", "FloatBorder" },
--     { "█", "FloatBorder" },
--     { "▀", "FloatBorder" },
--     { "▀", "FloatBorder" },
--     { "▀", "FloatBorder" },
--     { "█", "FloatBorder" },
--   },
--   -- 点线边框
--   dotted = {
--     { "·", "FloatBorder" },
--     { "·", "FloatBorder" },
--     { "·", "FloatBorder" },
--     { "·", "FloatBorder" },
--     { "·", "FloatBorder" },
--     { "·", "FloatBorder" },
--     { "·", "FloatBorder" },
--     { "·", "FloatBorder" },
--   },
--   -- 圆角边框
--   rounded = {
--     { "╭", "FloatBorder" },
--     { "─", "FloatBorder" },
--     { "╮", "FloatBorder" },
--     { "│", "FloatBorder" },
--     { "╯", "FloatBorder" },
--     { "─", "FloatBorder" },
--     { "╰", "FloatBorder" },
--     { "│", "FloatBorder" },
--   },
--
--   -- 实心边框
--   solid = {
--     { "█", "Normal" },
--     { "█", "Normal" },
--     { "█", "Normal" },
--     { "█", "Normal" },
--     { "█", "Normal" },
--     { "█", "Normal" },
--     { "█", "Normal" },
--     { "█", "Normal" },
--   },
--
--   border2 = {
--     { "┌", "Normal" },
--     { "─", "Normal" },
--     { "┐", "Normal" },
--     { "│", "Normal" },
--     { "┘", "Normal" },
--     { "─", "Normal" },
--     { "└", "Normal" },
--     { "│", "Normal" },
--   },
-- }

-- -- When you do joins with J it will keep your cursor at the beginning instead of at the end
-- vim.keymap.set("n", "J", "mzJ`z")

-- -- Replaces the word I'm currently on, opens a terminal so that I start typing the new word
-- -- It replaces the word globally across the entire file
-- vim.keymap.set(
--   "n",
--   "<leader>su",
--   [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
--   { desc = "[P]Replace word I'm currently on GLOBALLY" }
-- )

-- -- Replaces the current word with the same word in uppercase, globally
-- vim.keymap.set(
--   "n",
--   "<leader>sU",
--   [[:%s/\<<C-r><C-w>\>/<C-r>=toupper(expand('<cword>'))<CR>/gI<Left><Left><Left>]],
--   { desc = "[P]GLOBALLY replace word I'm on with UPPERCASE" }
-- )
--
-- -- Replaces the current word with the same word in lowercase, globally
-- vim.keymap.set(
--   "n",
--   "<leader>sL",
--   [[:%s/\<<C-r><C-w>\>/<C-r>=tolower(expand('<cword>'))<CR>/gI<Left><Left><Left>]],
--   { desc = "[P]GLOBALLY replace word I'm on with lowercase" }
-- )

-- -- Toggle executable permission on current file, previously I had 2 keymaps, to
-- -- add or remove exec permissions, now it's a toggle using the same keymap
-- vim.keymap.set("n", "<leader>fx", function()
--   local file = vim.fn.expand("%")
--   local perms = vim.fn.getfperm(file)
--   local is_executable = string.match(perms, "x", -1) ~= nil
--   local escaped_file = vim.fn.shellescape(file)
--   if is_executable then
--     vim.cmd("silent !chmod -x " .. escaped_file)
--     vim.notify("Removed executable permission", vim.log.levels.INFO)
--   else
--     vim.cmd("silent !chmod +x " .. escaped_file)
--     vim.notify("Added executable permission", vim.log.levels.INFO)
--   end
-- end, { desc = "Toggle executable permission" })
