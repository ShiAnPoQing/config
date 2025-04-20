require("auto-command")
require("options").setup()
require("repeat").setup()
require("concat-mode")
local K = require("plugin-keymap")
K.setup()

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require("globals")
require("lazy").setup("plugins")

K.add({
  ["<F9>"] = {
    "A",
    "n"
  },
  ["<F8>"] = {
    function()
      vim.api.nvim_create_user_command('Custom',
        function(opts)
          print(vim.inspect(opts))
        end,
        {
          nargs = "+",
          range = "%",
          preview = function(opts, ns, buf)
            print("fdafadasfdasf")
            print(vim.inspect(opts), ns, buf)
          end,
          complete = "color",
        })
    end,
    "n",
  },
  ["<F7>"] = {
    function()
      local keys = vim.api.nvim_replace_termcodes("ekk", true, false, true)

      -- 方法 1.1：同步发送按键（直接执行）
      vim.api.nvim_feedkeys(keys, "mt", false)

      -- local q = vim.fn.getreg("q")
      -- vim.api.nvim_exec2(
      --   string.format(
      --     [[exec "normal <space>e"]], -- 注意转义 <Up>
      --     -- q
      --   ), {})
    end,
    "n",
  },
  ["<M-s>"] = {
    "<Esc>gh",
    "i"
  },
  ["<C-F10>"] = {
    function()
      require("search-manual").searchManual()
    end,
    "n",
  },
  ["<C-[>"] = { "<C-O>", "n" },
  ["<M-->"] = { "J", "x" },
  ["<C-.>"] = { "<C-T>", "i" },
  ["<C-space><C-,>"] = { "0<C-D>", "i" },
  ["<C-,>"] = { "<C-D>", "i" },
  ["<C-space><C-.>"] = { "^<C-D>", "i" },
  ["<C-b>"] = {
    "<C-G>o<C-G>",
    "s"
  }
})
