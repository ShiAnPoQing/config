return {
  -- ["<leader>wb"] = {
  --   function()
  --     local winbar = vim.opt.winbar:get()
  --   end,
  --   "n",
  -- },
  ["<leader>bg"] = {
    function()
      local bg = vim.o.background
      if bg == "dark" then
        vim.o.background = "light"
      else
        vim.o.background = "dark"
      end
    end,
    "n",
  },
  ["<leader>so"] = {
    function()
      --'scrolloff': global or local to window
      local scrolloff = vim.wo.scrolloff
      if scrolloff ~= 999 then
        vim.wo.scrolloff = 999
      else
        vim.wo.scrolloff = 0
      end
    end,
    "n",
    desc = "Switch the cursor line will always be in the middle of the window or not",
  },
  ["<leader>vso"] = {
    function()
      --'sidescrolloff': global or local to window
      local sidescrolloff = vim.wo.sidescrolloff
      if sidescrolloff ~= 999 then
        vim.wo.sidescrolloff = 999
      else
        vim.wo.sidescrolloff = 999
      end
    end,
    "n",
    desc = "Switch the cursor line will always be in the middle of the window or not",
  },
  ["<leader>st"] = {
    function()
      ---@diagnostic disable-next-line: undefined-field
      local laststatus = vim.opt.laststatus:get()
      if laststatus == 0 then
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
      -- 'virtualedit': global or local to window
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
  ["<space><space>-"] = {
    function()
      -- 'wrap': local to window
      local wrap = vim.wo[0][0].wrap
      if wrap then
        vim.wo[0][0].wrap = false
      else
        vim.wo[0][0].wrap = true
      end
    end,
    "n",
    desc = "Switch wrap",
  },
  ["<leader>sh"] = {
    function()
      -- 'signcolumn': local to window
      local value = vim.wo[0][0].signcolumn
      if string.sub(value, 1, 1) == "y" then
        vim.wo[0][0].signcolumn = "no"
      else
        vim.wo[0][0].signcolumn = "yes:1"
      end
    end,
    "n",
    desc = "Switch signcolumn",
  },
  ["<leader>nb"] = {
    function()
      -- 'number': local to window
      local value = vim.wo[0][0].number
      if value then
        vim.wo[0][0].number = false
      else
        vim.wo[0][0].number = true
      end
    end,
    "n",
    desc = "Switch number",
  },
  ["<leader>Nb"] = {
    function()
      -- 'relativenumber': local to window
      local value = vim.wo[0][0].relativenumber
      if value then
        vim.wo[0][0].relativenumber = false
      else
        vim.wo[0][0].relativenumber = true
      end
    end,
    "n",
    desc = "Switch relativenumber",
  },
  ["<leader>NB"] = {
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
  ["<leader>cll"] = {
    function()
      -- 'colorcolumn': local to window
      if vim.wo[0][0].colorcolumn == "" then
        vim.wo[0][0].colorcolumn = "72"
      else
        vim.wo[0][0].colorcolumn = ""
      end
    end,
    "n",
    desc = "Switch colorcolumn",
  },
  ["<leader>ig"] = {
    function()
      -- 'ignorecase': global
      vim.o.ignorecase = not vim.o.ignorecase
    end,
    "n",
    desc = "Switch ignorecase",
  },
  ["<leader>li"] = {
    function()
      -- 'list': local to window
      vim.wo[0][0].list = not vim.wo[0][0].list
    end,
    "n",
    desc = "Switch list",
  },
  ["<leader>hl"] = {
    function()
      -- 'hlsearch': global
      vim.o.hlsearch = not vim.o.hlsearch
    end,
    "n",
    desc = "Switch hlsearch",
  },
}
