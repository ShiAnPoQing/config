return {
  dir = vim.fn.stdpath("config") .. "/lua/custom/plugins/parse-keymap",
  name = "parse-keymap",
  config = function(opt)
    local parse_keymap = require("parse-keymap").setup()
    vim.api.nvim_create_autocmd("BufReadPre", {
      pattern = "*",
      callback = function()
        parse_keymap.del({
          ["in"] = { "x" },
          ["d0i"] = { "n" },
          ["d0o"] = { "n" },
        })
        parse_keymap.add({
          -- ["i"] = { "ge", "n" },
          -- ["e"] = { "w", "n" },
          -- ["o"] = { "e", "n" },
          -- ["w"] = { "b", "n" },
          -- ["d"] = { "h", "n" },
          -- ["f"] = { "l", "n" },
          -- ["s"] = { "i", "n" },
          -- ["l"] = { "a", "n" },

          -- ["e"] = { "ge", "n" },
          -- ["i"] = { "w", "n" },
          -- ["o"] = { "e", "n" },
          -- ["w"] = { "b", "n" },
          -- ["d"] = { "h", "n" },
          -- ["f"] = { "k", "n" },
          -- ["k"] = { "l", "n" },
          -- ["a"] = { "i", "n" },
          -- [";"] = { "a", "n" },
          -- ["jj"] = { "<esc>", "i" },
          -- ["kk"] = { "<esc>", "i" },
          -- ["jk"] = { "<esc>", "i" },
          -- ["kj"] = { "<esc>", "i" },
          -- ["ff"] = { "<esc>", "i" },
          -- ["dd"] = { "<esc>", "i" },
          -- ["df"] = { "<esc>", "i" },
          -- ["fd"] = { "<esc>", "i" },
        })
      end,
    })
  end,
}
