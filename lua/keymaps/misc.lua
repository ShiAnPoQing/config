return {
  ["<M-=>"] = {
    "<C-\\>e",
    "c",
    desc = "<C-\\>e",
  },
  ["gy"] = {
    function()
      local reg = vim.v.register
      vim.api.nvim_feedkeys('"' .. reg .. "y", "nx", false)
      local text = vim.fn.getreg(reg)
      text = text:gsub("\n$", "")
      vim.fn.setreg(reg, text)
    end,
    "x",
    desc = "Like y, but trim trailing \\n",
  },
  ["<C-space><C-v>"] = { "<C-K>", "i" },
  [","] = { ",<C-g>u", "i" },
  ["."] = { ".<C-g>u", "i" },
  [";"] = { ";<C-g>u", "i" },
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
      return '<Cmd>nohlsearch|diffupdate|call nvim_buf_clear_namespace(0, nvim_create_namespace("nvim.multicursor"), 0, -1)|normal! <C-L><CR>'
    end,
    "n",
    expr = true,
    desc = "<C-L>",
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
