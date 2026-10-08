local id = my.env.register("env.promax")
my.env.set(id)

vim.o.selection = "exclusive"
vim.o.guicursor = "n-v-c-sm-o:ver25,i-ci-ve:ver25-InsertModeCursor,r-cr:hor20,t:block-blinkon500-blinkoff500-TermCursor"
vim.api.nvim_set_hl(0, "InsertModeCursor", { fg = "#ffffff", bg = "#ffffff" })
---@diagnostic disable-next-line: param-type-mismatch
if not vim.list_contains(vim.opt.virtualedit:get() or {}, "onemore") then
  ---@diagnostic disable-next-line: param-type-mismatch
  vim.opt.virtualedit:append("onemore")
end

vim.keymap.set("n", "w", "<cmd>lua my.motion.NORMAL.backward_word_start()<cr>")
vim.keymap.set("x", "w", "<cmd>lua my.motion.VISUAL.backward_word_start()<cr>")
vim.keymap.set("o", "w", "<cmd>lua my.motion.OPERATOR.backward_word_start()<cr>")
vim.keymap.set("n", "<space>w", "<cmd>lua my.motion.NORMAL.backward_word_start()<cr>i")
-- vim.keymap.set("x", "<space>w", "")
-- vim.keymap.set("o", "<space>w", "")

vim.keymap.set("n", "e", "<cmd>lua my.motion.NORMAL.backward_word_end()<cr>")
vim.keymap.set("x", "e", "<cmd>lua my.motion.VISUAL.backward_word_end()<cr>")
vim.keymap.set("o", "e", "<cmd>lua my.motion.OPERATOR.backward_word_end()<cr>")
vim.keymap.set("n", "<space>e", "<cmd>lua my.motion.NORMAL.backward_word_end()<cr>i")

vim.keymap.set("n", "i", "<cmd>lua my.motion.NORMAL.forward_word_start()<cr>")
vim.keymap.set("x", "i", "<cmd>lua my.motion.VISUAL.forward_word_start()<cr>")
vim.keymap.set("o", "i", "<cmd>lua my.motion.OPERATOR.forward_word_start()<cr>")
vim.keymap.set("n", "<space>i", "<cmd>lua my.motion.NORMAL.forward_word_start()<cr>i")

vim.keymap.set("n", "o", "<cmd>lua my.motion.NORMAL.forward_word_end()<cr>")
vim.keymap.set("x", "o", "<cmd>lua my.motion.VISUAL.forward_word_end()<cr>")
vim.keymap.set("o", "o", "<cmd>lua my.motion.OPERATOR.forward_word_end()<cr>")
vim.keymap.set("n", "<space>o", "<cmd>lua my.motion.NORMAL.forward_word_end()<cr>i")

vim.keymap.set("n", "W", "<cmd>lua my.motion.NORMAL.backward_WORD_start()<cr>")
vim.keymap.set("x", "W", "<cmd>lua my.motion.VISUAL.backward_WORD_start()<cr>")
vim.keymap.set("o", "W", "<cmd>lua my.motion.OPERATOR.backward_WORD_start()<cr>")
vim.keymap.set("n", "<space>W", "<cmd>lua my.motion.NORMAL.backward_WORD_start()<cr>i")
vim.keymap.set("n", "<S-space>W", "<cmd>lua my.motion.NORMAL.backward_WORD_start()<cr>i")

vim.keymap.set("n", "E", "<cmd>lua my.motion.NORMAL.backward_WORD_end()<cr>")
vim.keymap.set("x", "E", "<cmd>lua my.motion.VISUAL.backward_WORD_end()<cr>")
vim.keymap.set("o", "E", "<cmd>lua my.motion.OPERATOR.backward_WORD_end()<cr>")
vim.keymap.set("n", "<space>E", "<cmd>lua my.motion.NORMAL.backward_WORD_end()<cr>i")
vim.keymap.set("n", "<S-space>E", "<cmd>lua my.motion.NORMAL.backward_WORD_end()<cr>i")

vim.keymap.set("n", "I", "<cmd>lua my.motion.NORMAL.forward_WORD_start()<cr>")
vim.keymap.set("x", "I", "<cmd>lua my.motion.VISUAL.forward_WORD_start()<cr>")
vim.keymap.set("o", "I", "<cmd>lua my.motion.OPERATOR.forward_WORD_start()<cr>")
vim.keymap.set("n", "<space>I", "<cmd>lua my.motion.NORMAL.forward_WORD_start()<cr>i")
vim.keymap.set("n", "<S-space>I", "<cmd>lua my.motion.NORMAL.forward_WORD_start()<cr>i")

vim.keymap.set("n", "O", "<cmd>lua my.motion.NORMAL.forward_WORD_end()<cr>")
vim.keymap.set("x", "O", "<cmd>lua my.motion.VISUAL.forward_WORD_end()<cr>")
vim.keymap.set("o", "O", "<cmd>lua my.motion.OPERATOR.forward_WORD_end()<cr>")
vim.keymap.set("n", "<space>O", "<cmd>lua my.motion.NORMAL.forward_WORD_end()<cr>")
vim.keymap.set("n", "<S-space>O", "<cmd>lua my.motion.NORMAL.forward_WORD_end()<cr>")

vim.keymap.set("n", "<space>h", "<cmd>lua my.motion.NORMAL.first_non_blank()<cr>")
vim.keymap.set("x", "<space>h", "<cmd>lua my.motion.VISUAL.first_non_blank()<cr>")
vim.keymap.set("o", "<space>h", "<cmd>lua my.motion.OPERATOR.first_non_blank()<cr>")

vim.keymap.set("n", "<space>l", "<cmd>lua my.motion.NORMAL.last_non_blank()<cr>")
vim.keymap.set("x", "<space>l", "<cmd>lua my.motion.VISUAL.last_non_blank()<cr>")
vim.keymap.set("o", "<space>l", "<cmd>lua my.motion.OPERATOR.last_non_blank()<cr>")

vim.keymap.set("n", "<space><space>h", "<cmd>lua my.motion.NORMAL.first()<cr>")
vim.keymap.set("x", "<space><space>h", "<cmd>lua my.motion.VISUAL.first()<cr>")
vim.keymap.set("o", "<space><space>h", "<cmd>lua my.motion.OPERATOR.first()<cr>")

vim.keymap.set("n", "<space><space>l", "<cmd>lua my.motion.NORMAL.last()<cr>")
vim.keymap.set("x", "<space><space>l", "<cmd>lua my.motion.VISUAL.last()<cr>")
vim.keymap.set("o", "<space><space>l", "<cmd>lua my.motion.OPERATOR.last()<cr>")

vim.keymap.set("n", "<S-space>H", "<cmd>lua my.insert.NORMAL.first_non_blank()<cr>")
vim.keymap.set("n", "<S-space>L", "<cmd>lua my.insert.NORMAL.last_non_blank()<cr>")
vim.keymap.set("n", "<S-space><S-space>H", "<cmd>lua my.insert.NORMAL.first()<cr>")
vim.keymap.set("n", "<S-space><S-space>L", "<cmd>lua my.insert.NORMAL.last()<cr>")

vim.keymap.set("i", "<S-space>H", "<cmd>lua my.motion.INSERT.first_non_blank()<cr>")
vim.keymap.set("i", "<S-space>L", "<cmd>lua my.motion.INSERT.last_non_blank()<cr>")
vim.keymap.set("i", "<S-space><S-space>H", "<cmd>lua my.motion.INSERT.first()<cr>")
vim.keymap.set("i", "<S-space><S-space>L", "<cmd>lua my.motion.INSERT.last()<cr>")

vim.keymap.set("i", "jk", "<cmd>lua my.insert.stopinsert()<cr>")
vim.keymap.set("i", "jj", "<cmd>lua my.insert.stopinsert()<cr>")
vim.keymap.set("i", "kk", "<cmd>lua my.insert.stopinsert()<cr>")
vim.keymap.set("i", "kj", "<cmd>lua my.insert.stopinsert()<cr>")
vim.keymap.set("i", "<esc>", "<cmd>lua my.insert.stopinsert()<cr>")

vim.keymap.set("n", "s", "i", { nowait = true })
vim.keymap.set("n", "S", "i", { nowait = true })

_G.test = function(type)
  if type == "char" then
    local start_pos = vim.fn.getpos("'[")
    local end_pos = vim.fn.getpos("']")
    local text = vim.api.nvim_buf_get_text(0, start_pos[2] - 1, start_pos[3] - 1, end_pos[2] - 1, end_pos[3], {})[1]
    local char = vim.fn.getcharstr()
    if vim.fn.keytrans(char) == "<Esc>" then
      return
    end
    text = vim.fn["repeat"](char, #text)
    vim.api.nvim_buf_set_text(0, start_pos[2] - 1, start_pos[3] - 1, end_pos[2] - 1, end_pos[3], { text })
  end
end

vim.keymap.set("n", "r", function()
  vim.api.nvim_create_autocmd("CmdAtom", {
    callback = function(ev)
      ev.data.lhs = vim.fn.keytrans(ev.data.lhs)
      vim.print(ev.data)
      return true
    end,
  })
  vim.api.nvim_feedkeys(vim.keycode('<Cmd>lua vim.o.operatorfunc = "v:lua.test"<CR>'), "nt", false)
  vim.api.nvim_feedkeys(vim.v.count1 .. "g@", "n", false)
end)

vim.keymap.set("n", "<bs>", "i<bs>")
vim.keymap.set("x", "<bs>", "s")
vim.keymap.set("n", "<S-bs>", "s")
vim.keymap.set("x", "<S-bs>", "s")

vim.keymap.set("n", "<M-w>", "<cmd>lua my.motion.NORMAL.backward_word_start()<cr>i")
vim.keymap.set("n", "<M-e>", "<cmd>lua my.motion.NORMAL.backward_word_end()<cr>i")
vim.keymap.set("n", "<M-i>", "<cmd>lua my.motion.NORMAL.forward_word_start()<cr>i")
vim.keymap.set("n", "<M-o>", "<cmd>lua my.motion.NORMAL.forward_word_end()<cr>i")

vim.keymap.set("n", "<M-h>", "hi")
vim.keymap.set("n", "<M-j>", "ji")
vim.keymap.set("n", "<M-k>", "ki")
vim.keymap.set("n", "<M-l>", "li")

vim.keymap.set("n", "<M-H>", "3hi")
vim.keymap.set("n", "<M-J>", "3ji")
vim.keymap.set("n", "<M-K>", "3ki")
vim.keymap.set("n", "<M-L>", "3li")
