local color_column = ""

local function switch(option)
  vim.opt[option] = not vim.opt[option]:get()
end

return {
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
  [";sh"] = {
    function()
      local value = vim.opt["signcolumn"]:get()
      if string.sub(value, 1, 1) == "y" then
        vim.opt["signcolumn"] = "no"
      else
        vim.opt["signcolumn"] = "yes:1"
      end
    end,
    "n"
  },
  [";nb"] = {
    function()
      if vim.opt["number"]:get() then
        vim.opt.number = false
      else
        vim.opt.number = true
      end
    end,
    "n"
  },
  [";rnb"] = {
    function()
      if vim.opt["relativenumber"]:get() then
        vim.opt.relativenumber = false
      else
        vim.opt.relativenumber = true
      end
    end,
    "n"
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
    "n"
  },
  [";cl"] = {
    function()
      color_column = color_column == "72" and "" or "72"
      vim.opt.colorcolumn = color_column
    end,
    'n'
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
  -- toggle comment
  -- ["<C-\\>"] = {
  --   {
  --     function()
  --       local C = require("comment")
  --       local count = vim.v.count1
  --       C.toggleComment("n", count)
  --       require("repeat").Record(function()
  --         C.toggleComment("n", count)
  --       end)
  --     end,
  --     "n",
  --   },
  --   {
  --     function()
  --       local C = require("comment")
  --       local count = vim.v.count1
  --       C.toggleComment("v", count)
  --       require("repeat").Record(function()
  --         C.toggleComment("v", count)
  --       end)
  --     end,
  --     "x",
  --   },
  --   {
  --     function()
  --       local C = require("comment")
  --       local count = vim.v.count1
  --       C.toggleComment("n", count)
  --       require("repeat").Record(function()
  --         C.toggleComment("n", count)
  --       end)
  --     end,
  --     "i",
  --   },
  -- },
}
