require("auto-command")
require("options").setup()
require("repeat").setup()
local K = require("plugin-keymap")
K.setup()
require("win-action").setup()
require("register-control").setup()

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { import = "plugins" },
  { import = "custom.lazy-plugins.concat-mode" },
  { import = "custom.lazy-plugins.show-file-info" }
})

K.add({
  ["<F9>"] = {
    function()
      local pickers = require("telescope.pickers")
      local finders = require("telescope.finders")
      local conf = require("telescope.config").values
      local actions = require("telescope.actions")
      local action_state = require("telescope.actions.state")
      local previewers = require("telescope.previewers")
      local custom_picker = function(opts)
        -- 定义要显示的数据
        local items = {
          { name = "选项1", description = "这是选项1的描述", content = "选项1的详细内容..." },
          { name = "选项2", description = "这是选项2的描述", content = "选项2的详细内容..." },
          { name = "选项3", description = "这是选项3的描述", content = "选项3的详细内容..." },
        }

        -- 创建选择器
        pickers.new(opts, {
          prompt_title = "自定义选择器",
          finder = finders.new_table({
            results = items,
            entry_maker = function(entry)
              return {
                value = entry,
                display = entry.name,
                ordinal = entry.name,
              }
            end,
          }),
          sorter = conf.generic_sorter(opts),
          -- 配置预览窗口
          previewer = previewers.new_buffer_previewer({
            title = "预览",
            define_preview = function(self, entry)
              local lines = {}
              table.insert(lines, "名称: " .. entry.value.name)
              table.insert(lines, "描述: " .. entry.value.description)
              table.insert(lines, "")
              table.insert(lines, "详细内容:")
              table.insert(lines, entry.value.content)

              vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)
            end,
          }),
          -- 配置选择动作
          attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
              local selection = action_state.get_selected_entry()
              actions.close(prompt_bufnr)
              -- 在这里处理选择结果
              require("nvim-extmark-doc").extmark_doc()
              print("已选择: " .. selection.value.name)
            end)
            return true
          end,
        }):find()
      end
      custom_picker()
    end,
    "n"
  },
  ["<F8>"] = {
    function()
      vim.api.nvim_create_user_command('Custom',
        function(opts)
          print(vim.inspect(opts))
        end,
        {
          nargs = "+",
          range = "%",
          preview = function(opts, ns, buf)
            print("fdafadasfdasf")
            print(vim.inspect(opts), ns, buf)
          end,
          complete = "color",
        })
    end,
    "n",
  },
  ["<F7>"] = {
    function()
      -- local ns_id = vim.api.nvim_create_namespace('advanced_ui')
      --
      -- -- 创建可能需要特殊 UI 渲染的标记
      -- vim.api.nvim_buf_set_extmark(0, ns_id, 0, 0, {
      --   virt_text = { { "点击展开", "Special" } },
      --   ui_watched = true,
      --   -- UI 可以处理这些自定义属性
      --   -- ui_properties = {
      --   --   interactive = true,
      --   --   tooltip = "点击查看更多信息",
      --   --   custom_render = "expandable_section"
      --   -- }
      -- })

      -- local ns_id = vim.api.nvim_create_namespace('url_demo')
      --
      -- -- 创建一个简单的链接
      -- vim.api.nvim_buf_set_extmark(0, ns_id, 0, 0, {
      --   end_col = 10,
      --   hl_group = "Underlined", -- 添加下划线
      --   url = "https://github.com",
      -- })

      -- local ns_id = vim.api.nvim_create_namespace('line_conceal_demo')

      -- -- 隐藏一行
      -- vim.api.nvim_buf_set_extmark(0, ns_id, 1, 0, {
      --     end_row = 1,  -- 同一行
      --     conceal_lines = ''  -- 空字符串表示隐藏
      -- })

      -- 隐藏多行
      -- vim.api.nvim_buf_set_extmark(0, ns_id, 3, 0, {
      --     end_row = 5,  -- 隐藏第3行到第5行
      --     conceal_lines = ''
      -- })

      -- local ns_id = vim.api.nvim_create_namespace('code_preview')
      --
      -- vim.api.nvim_buf_set_extmark(0, ns_id, 2, 0, {
      --   virt_lines = {
      --     -- 代码预览标题
      --     {
      --       { "┌", "Special" },
      --       { "─ 代码预览 ", "Title" },
      --       { "─────────────", "Special" }
      --     },
      --     -- 代码内容
      --     {
      --       { "│", "Special" },
      --       { " function example() {", "Function" }
      --     },
      --     {
      --       { "│", "Special" },
      --       { "   console.log('Hello');", "String" }
      --     },
      --     {
      --       { "│", "Special" },
      --       { " }", "Function" }
      --     },
      --     -- 底部边框
      --     {
      --       { "└", "Special" },
      --       { "─────────────────────", "Special" }
      --     }
      --   },
      --   virt_lines_above = true, -- 在当前行上方显示
      --   sign_text = "●", -- 符号文本
      --   cursorline_hl_group = "ErrorMsg", -- 符号高亮组
      -- })

      -- local ns_id = vim.api.nvim_create_namespace('gravity_demo')
      --
      -- -- 在同一位置创建两个标记，一个左引力，一个右引力
      -- vim.api.nvim_buf_set_extmark(0, ns_id, 0, 5, {
      --   virt_text = { { "←左引力", "Comment" } },
      --   right_gravity = false, -- 左引力
      --   priority = 100
      -- })
      --
      -- vim.api.nvim_buf_set_extmark(0, ns_id, 0, 5, {
      --   virt_text = { { "右引力→", "Comment" } },
      --   right_gravity = false, -- 右引力
      --   priority = 100
      -- })


      -- local ns_id = vim.api.nvim_create_namespace('virtual_lines')
      -- -- 示例2：hl_eol = true
      -- -- vim.api.nvim_buf_set_extmark(0, ns_id, 2, 0, {
      -- --   end_col = 22,
      -- --   sign_text = "|",
      -- --   hl_group = "Search",
      -- --   right_gravity = false
      -- -- })
      --
      -- vim.api.nvim_buf_set_extmark(0, ns_id, 2, 0, {
      --   virt_lines = {
      --     { { "VVirtual Line 1Virtual Line 1Virtual Line 1Virtual Line 1Virtual Line 1Virtual Line 1Virtual Line 1Virtual Line 1Virtual Line 1Virtual Line 1Virtual Line 1Virtual Line 1Virtual Line 1Virtual Line 1Virtual Line 1Virtual Line 1Virtual Line 1Virtual Line 1Virtual Line 1Virtual Line 1irtual Line 1", "Comment" } },
      --     { { "VVirtual Line 1Virtual Line 1Virtual Line 1Virtual Line 1Virtual Line 1Virtual Line 1Virtual Line 1Virtual Line 1Virtual Line 1Virtual Line 1Virtual Line 1Virtual Line 1Virtual Line 1Virtual Line 1Virtual Line 1Virtual Line 1Virtual Line 1Virtual Line 1Virtual Line 1Virtual Line 1irtual Line 1", "String" } }
      --   },
      --   virt_lines_above = true,
      --   sign_text = "|",
      -- })
    end,
    "n",
  },
  ["<F10>"] = {
    function()
      print(vim.inspect(vim))
      -- local count = 0
      -- vim.api.nvim_buf_attach(0, false, {
      --   on_lines = function(_, bufnr, changedtick, first, last_old, last_new, byte_count)
      --     --   -- first 改变的第一行, 从 0 开始
      --     --   -- last_old 改变的最后一行
      --     --   -- last_new 更新范围的最后一行
      --     --   -- byte_count 先前内容的字节数
      --     --   -- print("改变的第一行: ", first)
      --     --   -- print("改变的最后一行: ", last_old)
      --     --   -- print("更新范围的最后一行", last_new)
      --     --   -- print("byte_count: ", byte_count)
      --     --   -- print("----------------------------------")
      --     print("on_lines")
      --     count = count + 1
      --     if count == 5 then
      --       return true
      --     end
      --   end,
      --
      --   -- on_bytes = function(_, bufnr, changedtick, first, first_col, offset, last_old, last_old_col, old_byte, last_new,
      --   --                     last_new_col, new_byte)
      --   --   count = count + 1
      --   --   if count == 10 then
      --   --     return true
      --   --   end
      --   --   print("改变文本的起始行（从零开始）", first)
      --   --   print("改变文本的起始列a", first_col)
      --   --   print("改变文本的字节偏移量（从缓冲区开始）", offset)
      --   --   print("改变文本的旧结束行（从起始行偏移）", last_old)
      --   --   print("改变文本的旧结束列（如果旧结束行 = 0，从起始列偏移）", last_old_col)
      --   --   print("改变文本的旧结束字节长度", old_byte)
      --   --   print("改变文本的新结束行（从起始行偏移）", last_new)
      --   --   print("改变文本的新结束列（如果新结束行 = 0，从起始列偏移）", last_new_col)
      --   --   print("改变文本的新结束字节长度", new_byte)
      --   --   -- • on_bytes: 在更改时调用的 Lua 回调。
      --   --   --             与 on_lines 相比，此回调接收有关更改的更细粒度的信息。
      --   --   --             返回一个真值（不是 `false` 或 `nil`）以分离。
      --   --   --  参数：
      --   --   --   • 字符串 "bytes"
      --   --   --   • 缓冲区 id
      --   --   --   • b:changedtick
      --   --   --   • 改变文本的起始行（从零开始）
      --   --   --   • 改变文本的起始列
      --   --   --   • 改变文本的字节偏移量（从缓冲区开始）
      --   --   --   • 改变文本的旧结束行（从起始行偏移）
      --   --   --   • 改变文本的旧结束列（如果旧结束行 = 0，从起始列偏移）
      --   --   --   • 改变文本的旧结束字节长度
      --   --   --   • 改变文本的新结束行（从起始行偏移）
      --   --   --   • 改变文本的新结束列（如果新结束行 = 0，从起始列偏移）
      --   --   --   • 改变文本的新结束字节长度
      --   -- end,
      --   on_detach = function()
      --     print("分离")
      --   end
      -- })
      -- vim.api.nvim_buf_detach()
      -- require("nvim-extmark-doc").extmark_doc()
      -- require("search-manual").searchManual()
    end,
    "n",
  },
  ["<C-[>"] = { "<C-O>", "n" },
  ["<M-->"] = { "J", "x" },
  ["<C-.>"] = { "<C-T>", "i" },
  ["<C-space><C-,>"] = { "0<C-D>", "i" },
  ["<C-,>"] = { "<C-D>", "i" },
  ["<C-space><C-.>"] = { "^<C-D>", "i" },
  ["<M-b>"] = {
    "<C-G>o<C-G>",
    "s"
  },
  ["a"] = {
    "<nop>",
    "n"
  },
  ["s"] = {
    "<nop>",
    "n"
  },
  ["<bs>"] = {
    "x",
    "n"
  },
  ["<S-bs>"] = {
    "X",
    "n"
  },
  ["<M-bs>"] = {
    "s",
    "n"
  },
  ["<C-bs>"] = {
    "S",
    "n"
  },
  ["<space>C"] = {
    "v0c",
    "n"
  },
  ["<M-d>"] = {
    { "<nop>", "n" }
  },
  ["<C-d>"] = {
    { "<C-O>d", "i" }
  },
  ["<M-y>"] = {
    "<left><C-o>y<right>",
    "i"
  }
})
