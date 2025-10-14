local color_column = ""

local function switch(option)
  vim.opt[option] = not vim.opt[option]:get()
end

return {
  ["<leader>st"] = {
    function()
      local value = vim.opt.laststatus:get()
      if value == 0 then
        vim.opt.laststatus = 3
      else
        vim.opt.laststatus = 0
      end
    end,
    "n",
  },
  ["<leader>vt"] = {
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
  -- Toggle cursorline
  -- Only in cursor window
  ["<leader>csl"] = {
    function()
      require("builtin.toggle_cursorline").toggle_cursorline()
    end,
    "n",
  },
  ["<space><space>-"] = {
    function()
      if vim.opt["wrap"]:get() then
        vim.opt.wrap = false
      else
        vim.opt.wrap = true
      end
    end,
    "n",
  },
  ["<leader>sh"] = {
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
  ["<leader>nb"] = {
    function()
      if vim.opt["number"]:get() then
        vim.opt.number = false
      else
        vim.opt.number = true
      end
    end,
    "n",
  },
  ["<leader>rnb"] = {
    function()
      if vim.opt["relativenumber"]:get() then
        vim.opt.relativenumber = false
      else
        vim.opt.relativenumber = true
      end
    end,
    "n",
  },
  ["<leader>tnb"] = {
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
  ["<leader>cl"] = {
    function()
      color_column = color_column == "72" and "" or "72"
      vim.opt.colorcolumn = color_column
    end,
    "n",
  },
  ["<leader>ig"] = {
    function()
      switch("ignorecase")
    end,
    { "n" },
  },
  -- toggle list icon
  ["<leader>li"] = {
    function()
      switch("list")
    end,
    { "n" },
  },
  -- toggle hlsearch highlight
  ["<leader>hl"] = {
    function()
      switch("hlsearch")
    end,
    { "n" },
  },
}
