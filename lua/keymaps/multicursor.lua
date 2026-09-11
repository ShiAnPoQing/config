---------------------------------------------------------------------------------------------------+
-- Commands \ Modes | Normal | Insert | Command | Visual | Select | Operator | Terminal | Lang-Arg |
-- ================================================================================================+
-- map  / noremap   |    @   |   -    |    -    |   @    |   @    |    @     |    -     |    -     |
-- nmap / nnoremap  |    @   |   -    |    -    |   -    |   -    |    -     |    -     |    -     |
-- map! / noremap!  |    -   |   @    |    @    |   -    |   -    |    -     |    -     |    -     |
-- imap / inoremap  |    -   |   @    |    -    |   -    |   -    |    -     |    -     |    -     |
-- cmap / cnoremap  |    -   |   -    |    @    |   -    |   -    |    -     |    -     |    -     |
-- vmap / vnoremap  |    -   |   -    |    -    |   @    |   @    |    -     |    -     |    -     |
-- xmap / xnoremap  |    -   |   -    |    -    |   @    |   -    |    -     |    -     |    -     |
-- smap / snoremap  |    -   |   -    |    -    |   -    |   @    |    -     |    -     |    -     |
-- omap / onoremap  |    -   |   -    |    -    |   -    |   -    |    @     |    -     |    -     |
-- tmap / tnoremap  |    -   |   -    |    -    |   -    |   -    |    -     |    @     |    -     |
-- lmap / lnoremap  |    -   |   @    |    @    |   -    |   -    |    -     |    -     |    @     |
---------------------------------------------------------------------------------------------------+

return {
  ["q-"] = {
    function()
      vim.cmd("normal! 1q=")
      vim.api.nvim_create_autocmd("CmdAtom", {
        callback = function(ev)
          if ev.data.lhs == "q-" then
            return -- Skip the mapping itself.
          end
          vim.cmd("normal! 2q=")
          return true -- Delete the handler.
        end,
      })
    end,
    "n",
    exclude_ft = { "cmd", "msg", "pager", "dialog" },
    desc = "q-{motion}: multicursor: follow {motion} once",
  },
  -- dc
  ["c"] = {
    function()
      if vim.v.operator == "d" then
        local cursor = vim.api.nvim_win_get_cursor(0)
        local ns_id = vim.api.nvim_create_namespace("nvim.multicursor")
        local marks = vim.api.nvim_buf_get_extmarks(0, ns_id, { cursor[1] - 1, cursor[2] }, -1)
        local target_mark = marks[1]
        if target_mark then
          vim.api.nvim_buf_del_extmark(0, ns_id, target_mark[1])
        end
        return "<esc>"
      end
      return "c"
    end,
    "o",
    desc = "dc: multicursor: delete next cursor in the current buffer",
    expr = true,
  },
  -- dC
  ["C"] = {
    function()
      if vim.v.operator == "d" then
        local cursor = vim.api.nvim_win_get_cursor(0)
        local ns_id = vim.api.nvim_create_namespace("nvim.multicursor")
        local marks = vim.api.nvim_buf_get_extmarks(0, ns_id, 0, { cursor[1] - 1, cursor[2] })
        local target_mark = marks[#marks]
        if target_mark then
          vim.api.nvim_buf_del_extmark(0, ns_id, target_mark[1])
        end
        return "<esc>"
      end
      return "C"
    end,
    "o",
    expr = true,
    desc = "dC: multicursor: delete previous cursor in the current buffer",
  },
  ["ac"] = {
    function()
      if vim.v.operator == "d" then
        vim.api.nvim_buf_clear_namespace(0, vim.api.nvim_create_namespace("nvim.multicursor"), 0, -1)
        return "<esc>"
      end
      return "ac"
    end,
    "o",
    expr = true,
    desc = [[ dac: multicursor: Clears multicursors in the current buffer ]],
  },
  ["<S-space>h"] = {
    function()
      vim.cmd("normal! 1q=")
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<space>h", true, false, true), "mt", false)
      vim.api.nvim_create_autocmd("CmdAtom", {
        callback = function()
          vim.cmd("normal! 2q=")
          return true
        end,
      })
    end,
    "n",
  },
  ["<S-space>l"] = {
    function()
      vim.cmd("normal! 1q=")
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<space>l", true, false, true), "mt", false)
      vim.api.nvim_create_autocmd("CmdAtom", {
        callback = function()
          vim.cmd("normal! 2q=")
          return true
        end,
      })
    end,
    "n",
  },
  ["<S-space><S-space>h"] = {
    function()
      vim.cmd("normal! 1q=")
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<space><space>h", true, false, true), "mt", false)
      vim.api.nvim_create_autocmd("CmdAtom", {
        callback = function()
          vim.cmd("normal! 2q=")
          return true
        end,
      })
    end,
    "n",
  },
  ["<S-space><S-space>l"] = {
    function()
      vim.cmd("normal! 1q=")
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<space><space>l", true, false, true), "mt", false)
      vim.api.nvim_create_autocmd("CmdAtom", {
        callback = function()
          vim.cmd("normal! 2q=")
          return true
        end,
      })
    end,
    "n",
  },
}
