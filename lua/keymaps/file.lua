--1. Yank buffer's relative path to clipboard
--2. Yank absolute path

return {
  ["<leader>md"] = {
    function()
      local cwd = vim.fn.getcwd()
      vim.ui.input({
        prompt = "Create New Directory: " .. cwd .. "/",
      }, function(input)
        if input then
          local name = cwd .. "/" .. input
          vim.fn.mkdir(name, "p")
          vim.notify("Success Created New Directory: " .. name)
        end
      end)
    end,
    "n",
    desc = "Create New Directory",
  },
  ["<leader>mf"] = {
    function()
      local cwd = vim.fn.getcwd()
      vim.ui.input({
        prompt = "Create New File: " .. cwd .. "/",
      }, function(input)
        if not input then
          return
        end

        local name = cwd .. "/" .. input
        vim.fn.writefile({}, name)
        vim.notify("Success Created New File: " .. name)
      end)
    end,
    "n",
    desc = "Create New File",
  },
  ["<leader>mF"] = {
    function()
      local cwd = vim.fn.getcwd()
      -- vim.cmd.echohl("Operator")
      vim.ui.input({
        prompt = "Delete File: " .. cwd .. "/",
        completion = "file",
        -- highlight = function(input)
        -- return { { 0, 1, "ErrorMsg" } }
        -- end,
      }, function(input)
        if not input then
          return
        end
        vim.fn.delete(cwd .. "/" .. input)
        vim.notify("Success Deleted File: " .. cwd .. "/" .. input)
        -- vim.cmd.echohl("WarningMsg")
      end)
    end,
    "n",
    desc = "Delete File",
  },
  ["<leader>mD"] = {
    function()
      local cwd = vim.fn.getcwd()
      vim.ui.input({
        prompt = "Delete Directory: " .. cwd .. "/",
        completion = "dir",
      }, function(input)
        if not input then
          return
        end
        vim.fn.delete(cwd .. "/" .. input, "d")
        vim.notify("Success Deleted Directory: " .. cwd .. "/" .. input)
      end)
    end,
    "n",
    desc = "Delete Directory",
  },
  ["<leader>mr"] = {
    function()
      local path = vim.fn.expand("%:p")
      vim.ui.input({
        prompt = "Rename Current File " .. path .. " → ",
        completion = "dir",
      }, function(input)
        if not input then
          return
        end
        local dir = vim.fn.fnamemodify(path, ":h")
        vim.fn.rename(path, dir .. "/" .. input)
      end)
    end,
    "n",
    desc = "Rename Current File",
  },
  -- copy file name
  ["<leader>yfn"] = {
    '<cmd>let @+ = expand("%")<CR>',
    "n",
    desc = "Copy file name",
  },
  -- copy file path
  ["<leader>yfp"] = {
    '<cmd>let @+ = expand("%:p")<CR>',
    "n",
    desc = "Copy file path",
  },
  ["<leader>cd"] = {
    "<cmd>ChangeDirectoryToFile<CR>",
    "n",
    desc = "Change directory to file",
  },
  ["<leader>tcd"] = {
    "<cmd>ChangeTabDirectoryToFile<CR>",
    "n",
    desc = "Change directory to file",
  },
}
