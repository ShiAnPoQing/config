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
local target_win
local path

local function get_mouse_cursor(mousepos)
  return vim.api.nvim_buf_get_extmarks(
    0,
    mc,
    { mousepos.line - 1, mousepos.column - 1 },
    { mousepos.line - 1, mousepos.column - 1 }
  )[1]
end

--- reset path
--- 当前位置的光标不是 rollback 的目标光标
--- 则删除当前位置的光标，也表明历史断了，所以重置历史，并结束
local function reset_path(cursor)
  pcall(vim.api.nvim_buf_del_extmark, 0, mc, cursor[1])
  path = {}
end

--- advance path
--- 创建光标，更新历史，新光标成为 head
local function advance_path(mousepos)
  local ok = pcall(vim.api.nvim_mcursor, 0, { mousepos.line, mousepos.column - 1 })
  if not ok then
    return
  end
  local cursor = get_mouse_cursor(mousepos)
  if cursor then
    table.insert(path, cursor[1])
  end
end

--- rollback path
--- 当前位置的光标是我们最后一个光标的前一个：rollback action
local function rollback_path(mousepos)
  pcall(vim.api.nvim_buf_del_extmark, 0, mc, path[#path])
  table.remove(path, #path)
  table.remove(path, #path)
  advance_path(mousepos)
end

local function should_reset_path(cursor)
  return cursor and cursor[1] ~= path[#path - 1]
end

local function should_rollback_path(cursor)
  return cursor and cursor[1] == path[#path - 1]
end

return {
  ["<C-LeftMouse>"] = {
    function()
      local mousepos = vim.fn.getmousepos()
      target_win = mousepos.winid
      --- Avoid using the native `<C-LeftMouse>`,
      --- as exiting Insert mode causes the multicursor to lose track,
      --- resulting in a misalignment between the primary and secondary cursors.
      local cursor = get_mouse_cursor(mousepos)
      if cursor then
        pcall(vim.api.nvim_buf_del_extmark, 0, mc, cursor[1])
      else
        pcall(vim.api.nvim_mcursor, 0, { mousepos.line, mousepos.column - 1 })
        path = { get_mouse_cursor(mousepos)[1] }
      end
    end,
    { "n", "i" },
  },
  ["<C-LeftDrag>"] = {
    function()
      local mousepos = vim.fn.getmousepos()
      if mousepos.winid ~= target_win then
        return
      end
      local cursor = get_mouse_cursor(mousepos)
      if should_reset_path(cursor) then
        reset_path(cursor)
        return
      end
      if should_rollback_path(cursor) then
        rollback_path(mousepos)
        return
      end
      advance_path(mousepos)
    end,
    { "n", "i" },
  },
  ["<C-LeftRelease>"] = {
    {
      function()
        path = {}
      end,
      "n",
    },
    {
      function()
        path = {}
        --- Re-enter Insert mode and activate cascading.
        if vim.fn.col(".") == 1 then
          return "<esc>i"
        end
        return "<esc>a"
      end,
      "i",
      expr = true,
    },
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
