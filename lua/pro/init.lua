local id = my.env.register("env.pro")
my.env.set(id)

vim.keymap.set("n", "i", "<cmd>lua my.motion.NORMAL.backward_word_start()<cr>")
vim.keymap.set("x", "i", "<cmd>lua my.motion.VISUAL.backward_word_start()<cr>")
vim.keymap.set("o", "i", "<cmd>lua my.motion.OPERATOR.backward_word_start()<cr>")

vim.keymap.set("n", "o", "<cmd>lua my.motion.NORMAL.forward_word_end()<cr>")
vim.keymap.set("x", "o", "<cmd>lua my.motion.VISUAL.forward_word_end()<cr>")
vim.keymap.set("o", "o", "<cmd>lua my.motion.OPERATOR.forward_word_end()<cr>")

vim.keymap.set("n", "<space>i", "<cmd>lua my.motion.NORMAL.backward_word_end()<cr>")
vim.keymap.set("x", "<space>i", "<cmd>lua my.motion.VISUAL.backward_word_end()<cr>")
vim.keymap.set("o", "<space>i", "<cmd>lua my.motion.OPERATOR.backward_word_end()<cr>")

vim.keymap.set("n", "<space>o", "<cmd>lua my.motion.NORMAL.forward_word_start()<cr>")
vim.keymap.set("x", "<space>o", "<cmd>lua my.motion.VISUAL.forward_word_start()<cr>")
vim.keymap.set("o", "<space>o", "<cmd>lua my.motion.OPERATOR.forward_word_start()<cr>")

vim.keymap.set("n", "I", "<cmd>lua my.motion.NORMAL.backward_WORD_start()<cr>")
vim.keymap.set("x", "I", "<cmd>lua my.motion.VISUAL.backward_WORD_start()<cr>")
vim.keymap.set("o", "I", "<cmd>lua my.motion.OPERATOR.backward_WORD_start()<cr>")

vim.keymap.set("n", "O", "<cmd>lua my.motion.NORMAL.forward_WORD_end()<cr>")
vim.keymap.set("x", "O", "<cmd>lua my.motion.VISUAL.forward_WORD_end()<cr>")
vim.keymap.set("o", "O", "<cmd>lua my.motion.OPERATOR.forward_WORD_end()<cr>")

vim.keymap.set("n", "<space>I", "<cmd>lua my.motion.NORMAL.backward_WORD_end()<cr>")
vim.keymap.set("x", "<space>I", "<cmd>lua my.motion.VISUAL.backward_WORD_end()<cr>")
vim.keymap.set("o", "<space>I", "<cmd>lua my.motion.OPERATOR.backward_WORD_end()<cr>")
vim.keymap.set("n", "<S-space>I", "<cmd>lua my.motion.NORMAL.backward_WORD_end()<cr>")
vim.keymap.set("x", "<S-space>I", "<cmd>lua my.motion.VISUAL.backward_WORD_end()<cr>")
vim.keymap.set("o", "<S-space>I", "<cmd>lua my.motion.OPERATOR.backward_WORD_end()<cr>")

vim.keymap.set("n", "<space>O", "<cmd>lua my.motion.NORMAL.forward_WORD_start()<cr>")
vim.keymap.set("x", "<space>O", "<cmd>lua my.motion.VISUAL.forward_WORD_start()<cr>")
vim.keymap.set("o", "<space>O", "<cmd>lua my.motion.OPERATOR.forward_WORD_start()<cr>")
vim.keymap.set("n", "<S-space>O", "<cmd>lua my.motion.NORMAL.forward_WORD_start()<cr>")
vim.keymap.set("x", "<S-space>O", "<cmd>lua my.motion.VISUAL.forward_WORD_start()<cr>")
vim.keymap.set("o", "<S-space>O", "<cmd>lua my.motion.OPERATOR.forward_WORD_start()<cr>")

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

vim.keymap.set("n", "w", "i")
vim.keymap.set("n", "e", "a")
vim.keymap.set("n", "W", "<cmd>lua my.insert.NORMAL.first()<CR>")
vim.keymap.set("n", "E", "<cmd>lua my.insert.NORMAL.last()<CR>")

vim.keymap.set("n", "<space>w", "<cmd>lua my.insert.NORMAL.first_non_blank()<cr>")
vim.keymap.set("x", "<space>w", "<cmd>lua my.insert.VISUAL.first_non_blank()<cr>")

vim.keymap.set("n", "<space>e", "<cmd>lua my.insert.NORMAL.last_non_blank()<cr>")
vim.keymap.set("x", "<space>e", "<cmd>lua my.insert.VISUAL.last_non_blank()<cr>")

vim.keymap.set("n", "<space><space>w", "<cmd>lua my.insert.NORMAL.first()<CR>")
vim.keymap.set("x", "<space><space>w", "<cmd>lua my.insert.VISUAL.first()<CR>")

vim.keymap.set("n", "<space><space>e", "<cmd>lua my.insert.NORMAL.last()<CR>")
vim.keymap.set("x", "<space><space>e", "<cmd>lua my.insert.VISUAL.last()<CR>")

vim.keymap.set("n", "<S-space>H", "<cmd>lua my.insert.NORMAL.first_non_blank()<cr>")
vim.keymap.set("n", "<S-space>L", "<cmd>lua my.insert.NORMAL.last_non_blank()<cr>")
vim.keymap.set("n", "<S-space><S-space>H", "<cmd>lua my.insert.NORMAL.first()<cr>")
vim.keymap.set("n", "<S-space><S-space>L", "<cmd>lua my.insert.NORMAL.last()<cr>")

vim.keymap.set("n", "<bs>", "s")
vim.keymap.set("x", "<bs>", "c")
vim.keymap.set("o", "<bs>", "<esc>")
vim.keymap.set("s", "<bs>", " <bs>")

vim.keymap.set("n", "<M-l>", "la")
vim.keymap.set("n", "<M-h>", "hi")

vim.keymap.set("i", "<M-space><M-h>", "<cmd>lua my.motion.INSERT.first_non_blank()<cr>")
vim.keymap.set("i", "<M-space><M-l>", "<cmd>lua my.motion.INSERT.last_non_blank()<cr>")

vim.keymap.set("n", "<M-space><M-h>", "<cmd>lua my.insert.NORMAL.first_non_blank()<cr>")
vim.keymap.set("n", "<M-space><M-l>", "<cmd>lua my.insert.NORMAL.last_non_blank()<cr>")

vim.keymap.set("i", "<M-space><M-space><M-h>", "<Home>")
vim.keymap.set("i", "<M-space><M-space><M-l>", "<End>")

vim.keymap.set("n", "<M-space><M-space><M-h>", "<Home>i")
vim.keymap.set("n", "<M-space><M-space><M-l>", "<End>a")
