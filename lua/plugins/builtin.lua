vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_difftool = true
vim.g.loaded_undotree_plugin = true

return {
  {
    name = "nvim.difftool",
    cmd = "DiffTool",
    before = function()
      vim.g.loaded_difftool = nil
    end,
  },
  {
    name = "netrw",
    cmd = {
      "Explore",
      "Hexplore",
      "Lexplore",
      "Ntree",
      "Nexplore",
      "Pexplore",
      "Rexplore",
      "Sexplore",
      "Texplore",
      "Vexplore",
    },
    before = function()
      vim.g.loaded_netrw = nil
      vim.g.loaded_netrwPlugin = nil
    end,
  },
  {
    name = "nvim.undotree",
    cmd = "Undotree",
    before = function()
      vim.g.loaded_undotree_plugin = nil
    end,
  },
}
