return {
  "stevearc/conform.nvim",
  enabled = true,
  opts = {},
  config = function()
    local conform = require("conform")
    conform.setup({
      formatters_by_ft = {
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        svelte = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "mdformat", "markdownlint" },
        graphql = { "prettier" },
        liquid = { "prettier" },
        lua = { "stylua" },
        python = { "isort", "black" },
        -- json = { "jq" },
        vue = { "prettier" },
        tex = { "latexindent" },
      },

      format_on_save = {
        -- These options will be passed to conform.format()
        timeout_ms = 500,
        lsp_fallback = true,
      },
    })
    conform.formatters.latexindent = {
      prepend_args = { "-l", vim.fn.expand("~/.config/latexindent/indentconfig.yaml"), "-m" },
    }
    require("parse-keymap").add({
      ["<leader>="] = {
        function()
          conform.format({ async = true, lsp_fallback = true })
        end,
        { "n", "x" },
        { desc = "Format the current buffer" },
      },
    })
  end,
}
