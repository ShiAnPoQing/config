---------------------------------------------------------------------------------------------------+
-- Commands \ Modes | Normal | Insert | Command | Visual | Select | Operator | Terminal | Lang-Arg |
-- ================================================================================================+
-- map  / noremap   |    @   |   -    |    -    |   @    |   @    |    @     |    -     |    -     |
-- nmap / nnoremap  |    @   |   -    |    -    |   -    |   -    |    -     |    -     |    -     |
-- map! / noremap!  |    -   |   @    |    @    |   -    |   -    |    -     |    -     |    -     |
-- imap / inoremap  |    -   |   @    |    -    |   -    |   -    |    -     |    -     |    -     |
-- cmap / cnoremap  |    -   |   -    |    @    |   -    |   -    |    -     |    -     |    -     |
-- vmap / vnoremap  |    -   |   -    |    -    |   @    |   @    |    -     |    -     |    -     |
-- xmap / xnoremap  |    -   |   -    |    -    |   @    |   -    |    -     |    -     |    -     |
-- smap / snoremap  |    -   |   -    |    -    |   -    |   @    |    -     |    -     |    -     |
-- omap / onoremap  |    -   |   -    |    -    |   -    |   -    |    @     |    -     |    -     |
-- tmap / tnoremap  |    -   |   -    |    -    |   -    |   -    |    -     |    @     |    -     |
-- lmap / lnoremap  |    -   |   @    |    @    |   -    |   -    |    -     |    -     |    @     |
---------------------------------------------------------------------------------------------------+

local function get_previous_buf(count)
  local current_buf = vim.api.nvim_get_current_buf()
  local buffers = vim.api.nvim_list_bufs()
  local modified_buffers = {}
  local pre_modified_buffer_index
  for _, buf in ipairs(buffers) do
    if buf == current_buf then
      pre_modified_buffer_index = #modified_buffers
    end
    local modified = vim.api.nvim_get_option_value("modified", {
      buf = buf,
      scope = "local",
    })
    if modified then
      modified_buffers[#modified_buffers + 1] = buf
    end
  end
  local index = (count - pre_modified_buffer_index - 1) % #modified_buffers
  if index > 0 then
    index = #modified_buffers - index
  elseif index < 0 then
    index = -index
  else
    index = #modified_buffers
  end
  return modified_buffers[index]
end

return {
  ["0<tab>j"] = {
    function()
      local bufs = {}
      local lines = {}
      local labels = {}
      local buf = vim.api.nvim_create_buf(false, true)
      for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_get_option_value("buflisted", {
          buf = buffer,
        }) then
          bufs[#bufs + 1] = buffer
          labels[#labels + 1] = {
            buf = buf,
            items = {
              { pos = { #lines, 10 } },
            },
          }
          lines[#lines + 1] = "#" .. buffer .. ": " .. vim.api.nvim_buf_get_name(buffer)
        end
      end
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
      local win = vim.api.nvim_open_win(buf, false, {
        relative = "laststatus",
        width = vim.o.columns,
        height = #lines,
        row = 1,
        col = 1,
        style = "minimal",
      })
      vim.api.nvim_set_option_value("winfixheight", true, { win = win })
      vim.api.nvim_set_option_value("winfixwidth", true, { win = win })
      vim.api.nvim_set_option_value("winfixbuf", true, { win = win })
      vim.api.nvim_set_option_value("cursorline", false, { win = win })
      require("eye")
        .gaze({
          labels = labels,
          label = {
            matched = function()
              vim.api.nvim_win_close(win, true)
            end,
          },
        })
        :start()
    end,
    "n",
  },
  ["<Tab>j"] = {
    function()
      local function callback()
        ---@diagnostic disable-next-line: param-type-mismatch
        pcall(vim.cmd, { cmd = "bn", count = vim.v.count1 })
        require("repeat").set_motion(callback)
      end
      callback()
    end,
    "n",
    desc = "Goto the next [count] buffer",
  },
  ["<Tab>sj"] = {
    function()
      ---@diagnostic disable-next-line: param-type-mismatch
      pcall(vim.cmd, { cmd = "sbn", count = vim.v.count1 })
    end,
    "n",
    desc = "Split and goto the next [count] buffer",
  },
  ["<Tab>vj"] = {
    function()
      local count = vim.v.count1
      vim.cmd("vertical " .. count .. "sbn")
    end,
    "n",
    desc = "Vertical split and goto the next [count] buffer",
  },
  ["<Tab><Tab>j"] = { "<cmd>bl<cr>", "n", desc = "Goto the last buffer" },
  ["<Tab><Tab>sj"] = { "<cmd>sbl<cr>", "n", desc = "Split and Goto the last buffer" },
  ["<Tab><Tab>vj"] = { "<cmd>vertical sbl<cr>", "n", desc = "Vertical Split and goto the last buffer" },
  ["<Tab>k"] = {
    function()
      local function callback()
        ---@diagnostic disable-next-line: param-type-mismatch
        pcall(vim.cmd, { cmd = "bp", count = vim.v.count1 })
        require("repeat").set_motion(callback)
      end
      callback()
    end,
    "n",
    desc = "Goto the previous [count] buffer",
  },
  ["<Tab>sk"] = {
    function()
      vim.cmd({ cmd = "sbp", count = vim.v.count1 })
    end,
    "n",
    desc = "Split and goto the previous [count] buffer",
  },
  ["<Tab>vk"] = {
    function()
      local count = vim.v.count1
      vim.cmd("vertical " .. count .. "sbp")
    end,
    "n",
    desc = "Vertical split and goto the previous [count] buffer",
  },
  ["<Tab><Tab>k"] = { "<cmd>bf<cr>", "n", desc = "Goto the first buffer" },
  ["<Tab><Tab>sk"] = { "<cmd>sbf<cr>", "n", desc = "Split and goto the first buffer" },
  ["<Tab><Tab>vk"] = { "<cmd>vertical sbf<cr>", "n", desc = "Vertical split and goto the first buffer" },
  ["<Tab>d"] = {
    function()
      vim.cmd({ cmd = "bd", count = vim.v.count1 })
    end,
    "n",
    desc = "Delete buffer",
  },
  ["<Tab>sa"] = {
    function()
      vim.cmd({ cmd = "sba", count = vim.v.count1 })
    end,
    "n",
    desc = "Split and open all buffer [limit count windows]",
  },
  ["<Tab>va"] = {
    function()
      local count = vim.v.count1
      vim.cmd("vertical " .. count .. "sba")
    end,
    "n",
    desc = "Vertical split and open all buffer [limit count windows]",
  },
  ["<tab>b"] = { "<C-^>", "n", desc = "Go to the most recently accessed buffer, same as <C-^>" },
  ["<tab>m"] = {
    function()
      ---@diagnostic disable-next-line: param-type-mismatch
      pcall(vim.cmd, { cmd = "bm", count = vim.v.count1 })
    end,
    "n",
    desc = "Go to [N]th next modified buffer",
  },
  ["<tab>M"] = {
    function()
      local buf = get_previous_buf(vim.v.count1)
      vim.cmd("b " .. buf)
    end,
    "n",
    desc = "Go to [N]th previous modified buffer",
  },
  ["<tab>sm"] = {
    function()
      vim.cmd({ cmd = "sbm", count = vim.v.count1 })
    end,
    "n",
    desc = "Split window and go to [N]th next modified buffer",
  },
  ["<tab>sM"] = {
    function()
      local buf = get_previous_buf(vim.v.count1)
      vim.cmd("sb " .. buf)
    end,
    "n",
    desc = "Split window and go to [N]th previous modified buffer",
  },
}
