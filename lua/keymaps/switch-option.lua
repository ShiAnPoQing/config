local color_column = ""

local function switch(option)
  vim.opt[option] = not vim.opt[option]:get()
end

return {
  ["<leader>st"] = {
    function()
      ---@diagnostic disable-next-line: undefined-field
      local value = vim.opt.laststatus:get()
      if value == 0 then
        vim.opt.laststatus = 3
      else
        vim.opt.laststatus = 0
      end
    end,
    "n",
    desc = "Switch laststatus",
  },
  ["<leader>vt"] = {
    function()
      ---@diagnostic disable-next-line: undefined-field
      local value = vim.opt.virtualedit:get()[1]
      if value == "all" then
        vim.opt.virtualedit = "none"
      else
        vim.opt.virtualedit = "all"
      end
    end,
    "n",
    desc = "Switch virtualedit",
  },
  -- Toggle cursorline
  -- Only in cursor window
  ["<leader>csl"] = {
    function()
      require("builtin.toggle-cursorline").toggle_cursorline()
    end,
    "n",
    desc = "Switch cursor line",
  },
  ["<space><space>-"] = {
    function()
      ---@diagnostic disable-next-line: undefined-field
      if vim.opt["wrap"]:get() then
        vim.opt.wrap = false
      else
        vim.opt.wrap = true
      end
    end,
    "n",
    desc = "Switch wrap",
  },
  ["<leader>sh"] = {
    function()
      ---@diagnostic disable-next-line: undefined-field
      local value = vim.opt["signcolumn"]:get()
      if string.sub(value, 1, 1) == "y" then
        vim.opt["signcolumn"] = "no"
      else
        vim.opt["signcolumn"] = "yes:1"
      end
    end,
    "n",
    desc = "Switch signcolumn",
  },
  ["<leader>nb"] = {
    function()
      ---@diagnostic disable-next-line: undefined-field
      if vim.opt["number"]:get() then
        vim.opt.number = false
      else
        vim.opt.number = true
      end
    end,
    "n",
    desc = "Switch number",
  },
  ["<leader>rnb"] = {
    function()
      ---@diagnostic disable-next-line: undefined-field
      if vim.opt["relativenumber"]:get() then
        vim.opt.relativenumber = false
      else
        vim.opt.relativenumber = true
      end
    end,
    "n",
    desc = "Switch relativenumber",
  },
  ["<leader>tnb"] = {
    function()
      ---@diagnostic disable-next-line: undefined-field
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
    desc = "Switch number column",
  },
  ["<leader>cl"] = {
    function()
      color_column = color_column == "72" and "" or "72"
      vim.opt.colorcolumn = color_column
    end,
    "n",
    desc = "Switch color column",
  },
  ["<leader>ig"] = {
    function()
      switch("ignorecase")
    end,
    "n",
    desc = "Switch ignorecase",
  },
  ["<leader>li"] = {
    function()
      switch("list")
    end,
    "n",
    desc = "Switch list",
  },
  ["<leader>hl"] = {
    function()
      switch("hlsearch")
    end,
    "n",
    desc = "Switch hlsearch",
  },
}
