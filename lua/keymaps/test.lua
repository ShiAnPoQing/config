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
      -- 获取光标下的语法高亮组
      local function get_highlight_at_cursor()
        local line = vim.fn.line(".")
        local col = vim.fn.col(".")

        -- 获取语法ID
        local syn_id = vim.fn.synID(line, col, 1)

        -- 获取透明语法ID
        local trans_id = vim.fn.synIDtrans(syn_id)

        -- 获取语法组名称
        local syn_name = vim.fn.synIDattr(syn_id, "name")
        local trans_name = vim.fn.synIDattr(trans_id, "name")

        -- 获取高亮组名称
        local hl_group = vim.fn.synIDattr(trans_id, "name")

        return {
          syn_id = syn_id,
          trans_id = trans_id,
          syn_name = syn_name,
          trans_name = trans_name,
          hl_group = hl_group,
        }
      end

      -- 使用示例
      local highlight_info = get_highlight_at_cursor()
      print("语法组:", highlight_info.syn_name)
      print("高亮组:", highlight_info.hl_group)
    end,
    "n",
  },
  -- ["<CR>"] = {
  --   "<nop>",
  --   "n",
  -- },
}
