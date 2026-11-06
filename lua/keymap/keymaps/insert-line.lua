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
--- @param cmd string
local function insert_mode_execute_cmd(cmd)
  vim.api.nvim_feedkeys(vim.keycode("<esc>"), "nt", false)
  vim.api.nvim_feedkeys(vim.keycode(cmd), "nt", false)
  vim.api.nvim_feedkeys("a", "n", false)
end

local function insert_mode_add_blank_line(key)
  if not my.multicursor.active() then
    vim.api.nvim_feedkeys(vim.keycode("<esc>" .. key), "n", false)
    return
  end
  vim.api.nvim_feedkeys(vim.keycode("<esc>" .. key .. " <bs>"), "n", false)
end

local n = {
  no_keep_cursor = {
    [-1] = {
      "<Cmd>lua my.edit.above_add_blank_line()<cr>",
      "n",
      desc = "Add [count] new line above the cursor(no keep cursor)",
    },
    [1] = {
      "<Cmd>lua my.edit.below_add_blank_line()<cr>",
      "n",
      desc = "Add [count] new line below the cursor(no keep cursor)",
    },
  },
  keep_cursor = {
    [-1] = {
      "<Cmd>lua my.edit.above_add_blank_line_follow()<cr>",
      "n",
      desc = "Add [count] new line above the cursor(keep cursor)",
    },
    [0] = {
      "<Cmd>lua my.edit.above_below_add_blank_line()<cr>",
      "n",
      desc = "Add [count] new line above the cursor and below the cursor(keep cursor)",
    },
    [1] = {
      "<Cmd>lua my.edit.below_add_blank_line_follow()<cr>",
      "n",
      desc = "Add [count] new line below the cursor(keep cursor)",
    },
  },
  no_indent = {
    [-1] = {},
    [1] = {},
  },
}

local i = {
  no_keep_cursor = {
    [-1] = {
      function()
        insert_mode_add_blank_line("O")
      end,
      "i",
      desc = "Add a new line above the cursor(no keep cursor)",
    },
    [1] = {
      function()
        insert_mode_add_blank_line("o")
      end,
      "i",
      desc = "Add a new line below the cursor(no keep cursor)",
    },
  },
  keep_cursor = {
    [-1] = {
      -- 不支持 repeat 但是更合理，不存在光标闪烁
      -- "<Cmd>lua my.edit.above_add_blank_line_follow()<cr>",
      -- 支持 repeat 但是不合理，存在光标闪烁，属于 neovim 机制问题
      function()
        insert_mode_execute_cmd("<Cmd>lua my.edit.above_add_blank_line_follow()<Cr>")
      end,
      "i",
      desc = "Add a new line above the cursor(keep cursor)",
    },
    [0] = {
      function()
        insert_mode_execute_cmd("<Cmd>lua my.edit.above_below_add_blank_line()<Cr>")
      end,
      "i",
      desc = "Add a new line above the cursor and below the cursor(keep cursor)",
    },
    [1] = {
      -- 不支持 repeat 但是更合理，不存在光标闪烁
      -- "<Cmd>lua my.edit.below_add_blank_line_follow()<cr>",
      -- 支持 repeat 但是不合理，存在光标闪烁，属于 neovim 机制问题
      function()
        insert_mode_execute_cmd("<Cmd>lua my.edit.below_add_blank_line_follow()<Cr>")
      end,
      "i",
      desc = "Add a new line below the cursor(keep cursor)",
    },
  },
  no_indent = {
    [-1] = {
      function()
        if not my.multicursor.active() then
          vim.api.nvim_feedkeys(vim.keycode("<esc>O^<C-d>"), "n", false)
          return
        end
        vim.api.nvim_feedkeys(vim.keycode("<esc>O <bs>^<C-d>"), "n", false)
      end,
      "i",
      desc = "Add a new line above the cursor(no indent)",
    },
    [1] = {
      function()
        if not my.multicursor.active() then
          vim.api.nvim_feedkeys(vim.keycode("<esc>o^<C-d>"), "n", false)
          return
        end
        vim.api.nvim_feedkeys(vim.keycode("<esc>o <bs>^<C-d>"), "n", false)
      end,
      "i",
      desc = "Add a new line below the cursor(no indent)",
    },
  },
  col_indent = {
    [-1] = {
      function()
        if not my.multicursor.active() then
          vim.api.nvim_feedkeys(
            vim.keycode("<esc>O^<C-d>" .. vim.fn["repeat"](" ", vim.fn.virtcol(".") - 1)),
            "n",
            false
          )
          return
        end
        vim.api.nvim_feedkeys(
          vim.keycode("<esc>O <bs>^<C-d>" .. vim.fn["repeat"](" ", vim.fn.virtcol(".") - 1)),
          "n",
          false
        )
      end,
      "i",
      desc = "Add a new line above the cursor(cursor col indent)",
    },
    [1] = {
      function()
        if not my.multicursor.active() then
          vim.api.nvim_feedkeys(
            vim.keycode("<esc>o^<C-d>" .. vim.fn["repeat"](" ", vim.fn.virtcol(".") - 1)),
            "n",
            false
          )
          return
        end
        vim.api.nvim_feedkeys(
          vim.keycode("<esc>o <bs>^<C-d>" .. vim.fn["repeat"](" ", vim.fn.virtcol(".") - 1)),
          "n",
          false
        )
      end,
      "i",
      desc = "Add a new line below the cursor(cursor col indent)",
    },
  },
}

return {
  ["b"] = {
    {
      function()
        local count = vim.v.count1
        if my.multicursor.active() and count == 1 then
          vim.api.nvim_feedkeys(count .. vim.keycode("o <bs>"), "n", false)
          return
        end
        vim.api.nvim_feedkeys(count .. "o", "n", false)
      end,
      "n",
      desc = "Begin a new line below the cursor, start [count] insert ",
    },
    { "o", "x", desc = "Goto other side of visual selection" },
  },
  ["B"] = {
    {
      function()
        local count = vim.v.count1
        if my.multicursor.active() and count == 1 then
          vim.api.nvim_feedkeys(count .. vim.keycode("O <bs>"), "n", false)
          return
        end
        vim.api.nvim_feedkeys(count .. "O", "n", false)
      end,
      "n",
      desc = "Begin a new line above the cursor, start [count] insert",
    },
    { "O", "x", desc = "Goto other side of visual selection" },
  },
  ["<space>b"] = {
    function()
      local count = vim.v.count1
      if my.multicursor.active() and count == 1 then
        vim.api.nvim_feedkeys(count .. vim.keycode("o <bs>^<C-d>"), "n", false)
        return
      end
      vim.api.nvim_feedkeys(count .. vim.keycode("o<C-d>"), "n", false)
    end,
    "n",
    desc = "Begin a new line(non-indent & non-comment) below the cursor, start [count] insert",
  },
  ["<space>B"] = {
    function()
      local count = vim.v.count1
      if my.multicursor.active() and count == 1 then
        vim.api.nvim_feedkeys(count .. vim.keycode("O <bs>^<C-d>"), "n", false)
        return
      end
      vim.api.nvim_feedkeys(count .. vim.keycode("O<C-d>"), "n", false)
    end,
    "n",
    desc = "Begin a new line(non-indent & non-comment) above the cursor, start [count] insert",
  },
  ["<space><space>b"] = {
    function()
      local indent = vim.fn["repeat"](" ", vim.fn.virtcol(".") - 1)
      local count = vim.v.count1
      if my.multicursor.active() and count == 1 then
        vim.api.nvim_feedkeys(count .. vim.keycode("o <bs>^<C-d>") .. indent, "n", false)
        return
      end
      vim.api.nvim_feedkeys(count .. vim.keycode("o^<C-d>") .. indent, "n", false)
    end,
    "n",
    desc = "Begin a new line below the cursor, start [count] insert, the indent same as cursor col",
  },
  ["<space><space>B"] = {
    function()
      local indent = vim.fn["repeat"](" ", vim.fn.virtcol(".") - 1)
      local count = vim.v.count1
      if my.multicursor.active() and count == 1 then
        vim.api.nvim_feedkeys(count .. vim.keycode("O <bs>^<C-d>") .. indent, "n", false)
        return
      end
      vim.api.nvim_feedkeys(count .. vim.keycode("O^<C-d>") .. indent, "n", false)
    end,
    "n",
    desc = "Begin a new line above the cursor, start [count] insert, the indent same as cursor col",
  },
  ["<C-b>"] = { n.no_keep_cursor[-1], i.no_keep_cursor[-1] },
  ["<M-b>"] = { n.no_keep_cursor[1], i.no_keep_cursor[1] },
  ["<C-S-b>"] = { n.keep_cursor[-1], i.keep_cursor[-1] },
  ["<M-S-b>"] = { n.keep_cursor[1], i.keep_cursor[1] },
  ["<M-C-b>"] = { n.keep_cursor[0], i.keep_cursor[0] },
  ["<C-space><C-b>"] = i.no_indent[-1],
  ["<M-space><M-b>"] = i.no_indent[1],
  ["<C-space><C-space><C-b>"] = i.col_indent[-1],
  ["<M-space><M-space><M-b>"] = i.col_indent[1],
  ["[<space>"] = n.keep_cursor[-1],
  ["]<space>"] = n.keep_cursor[1],
  ["<space>["] = n.no_keep_cursor[-1],
  ["<space>]"] = n.no_keep_cursor[1],
  ["<M-space><M-[>"] = i.no_keep_cursor[-1],
  ["<M-space><M-]>"] = i.no_keep_cursor[1],
  ["<M-[><M-space>"] = i.keep_cursor[-1],
  ["<M-]><M-space>"] = i.keep_cursor[-1],
  ["<M-space><M-space><M-[>"] = i.no_indent[-1],
  ["<M-space><M-space><M-]>"] = i.no_indent[1],

  -- ["<S-CR>"] = { "<CR><Space><C-U>", "i", desc = "Begin new line(non-blank)", exclude_ft = "prompt" },
  ["<C-CR>"] = { "<CR><esc>k$a", "i", desc = "Begin new line(keep cursor)" },
  ["<S-CR>"] = { "<CR><esc>O", "i", desc = "insert new line(line break)" },
}
