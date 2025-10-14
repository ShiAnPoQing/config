return {
  ["<space>gv"] = { "`[v`]", { "n" }, desc = "Visual Select last inserted text" },
  -- virtualedit = "all"
  ["<space>v"] = {
    {
      "<C-v>",
      "x",
    },
    {
      function()
        local line = vim.api.nvim_get_current_line()
        local cursor = vim.api.nvim_win_get_cursor(0)
        if cursor[2] + 1 == #line then
          vim.opt.virtualedit = ""
          vim.api.nvim_exec2(
            [[
          execute "normal! $\<C-v>"
          ]],
            {}
          )
          vim.api.nvim_create_autocmd("ModeChanged", {
            group = vim.api.nvim_create_augroup("CustomModeChanged", { clear = true }),
            callback = function(ev)
              vim.opt.virtualedit = "all"
              return true
            end,
          })
        else
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-v>", true, false, true), "n", true)
        end
      end,
      "n",
    },
    desc = "Start visual block mode",
  },
}
