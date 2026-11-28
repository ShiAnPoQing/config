local id = my.env.register("env.pro")
my.env.set(id)

my.keymap.set("n", "i", "<cmd>lua my.motion.NORMAL.backward_word_start()<cr>")
my.keymap.set("x", "i", "<cmd>lua my.motion.VISUAL.backward_word_start()<cr>")
my.keymap.set("o", "i", "<cmd>lua my.motion.OPERATOR.backward_word_start()<cr>")

my.keymap.set("n", "o", "<cmd>lua my.motion.NORMAL.forward_word_end()<cr>")
my.keymap.set("x", "o", "<cmd>lua my.motion.VISUAL.forward_word_end()<cr>")
my.keymap.set("o", "o", "<cmd>lua my.motion.OPERATOR.forward_word_end()<cr>")

my.keymap.set("n", "<space>i", "<cmd>lua my.motion.NORMAL.backward_word_end()<cr>")
my.keymap.set("x", "<space>i", "<cmd>lua my.motion.VISUAL.backward_word_end()<cr>")
my.keymap.set("o", "<space>i", "<cmd>lua my.motion.OPERATOR.backward_word_end()<cr>")

my.keymap.set("n", "<space>o", "<cmd>lua my.motion.NORMAL.forward_word_start()<cr>")
my.keymap.set("x", "<space>o", "<cmd>lua my.motion.VISUAL.forward_word_start()<cr>")
my.keymap.set("o", "<space>o", "<cmd>lua my.motion.OPERATOR.forward_word_start()<cr>")

my.keymap.set("n", "I", "<cmd>lua my.motion.NORMAL.backward_WORD_start()<cr>")
my.keymap.set("x", "I", "<cmd>lua my.motion.VISUAL.backward_WORD_start()<cr>")
my.keymap.set("o", "I", "<cmd>lua my.motion.OPERATOR.backward_WORD_start()<cr>")

my.keymap.set("n", "O", "<cmd>lua my.motion.NORMAL.forward_WORD_end()<cr>")
my.keymap.set("x", "O", "<cmd>lua my.motion.VISUAL.forward_WORD_end()<cr>")
my.keymap.set("o", "O", "<cmd>lua my.motion.OPERATOR.forward_WORD_end()<cr>")

my.keymap.set("n", "<space>I", "<cmd>lua my.motion.NORMAL.backward_WORD_end()<cr>")
my.keymap.set("x", "<space>I", "<cmd>lua my.motion.VISUAL.backward_WORD_end()<cr>")
my.keymap.set("o", "<space>I", "<cmd>lua my.motion.OPERATOR.backward_WORD_end()<cr>")
my.keymap.set("n", "<S-space>I", "<cmd>lua my.motion.NORMAL.backward_WORD_end()<cr>")
my.keymap.set("x", "<S-space>I", "<cmd>lua my.motion.VISUAL.backward_WORD_end()<cr>")
my.keymap.set("o", "<S-space>I", "<cmd>lua my.motion.OPERATOR.backward_WORD_end()<cr>")

my.keymap.set("n", "<space>O", "<cmd>lua my.motion.NORMAL.forward_WORD_start()<cr>")
my.keymap.set("x", "<space>O", "<cmd>lua my.motion.VISUAL.forward_WORD_start()<cr>")
my.keymap.set("o", "<space>O", "<cmd>lua my.motion.OPERATOR.forward_WORD_start()<cr>")
my.keymap.set("n", "<S-space>O", "<cmd>lua my.motion.NORMAL.forward_WORD_start()<cr>")
my.keymap.set("x", "<S-space>O", "<cmd>lua my.motion.VISUAL.forward_WORD_start()<cr>")
my.keymap.set("o", "<S-space>O", "<cmd>lua my.motion.OPERATOR.forward_WORD_start()<cr>")

my.keymap.set("n", "<space>h", "<cmd>lua my.motion.NORMAL.first_non_blank()<cr>")
my.keymap.set("x", "<space>h", "<cmd>lua my.motion.VISUAL.first_non_blank()<cr>")
my.keymap.set("o", "<space>h", "<cmd>lua my.motion.OPERATOR.first_non_blank()<cr>")

my.keymap.set("n", "<space>l", "<cmd>lua my.motion.NORMAL.last_non_blank()<cr>")
my.keymap.set("x", "<space>l", "<cmd>lua my.motion.VISUAL.last_non_blank()<cr>")
my.keymap.set("o", "<space>l", "<cmd>lua my.motion.OPERATOR.last_non_blank()<cr>")

my.keymap.set("n", "<space><space>h", "<cmd>lua my.motion.NORMAL.first()<cr>")
my.keymap.set("x", "<space><space>h", "<cmd>lua my.motion.VISUAL.first()<cr>")
my.keymap.set("o", "<space><space>h", "<cmd>lua my.motion.OPERATOR.first()<cr>")

my.keymap.set("n", "<space><space>l", "<cmd>lua my.motion.NORMAL.last()<cr>")
my.keymap.set("x", "<space><space>l", "<cmd>lua my.motion.VISUAL.last()<cr>")
my.keymap.set("o", "<space><space>l", "<cmd>lua my.motion.OPERATOR.last()<cr>")

my.keymap.set("n", "w", "i")
my.keymap.set("n", "e", "a")
my.keymap.set("n", "W", "<cmd>lua my.insert.NORMAL.first()<CR>")
my.keymap.set("n", "E", "<cmd>lua my.insert.NORMAL.last()<CR>")

my.keymap.set("n", "<space>w", "<cmd>lua my.insert.NORMAL.first_non_blank()<cr>")
my.keymap.set("x", "<space>w", "<cmd>lua my.insert.VISUAL.first_non_blank()<cr>")

my.keymap.set("n", "<space>e", "<cmd>lua my.insert.NORMAL.last_non_blank()<cr>")
my.keymap.set("x", "<space>e", "<cmd>lua my.insert.VISUAL.last_non_blank()<cr>")

my.keymap.set("n", "<space><space>w", "<cmd>lua my.insert.NORMAL.first()<CR>")
my.keymap.set("x", "<space><space>w", "<cmd>lua my.insert.VISUAL.first()<CR>")

my.keymap.set("n", "<space><space>e", "<cmd>lua my.insert.NORMAL.last()<CR>")
my.keymap.set("x", "<space><space>e", "<cmd>lua my.insert.VISUAL.last()<CR>")

my.keymap.set("n", "<S-space>H", "<cmd>lua my.insert.NORMAL.first_non_blank()<cr>")
my.keymap.set("n", "<S-space>L", "<cmd>lua my.insert.NORMAL.last_non_blank()<cr>")
my.keymap.set("n", "<S-space><S-space>H", "<cmd>lua my.insert.NORMAL.first()<cr>")
my.keymap.set("n", "<S-space><S-space>L", "<cmd>lua my.insert.NORMAL.last()<cr>")

my.keymap.set("n", "<bs>", "s")
my.keymap.set("x", "<bs>", "c")
my.keymap.set("o", "<bs>", "<esc>")
my.keymap.set("s", "<bs>", " <bs>")

my.keymap.set("n", "<M-l>", "la")
my.keymap.set("n", "<M-h>", "hi")
my.keymap.set("n", "<M-L>", "3la")
my.keymap.set("n", "<M-H>", "3hi")

my.keymap.set("i", "<M-space><M-h>", "<cmd>lua my.motion.INSERT.first_non_blank()<cr>")
my.keymap.set("i", "<M-space><M-l>", "<cmd>lua my.motion.INSERT.last_non_blank()<cr>")
my.keymap.set("c", "<M-space><M-h>", "<cmd>lua my.motion.COMMAND.first_non_blank()<cr>")
my.keymap.set("c", "<M-space><M-l>", "<cmd>lua my.motion.COMMAND.last_non_blank()<cr>")

my.keymap.set("n", "<M-space><M-h>", "<cmd>lua my.insert.NORMAL.first_non_blank()<cr>")
my.keymap.set("n", "<M-space><M-l>", "<cmd>lua my.insert.NORMAL.last_non_blank()<cr>")

my.keymap.set({ "i", "c" }, "<M-space><M-space><M-h>", "<Home>")
my.keymap.set({ "i", "c" }, "<M-space><M-space><M-l>", "<End>")

my.keymap.set("n", "<M-space><M-space><M-h>", "<Home>i")
my.keymap.set("n", "<M-space><M-space><M-l>", "<End>a")

my.keymap.set("n", "@", "<cmd>lua my.macro._repeat()<cr>")
