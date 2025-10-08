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
  keys = {
    ["<M-h>"] = {
      "<cmd>TmuxNavigateLeft<cr>",
      "n",
    },
    ["<M-j>"] = {
      "<cmd>TmuxNavigateDown<cr>",
      "n",
    },
    ["<M-k>"] = {
      "<cmd>TmuxNavigateUp<cr>",
      "n",
    },
    ["<M-l>"] = {
      "<cmd>TmuxNavigateRight<cr>",
      "n",
    },
    ["<M-\\>"] = {
      "<cmd>TmuxNavigatePrevious<cr>",
      "n",
    },
  },
}
