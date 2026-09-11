vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = vim.api.nvim_create_augroup("custom-checktime", { clear = true }),
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.hl.hl_op({
      higroup = "CurSearch",
    })
  end,
})

-- vim.api.nvim_create_autocmd("VimResized", {
--   group = vim.api.nvim_create_augroup("custom-resize", { clear = true }),
--   callback = function()
--     local current_tab = vim.fn.tabpagenr()
--     vim.cmd("tabdo wincmd =")
--     vim.cmd("tabnext " .. current_tab)
--   end,
-- })

vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*",
  callback = function()
    vim.api.nvim_exec2([[silent! normal! g`"zv]], { output = false })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("custom-man-unlisted", { clear = true }),
  pattern = { "man" },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
  end,
})

vim.api.nvim_create_autocmd("CmdwinEnter", {
  callback = function(ev)
    local buf = ev.buf
    -- NOTE: nowait = true
    --     Global keymap "q:" for toggle cmdwin, so cmdwin can't have "q:" keymap
    --     If I map "q:" to <nop> When I press q, will waiting for next key
    --     I just want to press "q", then no waiting, just quit cmdwin,
    --     So I must make "q" nowait, and can't have "q:" buffer keymap, Even can't buffer map "q:" to map
    --
    --      If I do this: Press q, still will waiting
    --          vim.keymap.set("n", "q", "<cmd>close<cr>", { buf = buf, nowait = true, desc = "quit cmdwin" })
    --          vim.keymap.set("n", "q:", "<nop>", { buf = buf })
    --      If I do this: OK
    --          vim.keymap.set("n", "q", "<cmd>close<cr>", { buf = buf, nowait = true, desc = "quit cmdwin" })

    vim.keymap.set("n", "q", "<cmd>close<cr>", { buf = buf, nowait = true, desc = "quit cmdwin" })
    vim.keymap.set("n", "<esc>", "<cmd>close<cr>", { buf = buf, desc = "quit cmdwin" })
    --- <CR>: Execute cursor command and quit cmdwin
    --- Override global <CR> keymap
    vim.keymap.set({ "n", "i" }, "<cr>", "<cr>", { buf = buf })
    --- <S-CR>: Execute cursor command and reopen open
    vim.keymap.set({ "n", "i" }, "<S-cr>", function()
      local type = vim.fn.getcmdwintype()
      return "<cr>q" .. type
    end, { buf = buf, expr = true, desc = "execute command in cmdwin and reopen" })
    --- <C-f>: Toggle cmdwin in command-line
    --- c mode: <C-f> will open corresponding cmdwin
    --- so I make cmdwin <C-f> goback, just for toggle cmdwin
    vim.keymap.set({ "n", "i" }, "<C-f>", "<C-c>", { buf = buf })

    --- Goto cmdwin
    vim.keymap.set("n", "<tab>j", function()
      require("builtin.cmdwin").switch_cmdwin(1)
    end, { buf = buf, desc = "Switch next cmdwin[q: or q/ or q?]" })
    vim.keymap.set("n", "<tab>k", function()
      require("builtin.cmdwin").switch_cmdwin(-1)
    end, { buf = buf, desc = "Switch prev cmdwin[q: or q/ or q?]" })
    pcall(vim.keymap.del, { "n", "i" }, "<tab>", { buf = buf })
  end,
})

--- Issue: when recording, Press q can't stop recording, because has q: q/ q? q- keymap
--- Solution: When recording, make sure "q" nowaiting for buffers
local function set_nowait_q()
  local buf = vim.api.nvim_get_current_buf()
  vim.keymap.set({ "n", "x" }, "q", "q", { nowait = true, buf = buf })
  return buf
end

vim.api.nvim_create_autocmd("RecordingEnter", {
  callback = function()
    local bufs = { set_nowait_q() }
    local id = vim.api.nvim_create_autocmd("BufEnter", {
      callback = function()
        table.insert(bufs, set_nowait_q())
      end,
    })
    vim.api.nvim_create_autocmd("RecordingLeave", {
      callback = function()
        vim.api.nvim_del_autocmd(id)
        for _, buf in ipairs(bufs) do
          pcall(vim.keymap.del, { "n", "x" }, "q", { buf = buf })
        end
        return true
      end,
    })
  end,
})
