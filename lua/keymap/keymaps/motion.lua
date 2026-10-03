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
  --===================================================================
  --========================= Word Motion =============================
  --===================================================================
  ["i"] = {
    { "<cmd>lua my.motion.backward_word_start()<cr>", { "n", "x" } },
    { "<cmd>lua my.motion['no'].backward_word_start()<cr>", "o" },
    desc = "[count] backward word start",
  },
  ["o"] = {
    { "<cmd>lua my.motion.forward_word_end()<cr>", { "n", "x" } },
    { "<cmd>lua my.motion['no'].forward_word_end()<cr>", "o" },
    desc = "[count] forward word end",
  },
  ["I"] = {
    { "<cmd>lua my.motion.backward_WORD_start()<cr>", { "n", "x" } },
    { "<cmd>lua my.motion['no'].backward_WORD_start()<cr>", "o" },
    desc = "[count] backward WORD start",
  },
  ["O"] = {
    { "<cmd>lua my.motion.forward_WORD_end()<cr>", { "n", "x" } },
    { "<cmd>lua my.motion['no'].forward_WORD_end()<cr>", "o" },
    desc = "[count] forward WORD end",
  },
  ["<space>i"] = {
    { "<cmd>lua my.motion.backward_word_end()<cr>", { "n", "x" } },
    { "<cmd>lua my.motion['no'].backward_word_end()<cr>", "o" },
    desc = "[count] backward word end",
  },
  ["<space>I"] = {
    { "<cmd>lua my.motion.backward_WORD_end()<cr>", { "n", "x" } },
    { "<cmd>lua my.motion['no'].backward_WORD_end()<cr>", "o" },
    desc = "[count] backward WORD end",
  },
  ["<S-space>I"] = {
    { "<cmd>lua my.motion.backward_WORD_end()<cr>", { "n", "x" } },
    { "<cmd>lua my.motion['no'].backward_WORD_end()<cr>", "o" },
    desc = "[count] backward WORD end",
  },
  ["<space>o"] = {
    { "<cmd>lua my.motion.forward_word_start()<cr>", { "n", "x" } },
    { "<cmd>lua my.motion['no'].forward_word_start()<cr>", "o" },
    desc = "[count] forward word start",
  },
  ["<space>O"] = {
    { "<cmd>lua my.motion.forward_WORD_start()<cr>", { "n", "x" } },
    { "<cmd>lua my.motion['no'].forward_WORD_start()<cr>", "o" },
    desc = "[count] forward WORD start",
  },
  ["<S-space>O"] = {
    { "<cmd>lua my.motion.forward_WORD_start()<cr>", { "n", "x", "o" } },
    { "<cmd>lua my.motion['no'].forward_WORD_start()<cr>", "o" },
    desc = "[count] forward WORD start",
  },

  --===================================================================
  --========================= Line Motion =============================
  --===================================================================
  ["<space>h"] = {
    { "<cmd>lua my.motion.first_non_blank()<cr>", { "n", "x" } },
    { "<cmd>lua my.motion['no'].first_non_blank()<cr>", "o" },
    desc = "Move to the first non-blank character of the line",
  },
  ["<space>l"] = {
    { "<cmd>lua my.motion.last_non_blank()<cr>", { "n", "x" } },
    { "<cmd>lua my.motion['no'].last_non_blank()<cr>", "o" },
    desc = "Move to the last non-blank character of the line",
  },
  ["<space><space>h"] = {
    { "<cmd>lua my.motion.first()<cr>", { "n", "x" } },
    { "<cmd>lua my.motion['no'].first()<cr>", "o" },
    desc = "Move to the first character of the line",
  },
  ["<space><space>l"] = {
    { "<cmd>lua my.motion.last()<cr>", { "n", "x" } },
    { "<cmd>lua my.motion['no'].last()<cr>", "o" },
    desc = "Move to the last character of the line",
  },
}
