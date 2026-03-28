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
    ["<M-h>"] = { "<cmd>TmuxNavigateLeft<cr>", "n", desc = "TmuxNavigateLeft" },
    ["<M-j>"] = { "<cmd>TmuxNavigateDown<cr>", "n", desc = "TmuxNavigateDown" },
    ["<M-k>"] = { "<cmd>TmuxNavigateUp<cr>", "n", desc = "TmuxNavigateUp" },
    ["<M-l>"] = { "<cmd>TmuxNavigateRight<cr>", "n", desc = "TmuxNavigateRight" },
    ["<M-\\>"] = { "<cmd>TmuxNavigatePrevious<cr>", "n", desc = "TmuxNavigatePrevious" },
  },
}
