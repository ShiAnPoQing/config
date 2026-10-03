return {
  -- Nvim buitin: = filter operation
  -- My change: "{reg}= replace register
  -- NOTE: 这是两个完全不相关的功能，只不过 "{reg}=，刚好与原生 ={motion} 冲突，所以做了代理

  -- neovim 原生手动修改寄存器的方法:
  --        :let @/="Hello"
  ["="] = {
    function()
      local clipboard = vim.opt.clipboard:get()
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
}
