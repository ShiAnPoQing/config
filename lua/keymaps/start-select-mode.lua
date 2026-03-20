return {
  -- TODO: When <Esc> into insert mode
  -- Start Select Mode
  ["<M-`><M-h>"] = {
    function()
      if vim.api.nvim_win_get_cursor(0)[2] == 0 then
        return "<Ignore>"
      end
      return "<esc>gh"
    end,
    "i",
    expr = true,
    desc = "Start Select Mode[h]",
  },
  ["<M-`><M-l>"] = {
    function()
      local cursor = vim.api.nvim_win_get_cursor(0)
      if cursor[2] == 0 then
        return "<esc>gh"
      end

      local line = vim.api.nvim_get_current_line()
      if #line == cursor[2] then
        return "<Ignore>"
      end
      return "<right><esc>gh"
    end,
    "i",
    expr = true,
    desc = "Start Select Mode[l]",
  },
  ["<M-`><M-j>"] = {
    function()
      local cursor = vim.api.nvim_win_get_cursor(0)
      local line_count = vim.api.nvim_buf_line_count(0)
      local line = vim.api.nvim_get_current_line()
      if #line == cursor[2] then
        if cursor[1] == line_count then
          return "<Ignore>"
        end
        return "<down><right><esc>v0o<C-g>"
      end
      if cursor[1] == line_count then
        return "<right><esc>v$<C-g>"
      end
      return "<right><esc>vj<C-g>"
    end,
    "i",
    expr = true,
    desc = "Start Select Mode[j]",
  },
  ["<M-`><M-k>"] = {
    function()
      local cursor = vim.api.nvim_win_get_cursor(0)
      if cursor[2] == 0 then
        if cursor[1] == 1 then
          return "<Ignore>"
        end
        return "<up><esc>$v0<C-g>"
      end
      if cursor[1] == 1 then
        return "<esc>v0<C-g>"
      end
      return "<esc>vk<C-g>"
    end,
    "i",
    expr = true,
    desc = "Start Select Mode[k]",
  },
  ["<M-`><M-S-h>"] = {
    function()
      if vim.api.nvim_win_get_cursor(0)[2] == 0 then
        return "<Ignore>"
      end
      return "<esc>gh<left><left>"
    end,
    "i",
    expr = true,
    desc = "Start Select Mode[H]",
  },
  ["<M-`><M-S-l>"] = {
    function()
      local cursor = vim.api.nvim_win_get_cursor(0)
      if cursor[2] == 0 then
        return "<esc>gh<right><right>"
      end

      local line = vim.api.nvim_get_current_line()
      if #line == cursor[2] then
        return "<Ignore>"
      end
      return "<right><esc>gh<right><right>"
    end,
    "i",
    expr = true,
    desc = "Start Select Mode[L]",
  },
  ["<M-`><M-S-j>"] = {
    function()
      local cursor = vim.api.nvim_win_get_cursor(0)
      local line_count = vim.api.nvim_buf_line_count(0)
      local line = vim.api.nvim_get_current_line()
      if #line == cursor[2] then
        if cursor[1] == line_count then
          return "<Ignore>"
        end
        return "<down><down><down><right><esc>v<up><up>0o<C-g>"
      end
      if cursor[1] == line_count then
        return "<right><esc>v$<C-g>"
      end
      return "<right><esc>v3j<C-g>"
    end,
    "i",
    expr = true,
    desc = "Start Select Mode[J]",
  },
  ["<M-`><M-S-k>"] = {
    function()
      local cursor = vim.api.nvim_win_get_cursor(0)
      if cursor[2] == 0 then
        if cursor[1] == 1 then
          return "<Ignore>"
        end
        return "<up><esc>$v<up><up>0<C-g>"
      end
      if cursor[1] == 1 then
        return "<esc>v0<C-g>"
      end
      return "<esc>v3k<C-g>"
    end,
    "i",
    expr = true,
    desc = "Start Select Mode[K]",
  },
  ["<M-`><M-space><M-h>"] = {
    function()
      local cursor = vim.api.nvim_win_get_cursor(0)
      local line = vim.api.nvim_get_current_line()
      local col = line:find("%S")
      if not col then
        return "<Ignore>"
      end

      if cursor[2] > col - 1 then
        return "<Esc>v^<C-g>"
      elseif cursor[2] == col - 1 then
        return "<Ignore>"
      else
        return "<right><esc>v^h<C-g>"
      end
    end,
    "i",
    expr = true,
    desc = "Start Select Mode[<space>h]",
  },
  ["<M-`><M-space><M-l>"] = {
    function()
      local cursor = vim.api.nvim_win_get_cursor(0)
      local line = vim.api.nvim_get_current_line()
      local reverse_col = line:reverse():find("%S")
      if not reverse_col then
        return "<Ignore>"
      end

      local col = #line - reverse_col
      if cursor[2] == col + 1 then
        return "<Ignore>"
      elseif cursor[2] > col + 1 then
        return "<Esc>vg_l<C-g>"
      else
        return "<right><Esc>vg_<C-g>"
      end
    end,
    "i",
    expr = true,
    desc = "Start Select Mode[<space>l]",
  },
  ["<M-`><M-space><M-space><M-h>"] = {
    function()
      local line = vim.api.nvim_get_current_line()
      local cursor = vim.api.nvim_win_get_cursor(0)
      if #line == 0 then
        return "<Ignore>"
      end
      if cursor[2] == 0 then
        return "<Ignore>"
      end
      return "<Esc>v0<C-g>"
    end,
    "i",
    expr = true,
    desc = "Start Select Mode[<space><space>h]",
  },
  ["<M-`><M-space><M-space><M-l>"] = {
    function()
      local line = vim.api.nvim_get_current_line()
      local cursor = vim.api.nvim_win_get_cursor(0)
      if #line == cursor[2] then
        return "<Ignore>"
      end
      return "<right><esc>v$<C-g>"
    end,
    "i",
    expr = true,
    desc = "Start Select Mode[<space><space>l]",
  },
  ["<M-`><M-o>"] = {
    function()
      local cursor = vim.api.nvim_win_get_cursor(0)
      local line = vim.api.nvim_get_current_line()
      local line_count = vim.api.nvim_buf_line_count(0)

      if #line == cursor[2] then
        if cursor[1] == line_count then
          return "<Ignore>"
        end
        return "<down><esc>0ve<C-g>"
      end
      return "<right><esc>ve<C-g>"
    end,
    "i",
    expr = true,
    desc = "Start Select Mode[o]",
  },
  ["<M-`><M-i>"] = {
    function()
      local cursor = vim.api.nvim_win_get_cursor(0)
      if cursor[2] == 0 then
        if cursor[1] == 1 then
          return "<Ignore>"
        end
        return "<up><esc>$gh<S-left>"
      end
      return "<esc>gh<S-left>"
    end,
    "i",
    expr = true,
    desc = "Start Select Mode[i]",
  },
  ["<M-`><M-S-o>"] = {
    function()
      local cursor = vim.api.nvim_win_get_cursor(0)
      local line = vim.api.nvim_get_current_line()
      local line_count = vim.api.nvim_buf_line_count(0)

      if #line == cursor[2] then
        if cursor[1] == line_count then
          return "<Ignore>"
        end
        return "<down><esc>0vE<C-g>"
      end
      return "<right><esc>vE<C-g>"
    end,
    "i",
    desc = "Start Select Mode[O]",
  },
  ["<M-`><M-S-i>"] = {
    function()
      local cursor = vim.api.nvim_win_get_cursor(0)
      if cursor[2] == 0 then
        if cursor[1] == 1 then
          return "<Ignore>"
        end
        return "<up><esc>$vB<C-g>"
      end
      return "<esc>vB<C-g>"
    end,
    "i",
    expr = true,
    desc = "Start Select Mode[I]",
  },
  ["<M-`><M-space><M-o>"] = { "<C-o>vlwh<C-g>", "i", desc = "Start Select Mode[<space>o]" },
  ["<M-`><M-space><M-i>"] = { "<esc>vhgel<C-g>", "i", desc = "Start Select Mode[<space>i]" },
  ["<M-`><M-space><M-S-o>"] = { "<C-o>vlWh<C-g>", "i", desc = "Start Select Mode[<space>O]" },
  ["<M-`><M-space><M-S-i>"] = { "<esc>vhgEl<C-g>", "i", desc = "Start Select Mode[<space>I]" },
  ["<M-`><M-space><M-m>"] = {
    function()
      local cursor = vim.api.nvim_win_get_cursor(0)
      local line = vim.api.nvim_get_current_line()
      if math.ceil(#line / 2) > cursor[2] then
        return "<right><esc>vgM<C-g>"
      else
        return "<esc>vgM<C-g>"
      end
    end,
    "i",
    expr = true,
    desc = "Start Select Mode[<space>m]",
  },
  -- Start Select Block Mode
  ["<M-`><M-`><M-h>"] = { "<Esc><C-v><C-g>", "i", desc = "Start Select Block Mode[h]" },
  ["<M-`><M-`><M-l>"] = { "<C-o><C-v><C-g>", "i", desc = "Start Select Block Mode[l]" },
  ["<M-`><M-`><M-j>"] = { "<C-o><C-v>j<C-g>", "i", desc = "Start Select Block Mode[j]" },
  ["<M-`><M-`><M-k>"] = { "<Esc><C-v>k<C-g>", "i", desc = "Start Select Block Mode[k]" },
  ["<M-`><M-`><M-space><M-h>"] = { "<Esc><C-v>^<C-g>", "i", desc = "Start Select Block Mode[<space>h]" },
  ["<M-`><M-`><M-space><M-l>"] = { "<C-o><C-v>g_<C-g>", "i", desc = "Start Select Block Mode[<space>l]" },
  ["<M-`><M-`><M-o>"] = { "<C-o><C-v>e<C-g>", "i", desc = "Start Select Block Mode[o]" },
  ["<M-`><M-`><M-i>"] = { "<Esc>g<C-h><S-left>", "i", desc = "Start Select Block Mode[i]" },
  ["<M-`><M-`><M-S-o>"] = { "<C-o><C-v>E<C-g>", "i", desc = "Start Select Block Mode[O]" },
  ["<M-`><M-`><M-S-i>"] = { "<Esc><C-v>B<C-g>", "i", desc = "Start Select Block Mode[I]" },
  ["<M-`><M-`><M-space><M-o>"] = { "<C-o><C-v>lwh<C-g>", "i", desc = "Start Select Block Mode[<space>o]" },
  ["<M-`><M-`><M-space><M-i>"] = { "<esc><C-v>hgel<C-g>", "i", desc = "Start Select Block Mode[<space>i]" },
  ["<M-`><M-`><M-space><M-S-o>"] = { "<C-o><C-v>lWh<C-g>", "i", desc = "Start Select Block Mode[<space>O]" },
  ["<M-`><M-`><M-space><M-S-i>"] = { "<esc><C-v>hgEl<C-g>", "i", desc = "Start Select Block Mode[<space>I]" },
  ["<C-left>"] = {
    { "<Esc>gh<S-left>", "i", desc = "Start Select Mode[i]" },
    {
      function()
        require("builtin.expand-select").expand_select_left_word()
      end,
      "s",
      desc = "Expand word[left]",
    },
  },
  ["<C-right>"] = {
    { "<C-o>ve<C-g>", "i", desc = "Start Select Mode[o]" },
    {
      function()
        require("builtin.expand-select").expand_select_right_word()
      end,
      "s",
      desc = "Expand word[right]",
    },
  },
}
