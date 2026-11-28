local left_esc = {
  { "<Esc>", "i" },
  { "<C-u><ESC>", "c" },
  { "<C-\\><C-N>", "t", exclude_ft = { "yazi" } },
  desc = "Quit insert mode quickly",
}

local right_esc = {
  { "<Esc>l", "i" },
  { "<C-u><ESC>", "c" },
  { "<C-\\><C-N>", "t", exclude_ft = { "yazi" } },
  desc = "Quit insert mode quickly",
}

local esc_map = {
  {
    item = "clear multicursor",
    select = function()
      my.multicursor.clear(0, 0, -1)
    end,
    condition = function()
      return my.multicursor.active()
    end,
  },
  {
    item = "no hlsearch",
    select = function()
      vim.o.hlsearch = false
    end,
    condition = function()
      return vim.o.hlsearch
    end,
  },
  {
    item = "hlsearch",
    select = function()
      vim.o.hlsearch = true
    end,
    condition = function()
      return not vim.o.hlsearch
    end,
  },
  {
    item = "diffupdate",
    select = function()
      vim.cmd("diffupdate")
    end,
  },
}
return {
  ["<C-S-;>"] = {
    function()
      my.input_command()
    end,
    { "i", "s" },
    desc = "Input command",
  },
  [":"] = {
    function()
      my.input_command()
    end,
    "x",
    desc = "Input command",
  },
  ["0<esc>"] = {
    function()
      local actions = {}
      local items = {}
      for _, value in ipairs(esc_map) do
        local condition = not value.condition and true or value.condition()
        if condition then
          items[#items + 1] = value.item
          actions[#actions + 1] = value
        end
      end
      vim.ui.select(items, { prompt = "Super <Esc>" }, function(_, idx)
        if idx then
          actions[idx].select()
        end
      end)
    end,
    "n",
    desc = "super <esc>",
  },
  ["<M-=>"] = {
    "<C-\\>e",
    "c",
    desc = "<C-\\>e",
  },
  ["gy"] = {
    {
      function()
        local reg = vim.v.register
        vim.api.nvim_feedkeys('"' .. reg .. "y", "nx", false)
        local text = vim.fn.getreg(reg)
        text = text:gsub("\n$", "")
        vim.fn.setreg(reg, text)
      end,
      "x",
      desc = "Like y, but trim trailing \\n",
    },
    {
      function()
        return string.format('gv"%sy', vim.v.register)
      end,
      expr = true,
      "n",
    },
  },
  ["<C-space><C-v>"] = { "<C-K>", "i" },

  [","] = {
    function()
      if my.multicursor.active() then
        return ","
      end
      return ",<C-g>u"
    end,
    "i",
    expr = true,
  },
  ["."] = {
    function()
      if my.multicursor.active() then
        return "."
      end
      return ".<C-g>u"
    end,
    "i",
    expr = true,
  },
  [";"] = {
    function()
      if my.multicursor.active() then
        return ";"
      end
      return ";<C-g>u"
    end,
    "i",
    expr = true,
  },
  -- ["y:"] = {
  --   function()
  --     vim.ui.input({
  --       prompt = "Yank:",
  --       completion = "command",
  --     }, function(input)
  --       if input == "or" or input == nil then
  --         return
  --       end
  --       local output = vim.api.nvim_exec2(input, { output = true }).output
  --       vim.fn.setreg(vim.v.register, output)
  --     end)
  --   end,
  --   "n",
  --   desc = "Yank command output to register",
  -- },
  ["<leader>p:"] = {
    function()
      vim.ui.input({
        prompt = "Put:",
        completion = "command",
      }, function(input)
        if input == "or" or input == nil then
          return
        end
        local output = vim.api.nvim_exec2(input, { output = true }).output
        vim.api.nvim_put(vim.split(output, "\n"), "l", true, true)
      end)
    end,
    "n",
    desc = "Put command output",
  },
  ["<space>D"] = { "xd^", "n" },
  ["<leader>X"] = {
    "<cmd>source %<cr>",
    "n",
    { desc = "Source ths lua file" },
  },
  ["<leader>x"] = {
    {
      ":.lua<cr>",
      "n",
      { desc = "Run cursor line" },
    },
    {
      ":lua<cr>",
      "x",
      { desc = "Run selected" },
    },
  },
  ["<space>f"] = { "t", { "n", "o", "x" } },
  ["<space>F"] = { "T", { "n", "o", "x" } },
  ["<M-b>"] = { "<C-G>o<C-G>", "s", desc = "Go to Other end of highlighted text" },
  -- ["<M-bs>"] = {
  --   "s",
  --   "n"
  -- },
  -- ["<C-bs>"] = {
  --   "S",
  --   "n"
  -- },
  -- ["<space>C"] = {
  --   "v0c",
  --   "n"
  -- },
  ["<leader><F5>"] = {
    function()
      local path = vim.fn.expand("$MYVIMRC"):gsub("init.lua", "")
      vim.fn.chdir(path)
      vim.cmd("e $MYVIMRC")
    end,
    "n",
    { desc = "Edit my neovim config" },
  },
  -- gh: normal mode into select mode
  -- normal mode into select block mode
  ["<space>gh"] = { "g<C-h>", "n" },
  ["gh"] = { { "<C-g>", "x" }, { "<C-g>", "s" } },
  ["gH"] = { { "<C-g>", "s" }, { "<C-g>", "x" } },
  ["<space>r"] = { "gR", "n" },
  ["<M-f>"] = { ";", { "n" }, desc = "Repeat latest f, t, F or T [count] times" },
  ["<C-f>"] = { ",", { "n" }, desc = "Repeat latest f, t, F or T in opposite direction [count] times" },
  ["m"] = {
    function()
      if vim.v.operator == "d" or my.operator.is_delete_operator() then
        ---@diagnostic disable-next-line: param-type-mismatch
        local char = vim.fn.nr2char(vim.fn.getchar())
        if char:match("%w") or ('"^.[]'):find(char) then
          if char == '"' then
            char = "\\" .. char
          end
          vim.cmd("delmarks " .. char)
        end
      end
    end,
    "o",
    desc = "marks",
  },
  ["<space><"] = {
    function()
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, true, true), "nx", true)
      local start_row, start_col = unpack(vim.api.nvim_buf_get_mark(0, "<"))
      local end_row, end_col = unpack(vim.api.nvim_buf_get_mark(0, ">"))
      local lines = vim.api.nvim_buf_get_lines(0, start_row - 1, end_row, false)
      local min_indent

      for _, line in ipairs(lines) do
        local indent = line:find("[^%s]")
        if not min_indent then
          min_indent = indent
        else
          if indent and indent < min_indent then
            min_indent = indent
          end
        end
      end

      if not min_indent then
        return
      end

      local new_lines = {}

      for i, line in ipairs(lines) do
        new_lines[i] = line:sub(min_indent)
      end
      vim.api.nvim_buf_set_lines(0, start_row - 1, end_row, false, new_lines)
      vim.api.nvim_buf_set_mark(0, "<", start_row, start_col, {})
      vim.api.nvim_buf_set_mark(0, ">", end_row, end_col, {})
    end,
    "x",
    desc = "Delete All Indext",
  },
  ["gV"] = {
    { "`[v`]", "n", desc = "Visual Select last inserted or puted text" },
    {
      function()
        vim.api.nvim_feedkeys("`[v`]", "nx", true)
      end,
      "o",
      desc = "[Textobject]: last inserted or put text",
    },
  },
  -- ["<space>v"] = {
  --   function()
  --     vim.api.nvim_feedkeys("v", "n", true)
  --   end,
  --   "n",
  -- },
  -- virtualedit = "all"
  -- ["<space>v"] = {
  --   {
  --     "<C-v>",
  --     "x",
  --   },
  --   {
  --     function()
  --       local line = vim.api.nvim_get_current_line()
  --       local cursor = vim.api.nvim_win_get_cursor(0)
  --       if cursor[2] + 1 == #line then
  --         vim.opt.virtualedit = ""
  --         vim.api.nvim_exec2(
  --           [[
  --         execute "normal! $\<C-v>"
  --         ]],
  --           {}
  --         )
  --         vim.api.nvim_create_autocmd("ModeChanged", {
  --           group = vim.api.nvim_create_augroup("CustomModeChanged", { clear = true }),
  --           callback = function(ev)
  --             vim.opt.virtualedit = "all"
  --             return true
  --           end,
  --         })
  --       else
  --         vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-v>", true, false, true), "n", true)
  --       end
  --     end,
  --     "n",
  --   },
  --   desc = "Start visual block mode",
  -- },

  ["jk"] = left_esc,
  ["jj"] = left_esc,
  ["JK"] = left_esc,
  ["JJ"] = left_esc,
  ["kj"] = right_esc,
  ["kk"] = right_esc,
  ["KJ"] = right_esc,
  ["KK"] = right_esc,
  -- ["<C-0>"] = { "<C-o>", "i", desc = "CTRL-O" },

  ["<space>c"] = { "<cmd>close<cr>", { "n", "x" }, desc = "Close current window" },
  ["<space><space>c"] = { "<cmd>close!<cr>", { "n", "x" }, desc = "Close! current window" },
  ["<space>q"] = { "<cmd>q<cr>", { "n", "x" }, desc = "Quit" },
  ["<space><space>q"] = { "<cmd>q!<cr>", { "n", "x" }, desc = "Quit!" },
  ["<space>Q"] = { "<cmd>qa<cr>", { "n", "x" }, desc = "Quit all" },
  ["<space><space>Q"] = { "<cmd>qa!<cr>", { "n", "x" }, desc = "Quit! all" },

  ["<space><space>y"] = { '"+y', { "n", "x" } },
  ["<space><space>Y"] = { '"+Y', { "n", "x" } },
  ["<space><space>p"] = { '"+p', { "n", "x" } },
  ["<space><space>P"] = { '"+P', { "n", "x" } },
  ["<space><space>d"] = { '"+d', { "n", "x" } },

  --- register
  -- Nvim buitin: = filter operation
  -- My change: "{reg}= replace register
  -- NOTE: 这是两个完全不相关的功能，只不过 "{reg}=，刚好与原生 ={motion} 冲突，所以做了代理

  -- neovim 原生手动修改寄存器的方法:
  --        :let @/="Hello"
  ["="] = {
    function()
      local clipboard = vim.opt.clipboard:get() --[[@as table<string>]]
      local default_register = '"'
      if vim.tbl_contains(clipboard, "unnamedplus") then
        default_register = "+"
      elseif vim.tbl_contains(clipboard, "unnamed") then
        default_register = "*"
      end

      local register = vim.v.register
      if register == default_register then
        vim.api.nvim_feedkeys("=", "n", false)
      else
        local prompt
        if register:match("%u") ~= nil then
          prompt = "Register [" .. register .. "] append ⇒ "
        else
          prompt = "Register [" .. register .. "] replace ⇒ "
        end
        vim.ui.input({
          prompt = prompt,
          highlight = function(cmdline)
            local ret = {}
            local i = 0
            while i < #cmdline do
              table.insert(ret, { i, i + 1, "WarningMsg" })
              i = i + 1
            end
            return ret
          end,
        }, function(input)
          if not input then
            return
          end
          vim.fn.setreg(register, input)
        end)
      end
    end,
    "n",
  },
  ["<leader>crg"] = {
    function()
      vim.ui.input({
        prompt = "Clear register: ",
      }, function(input)
        if input then
          local reg_str = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"'
          local regs = {}
          local clear_regs = {}
          for c in reg_str:gmatch(".") do
            table.insert(regs, c)
          end
          for c in input:gmatch(".") do
            table.insert(clear_regs, c)
          end

          for _, value in ipairs(clear_regs) do
            if vim.list_contains(regs, value) then
              vim.fn.setreg(value, "")
            end
          end
        end
      end)
    end,
    "n",
    desc = "Clear registers",
  },
  --- scroll
  ["<C-k>"] = {
    "<Cmd>lua my.scroll.down()<Cr>",
    { "n", "x", "i" },
    desc = "Scroll [count] line down(cursor follow)",
  },
  ["<C-j>"] = {
    "<Cmd>lua my.scroll.up()<Cr>",
    { "n", "x", "i" },
    desc = "Scroll [count] line up(cursor follow)",
  },
  ["<C-l>"] = {
    "<Cmd>lua my.scroll.right()<Cr>",
    { "n", "x", "i" },
    desc = "Scroll [count] col right(cursor follow)",
  },
  ["<C-h>"] = {
    {
      "<Cmd>lua my.scroll.left()<Cr>",
      { "n", "x" },
    },
    {
      "<Cmd>lua my.scroll.left()<Cr>",
      "i",
    },
    desc = "Scroll [count] col left(cursor follow)",
  },
  ["<C-u>"] = {
    "<Cmd>lua my.scroll.half_page_up()<Cr>",
    { "n", "x" },
    desc = "Scroll [count] half page up",
  },
  ["<C-d>"] = {
    "<Cmd>lua my.scroll.half_page_down()<Cr>",
    { "n", "x" },
    desc = "Scroll [count] half page down",
  },
  ["<C-S-k>"] = {
    {
      "<Cmd>lua my.scroll.page_up()<Cr>",
      { "n", "x" },
    },
    {
      function()
        my.scroll.i_scroll_page_up()
      end,
      "i",
    },
    desc = "Scroll [count] page up",
  },
  ["<C-S-j>"] = {
    {
      "<Cmd>lua my.scroll.page_down()<Cr>",
      { "n", "x" },
    },
    {
      function()
        my.scroll.i_scroll_page_down()
      end,
      "i",
    },
    desc = "Scroll [count] page down",
  },
  ["<space><C-j>"] = {
    function()
      my.wo.scroll_only = not my.wo.scroll_only
      my.scroll.up()
    end,
    { "n", "x" },
    desc = "Scroll [count] line up(toggle cursor follow)",
  },
  ["<space><C-k>"] = {
    function()
      my.wo.scroll_only = not my.wo.scroll_only
      my.scroll.down()
    end,
    { "n", "x" },
    desc = "Scroll [count] line down(toggle cursor follow)",
  },
  ["<space><C-l>"] = {
    function()
      my.wo.scroll_only = not my.wo.scroll_only
      my.scroll.right()
    end,
    { "n", "x" },
    desc = "Scroll [count] col right(toggle cursor follow)",
  },
  ["<space><C-h>"] = {
    function()
      my.wo.scroll_only = not my.wo.scroll_only
      my.scroll.left()
    end,
    { "n", "x" },
    desc = "Scroll [count] col left(toggle cursor follow)",
  },
  ["gi"] = {
    function()
      local changelist = vim.fn.getchangelist(vim.api.nvim_get_current_buf())
      local idx = changelist[2]
      if idx > 0 then
        return "g;"
      end
      vim.notify("Already at the start change")
    end,
    "n",
    expr = true,
    desc = "Go to [count] older position in change list.",
  },
  ["go"] = {
    function()
      local changelist = vim.fn.getchangelist(vim.api.nvim_get_current_buf())
      local list = changelist[1]
      local idx = changelist[2]
      if idx < #list - 1 then
        return "g,"
      end
      vim.notify("Already at the last change")
    end,
    "n",
    expr = true,
    desc = "Go to [count] newer position in change list.",
  },

  --- Comment
  ["<C-/>"] = {
    {
      function()
        return require("vim._comment").operator() .. "_"
      end,
      "n",
      expr = true,
      desc = "Toggle comment line",
    },
    {
      function()
        return require("vim._comment").operator()
      end,
      "x",
      expr = true,
      desc = "Toggle Comment",
    },
    {
      function()
        require("vim._comment").textobject()
      end,
      "o",
      desc = "Comment textobject",
    },
    {
      function()
        return "<Esc>" .. require("vim._comment").operator() .. "_a"
      end,
      "i",
      desc = "Toggle Comment",
      expr = true,
    },
  },
  ["<C-_>"] = {
    {
      function()
        return require("vim._comment").operator() .. "_"
      end,
      "n",
      expr = true,
      desc = "Toggle comment line",
    },
    {
      function()
        return require("vim._comment").operator()
      end,
      "x",
      expr = true,
      desc = "Toggle Comment",
    },
    {
      function()
        require("vim._comment").textobject()
      end,
      "o",
      desc = "Comment textobject",
    },
    {
      function()
        return "<Esc>" .. require("vim._comment").operator() .. "_a"
      end,
      "i",
      desc = "Toggle Comment",
      expr = true,
    },
  },

  --- Location list
  -- ["<leader>lo"] = { "<cmd>lopen<cr>zz", "n", desc = "Open location list" },
  ["<leader>lc"] = { "<cmd>lclose<cr>zz", "n", desc = "Close location list" },
  ["<leader>lo"] = {
    function()
      ---@diagnostic disable-next-line: param-type-mismatch
      pcall(vim.cmd, "lnewer" .. vim.v.count1)
    end,
    "n",
    desc = "Newer location list",
  },
  ["<leader>li"] = {
    function()
      ---@diagnostic disable-next-line: param-type-mismatch
      pcall(vim.cmd, "lolder" .. vim.v.count1)
    end,
    "n",
    desc = "Older location list",
  },
  ["<leader>ll"] = {
    function()
      require("builtin.location").toggle()
    end,
    "n",
    desc = "Toggle Location List",
  },
  ["]l"] = {
    function()
      local function callback()
        require("builtin.location").goto_next_location()
        require("repeat").set_motion(callback)
      end
      callback()
    end,
    "n",
    desc = "Next location list",
  },
  ["[l"] = {
    function()
      local function callback()
        require("builtin.location").goto_prev_location()
        require("repeat").set_motion(callback)
      end
      callback()
    end,
    "n",
    desc = "Previous location list",
  },
  -- "[L"
  -- "]L"
  ["[<C-l>"] = {
    function()
      local count = vim.v.count1
      --- @diagnostic disable-next-line
      local ok = pcall(vim.cmd, count .. "lpfile")
      if not ok then
        vim.cmd("llast")
      end
    end,
    "n",
    desc = "Display the last location in the [count] previous file in the list that includes a file name.",
  },
  ["]<C-l>"] = {
    function()
      local count = vim.v.count1
      --- @diagnostic disable-next-line
      local ok = pcall(vim.cmd, count .. "lnfile")
      if not ok then
        vim.cmd("lfirst")
      end
    end,
    "n",
    desc = "Display the first location in the [count] next file in the list that includes a file name.",
  },

  --- Operator
  ["y"] = {
    {
      function()
        return my.operator.yank()
      end,
      "n",
      expr = true,
    },
    {
      function()
        if my.operator.is_yank_operator() then
          return "_"
        end
        return "<esc>"
      end,
      "o",
      expr = true,
    },
  },
  ["d"] = {
    {
      function()
        return my.operator.delete()
      end,
      "n",
      expr = true,
    },
    {
      function()
        if my.operator.is_delete_operator() then
          return "_"
        end
      end,
      "o",
      expr = true,
    },
  },
  ["-"] = {
    {
      function()
        return my.operator.join()
      end,
      "n",
      expr = true,
    },
    {
      function()
        if my.operator.is_join_operator() then
          return "_"
        end
      end,
      "o",
      expr = true,
    },
  },
  ["g-"] = {
    {
      function()
        return my.operator.join({ only_join = true })
      end,
      "n",
      expr = true,
    },
    {
      function()
        if my.operator.is_join_operator() then
          return "_"
        end
      end,
      "o",
      expr = true,
    },
  },
  ["gU"] = {
    {
      function()
        return my.operator.uppercase()
      end,
      "n",
      expr = true,
    },
    {
      function()
        if my.operator.is_uppercase_operator() then
          return "_"
        end
      end,
      "o",
      expr = true,
    },
  },
  ["gu"] = {
    {
      function()
        return my.operator.lowercase()
      end,
      "n",
      expr = true,
    },
    {
      function()
        if my.operator.is_lowercase_operator() then
          return "_"
        end
        return "<esc>"
      end,
      "o",
      expr = true,
    },
  },

  --- Jump
  ["`'"] = {
    function()
      my.motion.jump.jump_prev(-1)
    end,
    "n",
    desc = "Go to last position of jumplist",
  },
  ["<C-i>"] = {
    function()
      my.motion.jump(-vim.v.count1, { scope = "global" })
    end,
    { "n", "x" },
    desc = "Go to [count] older cursor position",
  },
  ["<C-o>"] = {
    function()
      my.motion.jump(vim.v.count1, { scope = "global" })
    end,
    { "n", "x" },
    desc = "Go to [count] newer cursor position",
  },
  ["<C-S-i>"] = {
    function()
      my.motion.jump.buffer(-vim.v.count1)
    end,
    "n",
    desc = "Go to [count] older buffer[last cursor position]",
  },
  ["<C-S-o>"] = {
    function()
      my.motion.jump.buffer(vim.v.count1)
    end,
    "n",
    desc = "Go to [count] newer buffer[first cursor position]",
  },
  ["<C-M-i>"] = {
    function()
      my.motion.jump(-vim.v.count1, { scope = "local" })
    end,
    "n",
    desc = "Go to [count] older cursor position[current buffer]",
  },
  ["<C-M-o>"] = {
    function()
      my.motion.jump(vim.v.count1, { scope = "local" })
    end,
    "n",
    desc = "Go to [count] newer cursor position[current buffer]",
  },

  -- Fold
  ["<CR>"] = {
    function()
      if vim.fn.foldlevel(vim.fn.line(".")) > 0 then
        return "zo"
      end
    end,
    "n",
    expr = true,
    exclude_ft = { "prompt", "qf", "neo-tree", "netrw", "oil" },
  },
  -- ["<S-CR>"] = {
  --   "zMzv",
  --   "n",
  --   desc = "Focus current Fold",
  -- },
}
