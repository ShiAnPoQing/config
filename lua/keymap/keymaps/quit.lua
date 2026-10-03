return {
  ["<space>c"] = { "<cmd>close<cr>", { "n", "x" }, desc = "Close current window" },
  ["<space><space>c"] = { "<cmd>close!<cr>", { "n", "x" }, desc = "Close! current window" },
  ["<space>q"] = { "<cmd>q<cr>", { "n", "x" }, desc = "Quit" },
  ["<space><space>q"] = { "<cmd>q!<cr>", { "n", "x" }, desc = "Quit!" },
  ["<space>Q"] = { "<cmd>qa<cr>", { "n", "x" }, desc = "Quit all" },
  ["<space><space>Q"] = { "<cmd>qa!<cr>", { "n", "x" }, desc = "Quit! all" },
}
