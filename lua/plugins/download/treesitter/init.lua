return {
  "nvim-treesitter/nvim-treesitter",
  version = "main",
  run = function()
    vim.cmd([[TSUpdate]])
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
      "javascriptreact",
      "typescriptreact",
      "kdl",
      "latex",
      "cmake",
      "make",
      "yaml",
      "markdown",
      "bash",
      "html",
      "css",
      "vimdoc",
      "xml",
      "qml",
      "tex",
      "jsdoc",
      "json",
      "jsonc",
      "diff",
      "query",
      "vue",
    }
    local TS = require("nvim-treesitter")
    TS.setup({
      indent = { enable = true },
      highlight = { enable = true },
      folds = { enable = true },
      ensure_installed = langs,
    })
    TS.install(langs)
    vim.api.nvim_create_autocmd("FileType", {
      pattern = langs,
      callback = function()
        vim.treesitter.start()
      end,
    })
  end,
}
