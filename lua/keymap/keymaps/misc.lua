return {
  ["0<esc>"] = {
    function()
      local map = {
        {
          item = "clear multicursor",
          select = function()
            my.multicursor.clear(0, 0, -1)
          end,
          condition = function()
            return my.multicursor.active()
          end,
        },
        {
          item = "no hlsearch",
          select = function()
            vim.o.hlsearch = false
          end,
          condition = function()
            return vim.o.hlsearch
          end,
        },
        {
          item = "hlsearch",
          select = function()
            vim.o.hlsearch = true
          end,
          condition = function()
            return not vim.o.hlsearch
          end,
        },
        {
          item = "diffupdate",
          select = function()
            vim.cmd("diffupdate")
          end,
        },
      }
      local items = {}
      for _, value in ipairs(map) do
        local condition = not value.condition and true or value.condition()
        if condition then
          items[#items + 1] = value.item
        end
      end
      vim.ui.select(items, { prompt = "Super <Esc>" }, function(_, idx)
        if idx then
          map[idx].select()
        end
      end)
    end,
    "n",
    desc = "super <esc>",
  },
  ["<M-=>"] = {
    "<C-\\>e",
    "c",
    desc = "<C-\\>e",
  },
  ["gy"] = {
    {
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
    {
      function()
        return string.format('gv"%sy', vim.v.register)
      end,
      expr = true,
      "n",
    },
  },
  ["<C-space><C-v>"] = { "<C-K>", "i" },

  [","] = {
    function()
      if my.multicursor.active() then
        return ","
      end
      return ",<C-g>u"
    end,
    "i",
    expr = true,
  },
  ["."] = {
    function()
      if my.multicursor.active() then
        return "."
      end
      return ".<C-g>u"
    end,
    "i",
    expr = true,
  },
  [";"] = {
    function()
      if my.multicursor.active() then
        return ";"
      end
      return ";<C-g>u"
    end,
    "i",
    expr = true,
  },
  -- ["y:"] = {
  --   function()
  --     vim.ui.input({
  --       prompt = "Yank:",
  --       completion = "command",
  --     }, function(input)
  --       if input == "or" or input == nil then
  --         return
  --       end
  --       local output = vim.api.nvim_exec2(input, { output = true }).output
  --       vim.fn.setreg(vim.v.register, output)
  --     end)
  --   end,
  --   "n",
  --   desc = "Yank command output to register",
  -- },
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
  ["gh"] = { { "<C-g>", "x" }, { "<C-g>", "s" } },
  ["gH"] = { { "<C-g>", "s" }, { "<C-g>", "x" } },
  ["<space>r"] = { "gR", "n" },
  ["<M-f>"] = { ";", { "n" }, desc = "Repeat latest f, t, F or T [count] times" },
  ["<C-f>"] = { ",", { "n" }, desc = "Repeat latest f, t, F or T in opposite direction [count] times" },
}
