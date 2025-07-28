local M = {}

local searchKey = {
  "arrow",
  "tikz",
  "leftarrow",
  "rightarrow",
  "uparrow",
  "downarrow",
}

function M.searchManual()
  vim.ui.select(searchKey, {
    prompt = "Select:",
    format_item = function(item)
      return item
    end,
  }, function(choice)
    if choice == "arrow" then
      local path = vim.fn.expand("~/AppData/Local/nvim/lua/search-manual/arrow.json")
      local data = vim.fn.json_decode(vim.fn.readfile(path))
      local arrowsInfo = {}
      for _, value in pairs(data) do
        table.insert(arrowsInfo, value.basearrow)
      end
      local buf = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_buf_set_lines(buf, 0, 1, false, arrowsInfo)

      local maxWidth = 10
      for i, line in ipairs(arrowsInfo) do
        maxWidth = #line > maxWidth and #line or maxWidth
        vim.api.nvim_buf_add_highlight(buf, -1, "WarningMsg", i - 1, 0, 3)
      end

      vim.api.nvim_set_hl(0, "floatWin", { bg = "black" })

      local opts = {
        relative = "editor",
        width = maxWidth,
        row = 0,
        col = 0,
        height = 10,
        anchor = "NW",
        style = "minimal",
        border = "rounded",
      }

      local win = vim.api.nvim_open_win(buf, true, opts)
      vim.api.nvim_buf_set_option(buf, "modifiable", false)
      vim.api.nvim_buf_set_keymap(buf, "n", "<CR>", "<cmd>lua require('float-win').test1()<cr>", {})
      vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", "<cmd>q!<cr>", {})
      vim.api.nvim_buf_set_keymap(buf, "n", "q", "<cmd>q!<cr>", {})
      vim.api.nvim_buf_set_keymap(buf, "n", "<C-j>", "<cmd>lua require('float-win').updataWinPos('j')<cr>", {})
      vim.api.nvim_buf_set_keymap(buf, "n", "<C-k>", "<cmd>lua require('float-win').updataWinPos('k')<cr>", {})
      vim.api.nvim_buf_set_keymap(buf, "n", "<C-h>", "<cmd>lua require('float-win').updataWinPos('h')<cr>", {})
      vim.api.nvim_buf_set_keymap(buf, "n", "<C-l>", "<cmd>lua require('float-win').updataWinPos('l')<cr>", {})
      vim.api.nvim_buf_set_keymap(
        buf,
        "n",
        ";cs",
        "<cmd>lua require('search-manual').changeFloatWinSize()<cr>",
        {}
      )
      vim.api.nvim_win_set_option(win, "winhl", "Normal:floatWin")
    end
  end)
end

function M.changeFloatWinSize()
  vim.api.nvim_win_set_config(0, { row = 0, col = 0, width = 10, height = 10, relative = "editor", anchor = "NW" })
end

return M
