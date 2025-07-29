return {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("todo-comments").setup({
      signs = true, -- show icons in the signs column
      sign_priority = 8, -- sign priority
      -- keywords recognized as todo comments
      keywords = {
        FIX = {
          icon = " ", -- icon used for the sign, and in search results
          color = "error", -- can be a hex color, or a named color (see below)
          alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
          -- signs = false, -- configure signs for some keywords individually
        },
        TODO = { icon = " ", color = "info" },
        HACK = { icon = " ", color = "warning" },
        WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
        PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
        TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
      },
    })

    require("plugin-keymap").add({
      ["]t"] = {
        function()
          require("todo-comments").jump_next()
        end,
        "n",
        { desc = "Next todo comment" },
      },
      ["[t"] = {
        function()
          require("todo-comments").jump_prev()
        end,
        "n",
        { desc = "Previous todo comment" },
      },
      ["<leader>fm"] = {
        "<cmd>TodoTelescope<cr>",
        "n",
        { desc = "TodoTelescope" },
      },
    })

    -- You can also specify a list of valid jump keywords
    -- vim.keymap.set("n", "]t", function()
    --   require("todo-comments").jump_next({ keywords = { "ERROR", "WARNING" } })
    -- end, { desc = "Next error/warning todo comment" })
  end,
}
