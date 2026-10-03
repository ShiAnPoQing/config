--- @class my.motion.INSERT
local M = {}

function M.last_non_blank()
  --- 创建临时 keymap 使其进入 feedkeys 流: <esc><F1000>a,
  --- CmdAtom 删除临时 keymap
  -- {
  --   changed = false,
  --   lhs = "<Plug>__temp__",
  --   moved = true,
  --   pos = { 58, 12 },
  --   type = "mapping",
  --   undoseq = 2028
  -- }
  vim.keymap.set("n", "<Plug>__temp__", function()
    --- like native: insert mode motion auto follow
    vim.bo.follow = true
    my.motion.line_last_non_blank()
    vim.bo.follow = false
  end)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Plug>__temp__", true, false, true), "mt", false)
  vim.api.nvim_feedkeys("a", "nt", false)

  vim.api.nvim_create_autocmd("CmdAtom", {
    callback = function(ev)
      if vim.fn.keytrans(ev.data.lhs) == "<Plug>__temp__" then
        vim.keymap.del("n", "<Plug>__temp__")
        return true
      end
    end,
  })
end

function M.first_non_blank()
  vim.keymap.set("n", "<Plug>__temp__", function()
    --- like native: insert mode motion auto follow
    vim.bo.follow = true
    --- ISSUE: if cursor is at line first non blank, feedkey <Esc>, the cursor will not be at the line first non blank
    my.motion.NORMAL._line_first_non_blank(-1)
    vim.bo.follow = false
  end)

  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Plug>__temp__", true, false, true), "mt", false)
  vim.api.nvim_feedkeys("i", "nt", false)

  vim.api.nvim_create_autocmd("CmdAtom", {
    callback = function(ev)
      if vim.fn.keytrans(ev.data.lhs) == "<Plug>__temp__" then
        vim.keymap.del("n", "<Plug>__temp__")
        return true
      end
    end,
  })
end

return M
