local color_column = ""

local function switch(option)
  vim.opt[option] = not vim.opt[option]:get()
end

return {
  [";vt"] = {
    function()
      local value = vim.opt.virtualedit:get()[1]
      if value == "all" then
        vim.opt.virtualedit = "none"
      else
        vim.opt.virtualedit = "all"
      end
    end,
    "n",
  },
  [";csl"] = {
    function()
      vim.opt.cursorline = not vim.opt.cursorline:get()
    end,
    "n",
  },
  ["<space><space>-"] = {
    function()
      if vim.opt["wrap"]:get() then
        require("parse-keymap").add({
          ["J"] = { "3j", { "n", "x" } },
          ["K"] = { "3k", { "n", "x" } },
        })
        require("parse-keymap").del({
          ["j"] = { "n", "x" },
          ["k"] = { "n", "x" },
        })
        vim.opt.wrap = false
      else
        require("parse-keymap").add({
          ["j"] = { "gj", { "n", "x" } },
          ["k"] = { "gk", { "n", "x" } },
          ["J"] = { "3gj", { "n", "x" } },
          ["K"] = { "3gk", { "n", "x" } },
        })
        vim.opt.wrap = true
      end
    end,
    "n",
  },
  [";sh"] = {
    function()
      local value = vim.opt["signcolumn"]:get()
      if string.sub(value, 1, 1) == "y" then
        vim.opt["signcolumn"] = "no"
      else
        vim.opt["signcolumn"] = "yes:1"
      end
    end,
    "n",
  },
  [";nb"] = {
    function()
      if vim.opt["number"]:get() then
        vim.opt.number = false
      else
        vim.opt.number = true
      end
    end,
    "n",
  },
  [";rnb"] = {
    function()
      if vim.opt["relativenumber"]:get() then
        vim.opt.relativenumber = false
      else
        vim.opt.relativenumber = true
      end
    end,
    "n",
  },
  [";tnb"] = {
    function()
      if vim.opt["relativenumber"]:get() or vim.opt.number:get() then
        vim.opt.relativenumber = false
        vim.opt.number = false
        return
      end

      if not vim.opt["relativenumber"]:get() and not vim.opt.number:get() then
        vim.opt.relativenumber = true
        vim.opt.number = true
      end
    end,
    "n",
  },
  [";cl"] = {
    function()
      color_column = color_column == "72" and "" or "72"
      vim.opt.colorcolumn = color_column
    end,
    "n",
  },
  [";ig"] = {
    function()
      switch("ignorecase")
    end,
    { "n" },
  },
  -- toggle list icon
  [";li"] = {
    function()
      switch("list")
    end,
    { "n" },
  },
  -- toggle hlsearch highlight
  [";hl"] = {
    function()
      switch("hlsearch")
    end,
    { "n" },
  },
}
