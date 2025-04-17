require("auto-command")
require("options").setup()
require("repeat").setup()
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
    end,
    "n",
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
})
