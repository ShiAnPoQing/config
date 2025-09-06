-- local utils = require("utils.mark")

-- vim.o.complete = ".,o"
-- vim.o.completeopt = "fuzzy,noselect,popup"
-- vim.o.autocomplete = true
-- vim.o.pumheight = 7
--
-- vim.api.nvim_create_autocmd("LspAttach", {
--   callback = function(ev)
--     vim.lsp.completion.enable(true, ev.data.client_id, ev.buf, {
--       autocomplete = true,
--       convert = function(item)
--         local menu = item.detail or ""
--         menu = #menu > 15 and menu:sub(1, 14) .. "…" or menu
--         return { abbr = item.label, word = item.label, menu = menu, info = "# nihoa" }
--       end,
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
  ["<leader><leader>z"] = {
    function()
      vim.ui.input({ prompt = "请输入内容:" }, function(input) end)
      -- vim.ui.select({ "tabs", "spaces" }, {
      --   prompt = "Select tabs or spaces:",
      --   format_item = function(item)
      --     return "I'd like to choose " .. item
      --   end,
      -- }, function(choice)
      --   if choice == "spaces" then
      --     vim.o.expandtab = true
      --   else
      --     vim.o.expandtab = false
      --   end
      -- end)
    end,
    "n",
  },
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

  -- ["<C-j>"] = { "+", "n" },
  -- ["<C-k>"] = { "-", "n" },
  -- ["<M-j>"] = { "<down>g_", "n" },
  -- ["<M-k>"] = { "<up>g_", "n" },
  -- ["<CR>"] = {
  --   "<nop>",
  --   "n",
  -- },
}
