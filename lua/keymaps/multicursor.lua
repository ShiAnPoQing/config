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
local mc = vim.api.nvim_create_namespace("nvim.multicursor")

return {
  --- multi-cursor yank
  --- 1. 目前指针对于 unamed register 有效，同时考虑 */+ 寄存器继承问题
  ---    因为 "ay 总是需要显式 yank，所以有待考量
  --- 2. 非显式 yank 时，默认合并
  --- 3. 显式 yank 时，不合并
  -- ["y"] = {
  --   function()
  --     --- For clipboard = unamedplus
  --     --- yy ==
  --     -- vim.print(vim.v.register)
  --     if #vim.api.nvim_buf_get_extmarks(0, mc, 0, -1, { limit = 1 }) > 0 then
  --       yanking = true
  --       multicursor_yanks = {}
  --       vim.api.nvim_create_autocmd("CmdAtom", {
  --         callback = function(ev)
  --           local data = ev.data --[[@as vim.event.cmdatom.data]]
  --           --- Perform an explicit yank during multi-cursor editing; do not concatenate or merge.
  --           --- 保留原始行为
  --           -- if data.operator == "y" and data.reg and data.reg ~= "" then
  --           -- else
  --           --   vim.fn.setreg(data.reg)
  --           -- end
  --           -- vim.print(multicursor_yanks)
  --           yanking = nil
  --           multicursor_yanks = nil
  --           return true
  --         end,
  --       })
  --     end
  --     return "y"
  --   end,
  --   "n",
  --   expr = true,
  -- },
  ["<C-LeftMouse>"] = {
    function()
      my.multicursor.mouse.click()
    end,
    { "n", "i" },
  },
  ["<C-LeftDrag>"] = {
    function()
      my.multicursor.mouse.drag()
    end,
    { "n", "i" },
  },
  ["<C-LeftRelease>"] = {
    function()
      my.multicursor.mouse.release()
    end,
    { "n", "i" },
  },
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
        local count = vim.v.count1
        local cursor = vim.api.nvim_win_get_cursor(0)
        local marks = vim.api.nvim_buf_get_extmarks(0, mc, { cursor[1] - 1, cursor[2] }, -1)
        for i = 1, math.min(count, #marks) do
          local mark = marks[i]
          if mark then
            vim.api.nvim_buf_del_extmark(0, mc, mark[1])
          end
        end
        return "<esc>"
      end
      --- live mirroring
      if vim.v.operator == "c" then
        return 'c0<esc>"_s'
      end
      return "c"
    end,
    "o",
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

-- local mc = vim.api.nvim_create_namespace("nvim.multicursor")
-- local count = vim.v.count1
-- if #vim.api.nvim_buf_get_extmarks(0, mc, 0, -1, { limit = 1 }) > 0 then
--   ---live mirroring
--   if count == 1 then
--     vim.keymap.set("o", "<Plug>___test", function()
--       vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("0v$h", true, false, true), "nx", false)
--       -- vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("0<C-d><C-f>", true, false, true), "n", false)
--     end)
--     return "<Plug>___test"
--   else
--     --- can't live mirroring
--     vim.schedule(function()
--       vim.api.nvim_feedkeys(
--         vim.api.nvim_replace_termcodes((count - 1) .. "dd", true, false, true),
--         "nt",
--         false
--       )
--       vim.api.nvim_feedkeys("cc", "m", false)
--     end)
--     return "<esc>"
--   end
-- end
