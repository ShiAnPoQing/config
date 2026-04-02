return {
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    run = function(plug)
      vim
        .system({ "yarn", "install" }, {
          cwd = plug.path .. "/app",
          text = true,
        })
        :wait()
    end,
    config = function()
      vim.g.mkdp_auto_close = true
      vim.g.mkdp_open_to_the_world = false
      vim.g.mkdp_open_ip = "127.0.0.1"
      vim.g.mkdp_port = "8888"
      vim.g.mkdp_browser = ""
      vim.g.mkdp_echo_preview_url = true
      vim.g.mkdp_page_title = "${name}"
      vim.g.mkdp_theme = "light"
    end,
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    lazy = true,
    depend = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
    ft = { "markdown" },
    key = {
      ["<leader>rd"] = {
        "<cmd>RenderMarkdown toggle<cr>",
        "n",
        ft = "markdown",
        desc = "Toggle Markdown Render",
      },
    },
    config = function()
      require("render-markdown").setup({
        -- completions = { lsp = { enabled = true } },
        enabled = true,
      })
    end,
  },
}
