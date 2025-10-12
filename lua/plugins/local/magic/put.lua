return {
  ["0pk"] = {
    function()
      require("magic.magic-line").magic_line({
        dir = "up",
        callback = function(opts)
          vim.api.nvim_win_set_cursor(0, { opts.line, opts.virt_col })
          vim.cmd.put()
        end,
      })
    end,
    "n",
  },
  ["0pj"] = {
    function()
      require("magic.magic-line").magic_line({
        dir = "down",
        callback = function(opts)
          vim.api.nvim_win_set_cursor(0, { opts.line, opts.virt_col })
          vim.cmd.put()
        end,
      })
    end,
    "n",
  },
}
