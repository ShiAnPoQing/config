-- local utils = require("utils.mark")

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
--       require("utils.get-window-size").get_window_size()
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
  [";;z"] = {
    function()
      require("builtin.sreen-move").move("left")
    end,
    "n",
  },
  -- ["s"] = { "<nop>", "n" },
  -- ["sk"] = { "-", "n" },
  -- ["sj"] = { "+", "n" },
  -- ["t"] = { "d", { "n", "x", "o" } },
  -- ["d"] = { "<nop>", { "n" } },
  -- ["dk"] = { "kg_", "n" },
  -- ["dj"] = { "jg_", "n" },
  -- ["sh"] = { "^", "n" },
  -- ["ssh"] = { "0", "n" },
  -- ["dl"] = { "g_", "n" },
  -- ["ddl"] = { "$", "n" },
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
