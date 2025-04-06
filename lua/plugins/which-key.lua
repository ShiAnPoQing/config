return {
  "folke/which-key.nvim",
  lazy = true,
  config = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
    local wk = require("which-key")
    wk.setup({})
    wk.register({
      b = {
        name = "lsp buffer",
        s = { "<cmd>Telescope lsp_document_symbols<cr>", "LSP [B]uffer [S]ymbols" },
      },
      f = {
        name = "file", -- optional group name
        f = { "<cmd>Telescope find_files<cr>", "Find File" },
        g = { "<cmd>Telescope live_grep<cr>", "Find Live Grep" },
        h = { "<cmd>Telescope help_tags<cr>", "Find Help" },
        b = { "<cmd>Telescope buffers<cr>", "Find Buffers" },
        q = { "<cmd>Telescope quickfix<cr>", "Find Quickfix" },
        k = { "<cmd>Telescope keymaps<cr>", "Find Keymaps" },
        c = "Find ColorScheme",
        o = { "<cmd>Telescope oldfiles<cr>", "Find Old Files" },
        r = { "<cmd>Telescope resume<cr>", "Resume the previous telescope picker" },
        d = { "<cmd>Telescope diagnostics<cr>", "Lists Diagnostics for all open buffers or a specific buffe" },
        t = { "<cmd>Telescope treesitter<cr>", "Lists Function names, variables, from Treesitter" },
        ["1"] = "which_key_ignore", -- special label to hide it in the popup
      },
    }, { prefix = "<leader>" })
    wk.register({
      ["<leader>s"] = {
        name = "show something",
        k = "Show Press Key",
        ["fi"] = "Show File Info",
      },
      ["<leader>h"] = {
        name = "hidden something",
        k = "Hidden Press Key Show",
      },
      ["<M-x>"] = "Window Exchange",
    })
  end,
}
