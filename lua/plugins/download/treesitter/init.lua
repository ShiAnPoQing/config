return {
  "nvim-treesitter/nvim-treesitter",
  version = "main",
  run = function()
    vim.cmd("TSUpdate")
  end,
  config = function()
    local langs = {
      "c",
      "cpp",
      "javascript",
      "typescript",
      "tsx",
      "lua",
      "python",
      "go",
      "java",
      "rust",
      "kdl",
      "latex",
      "cmake",
      "git_config",
      "gitignore",
      "make",
      "yaml",
      "markdown",
      "bash",
      "html",
      "css",
      "vimdoc",
      "xml",
      "jsdoc",
      "json",
      "diff",
      "query",
      "vue",
    }
    local TS = require("nvim-treesitter")
    TS.setup({})
    TS.install(langs)
    vim.api.nvim_create_autocmd("FileType", {
      pattern = vim.list_extend(langs, { "typescriptreact", "javascriptreact", "tex", "jsonc" }),
      callback = function()
        vim.treesitter.start()
      end,
    })
  end,
}
