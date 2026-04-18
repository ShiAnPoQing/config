return {
  ["y:"] = {
    function()
      vim.ui.input({
        prompt = "Yank:",
        completion = "command",
      }, function(input)
        if input == "or" or input == nil then
          return
        end
        local output = vim.api.nvim_exec2(input, { output = true }).output
        vim.fn.setreg(vim.v.register, output)
      end)
    end,
    "n",
    desc = "Yank command output to register",
  },
  ["<leader>p:"] = {
    function()
      vim.ui.input({
        prompt = "Put:",
        completion = "command",
      }, function(input)
        if input == "or" or input == nil then
          return
        end
        local output = vim.api.nvim_exec2(input, { output = true }).output
        vim.api.nvim_put(vim.split(output, "\n"), "l", true, true)
      end)
    end,
    "n",
    desc = "Put command output",
  },
  ["<space>D"] = { "xd^", "n" },
  ["<esc>"] = {
    function()
      ---@diagnostic disable-next-line: undefined-field
      vim.opt.hlsearch = not vim.opt.hlsearch:get()
    end,
    "n",
    desc = "Toggle highlight search",
  },
  ["<leader>X"] = {
    "<cmd>source %<cr>",
    "n",
    { desc = "Source ths lua file" },
  },
  ["<leader>x"] = {
    {
      ":.lua<cr>",
      "n",
      { desc = "Run cursor line" },
    },
    {
      ":lua<cr>",
      "x",
      { desc = "Run selected" },
    },
  },
  ["<space>f"] = { "t", { "n", "o", "x" } },
  ["<space>F"] = { "T", { "n", "o", "x" } },
  ["<M-b>"] = { "<C-G>o<C-G>", "s", desc = "Go to Other end of highlighted text" },
  -- ["<M-bs>"] = {
  --   "s",
  --   "n"
  -- },
  -- ["<C-bs>"] = {
  --   "S",
  --   "n"
  -- },
  -- ["<space>C"] = {
  --   "v0c",
  --   "n"
  -- },
  ["<leader><F5>"] = {
    function()
      local path = vim.fn.expand("$MYVIMRC"):gsub("init.lua", "")
      vim.fn.chdir(path)
      vim.cmd("e $MYVIMRC")
    end,
    "n",
    { desc = "Edit my neovim config" },
  },
  -- gh: normal mode into select mode
  -- normal mode into select block mode
  ["<space>gh"] = { "g<C-h>", "n" },
  ["gh"] = {
    { "<C-g>", "x" },
    { "<C-g>", "s" },
  },
  ["gH"] = {
    { "<C-g>", "s" },
    { "<C-g>", "x" },
  },
  ["<space>r"] = { "gR", "n" },
  ["<M-f>"] = { ";", { "n" }, desc = "Repeat latest f, t, F or T [count] times" },
  ["<C-f>"] = { ",", { "n" }, desc = "Repeat latest f, t, F or T in opposite direction [count] times" },
}
