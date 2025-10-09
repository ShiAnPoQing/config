return {
  -- TODO: more control
  ["<Tab>j"] = {
    function()
      local count = vim.v.count1
      vim.cmd(count .. "bn")
    end,
    "n",
    desc = "Goto the next[count] buffer",
  },
  ["<Tab>sj"] = {
    function()
      local count = vim.v.count1
      vim.cmd(count .. "sbn")
    end,
    "n",
    desc = "Split and goto the next[count] buffer",
  },
  ["<Tab>vj"] = {
    function()
      local count = vim.v.count1
      vim.cmd("vertical " .. count .. "sbn")
    end,
    "n",
    desc = "Vertical split and goto the next[count] buffer",
  },
  ["<Tab><Tab>j"] = {
    "<cmd>bl<cr>",
    "n",
    desc = "Goto the last buffer",
  },
  ["<Tab><Tab>sj"] = {
    "<cmd>sbl<cr>",
    "n",
    desc = "Goto the last buffer",
  },
  ["<Tab><Tab>vj"] = {
    "<cmd>vertical sbl<cr>",
    "n",
    desc = "Goto the last buffer",
  },
  ["<Tab>k"] = {
    function()
      local count = vim.v.count1
      vim.cmd(count .. "bp")
    end,
    "n",
    desc = "Goto the previous[count] buffer",
  },
  ["<Tab>sk"] = {
    function()
      local count = vim.v.count1
      vim.cmd(count .. "sbp")
    end,
    "n",
    desc = "Split and goto the previous[count] buffer",
  },
  ["<Tab>vk"] = {
    function()
      local count = vim.v.count1
      vim.cmd("vertical " .. count .. "sbp")
    end,
    "n",
    desc = "Vertical split and goto the previous[count] buffer",
  },
  ["<Tab><Tab>k"] = {
    "<cmd>bf<cr>",
    "n",
    desc = "Goto the first buffer",
  },
  ["<Tab><Tab>sk"] = {
    "<cmd>sbf<cr>",
    "n",
    desc = "Split and goto the first buffer",
  },
  ["<Tab><Tab>vk"] = {
    "<cmd>vertical sbf<cr>",
    "n",
    desc = "Vertical split and goto the first buffer",
  },
  ["<Tab>d"] = {
    function()
      local count = vim.v.count1
      vim.cmd(count .. "bd")
    end,
    "n",
    desc = "Delete buffer",
  },
  ["<Tab>sa"] = {
    function()
      local count = vim.v.count1
      vim.cmd(count .. "sba")
    end,
    "n",
    desc = "Split and open all buffer[limit count windows]",
  },
  ["<Tab>va"] = {
    function()
      local count = vim.v.count1
      vim.cmd("vertical " .. count .. "sba")
    end,
    "n",
    desc = "Vertical split and open all buffer[limit count windows]",
  },
}
