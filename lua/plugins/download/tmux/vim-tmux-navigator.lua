vim.g.tmux_navigator_no_mappings = 1

return {
  "christoomey/vim-tmux-navigator",
  cmd = {
    "TmuxNavigateLeft",
    "TmuxNavigateDown",
    "TmuxNavigateUp",
    "TmuxNavigateRight",
    "TmuxNavigatePrevious",
    "TmuxNavigatorProcessList",
  },
  key = {
    ["<C-w><C-h>"] = { "<cmd>TmuxNavigateLeft<cr>", "n", desc = "TmuxNavigateLeft" },
    ["<C-w><C-j>"] = { "<cmd>TmuxNavigateDown<cr>", "n", desc = "TmuxNavigateDown" },
    ["<C-w><C-k>"] = { "<cmd>TmuxNavigateUp<cr>", "n", desc = "TmuxNavigateUp" },
    ["<C-w><C-l>"] = { "<cmd>TmuxNavigateRight<cr>", "n", desc = "TmuxNavigateRight" },
    ["<M-\\>"] = { "<cmd>TmuxNavigatePrevious<cr>", "n", desc = "TmuxNavigatePrevious" },
  },
}
