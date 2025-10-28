---------------------------------------------------------------------------------------------------+
-- Commands \ Modes | Normal | Insert | Command | Visual | Select | Operator | Terminal | Lang-Arg |
-- ================================================================================================+
-- map  / noremap   |    @   |   -    |    -    |   @    |   @    |    @     |    -     |    -     |
-- nmap / nnoremap  |    @   |   -    |    -    |   -    |   -    |    -     |    -     |    -     |
-- map! / noremap!  |    -   |   @    |    @    |   -    |   -    |    -     |    -     |    -     |
-- imap / inoremap  |    -   |   @    |    -    |   -    |   -    |    -     |    -     |    -     |
-- cmap / cnoremap  |    -   |   -    |    @    |   -    |   -    |    -     |    -     |    -     |
-- vmap / vnoremap  |    -   |   -    |    -    |   @    |   @    |    -     |    -     |    -     |
-- xmap / xnoremap  |    -   |   -    |    -    |   @    |   -    |    -     |    -     |    -     |
-- smap / snoremap  |    -   |   -    |    -    |   -    |   @    |    -     |    -     |    -     |
-- omap / onoremap  |    -   |   -    |    -    |   -    |   -    |    @     |    -     |    -     |
-- tmap / tnoremap  |    -   |   -    |    -    |   -    |   -    |    -     |    @     |    -     |
-- lmap / lnoremap  |    -   |   @    |    @    |   -    |   -    |    -     |    -     |    @     |
---------------------------------------------------------------------------------------------------+

local function get_current_win_cwd()
  local win = vim.api.nvim_get_current_win()
  local cwd = vim.fn.getcwd(win)
  return cwd
end

return {
  ["<leader>ms"] = {
    function()
      vim.system({ "tree" }, { text = true }, function(out)
        vim.print(out.stdout)
      end)
    end,
    "n",
    desc = "Show Current Directory Tree",
  },
  ["<leader>md"] = {
    function()
      local cwd = get_current_win_cwd()
      vim.ui.input({
        prompt = "Create New Directory: " .. cwd .. "/",
        completion = "dir_in_path",
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
      local cwd = get_current_win_cwd()
      vim.ui.input({
        prompt = "Create New File: " .. cwd .. "/",
        completion = "dir_in_path",
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
      local cwd = get_current_win_cwd()
      -- vim.cmd.echohl("Operator")
      vim.ui.input({
        prompt = "Delete File: " .. cwd .. "/",
        completion = "file_in_path",
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
      local cwd = get_current_win_cwd()
      vim.ui.input({
        prompt = "Delete Directory: " .. cwd .. "/",
        completion = "dir_in_path",
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
      }, function(input)
        if not input then
          return
        end
        local dir = vim.fn.fnamemodify(path, ":h")
        local new_name = dir .. "/" .. input
        local ok = pcall(vim.fn.rename, path, new_name)
        if ok then
          vim.cmd("e " .. new_name)
        end
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
}
